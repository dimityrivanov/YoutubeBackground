import 'package:flutter/material.dart';
import 'package:youtube_test/dialogs/premium_dialog.dart';

class DialogHelper {
  static buyPremium(context) => showDialog(
      context: context, builder: (BuildContext context) => PremiumDialog());
}
