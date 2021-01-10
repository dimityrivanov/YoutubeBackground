import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class BillingService {
  /// Is the API available on the device
  bool _available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Products that are purchased
  List<PurchaseDetails> _purchases = [];

  //subscription for new order
  StreamSubscription _subscription;
  VoidCallback appPaid;

  final String full_app_id = 'full_app';

  /// Initialize data
  void initialize() async {
    // Check availability of In App Purchases
    _available = await _iap.isAvailable();

    if (_available) {
      await _getProducts();
      await _getPastPurchases();

      // Verify and deliver a purchase with your own business logic
      _verifyPurchase();

      _subscription = _iap.purchaseUpdatedStream.listen((data) {
        _purchases.clear();
        _purchases.addAll(data);
        _verifyPurchase();
      });
    }
  }

  void setVoidCallback(VoidCallback appPaid) => this.appPaid = appPaid;

  void buyAppFullVersion() async {
    if (_products.length == 0) return;

    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: _products.first);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
//    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([full_app_id]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    if (!response.notFoundIDs.isEmpty) {
      // Handle the error.
      return;
    }

    _products = response.productDetails;
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    if (response != null &&
        response.pastPurchases != null &&
        response.pastPurchases.length != 0 &&
        response.pastPurchases.first.billingClientPurchase.isAcknowledged) {
      appPaid();
    }

    for (PurchaseDetails purchase in response.pastPurchases) {
      final pending = Platform.isIOS
          ? purchase.pendingCompletePurchase
          : !purchase.billingClientPurchase.isAcknowledged;

      if (pending) {
        await _iap.completePurchase(purchase);
      }
    }
    _purchases = response.pastPurchases;
  }

  /// Your own business logic to setup a consumable
  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(full_app_id);

    if (purchase != null && !purchase.billingClientPurchase.isAcknowledged) {
      _iap.completePurchase(purchase);
    }

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      appPaid();
    }
  }
}
