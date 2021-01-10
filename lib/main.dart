import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:youtube_test/FavoriteSongs.dart';
import 'package:youtube_test/SearchPage.dart';
import 'package:youtube_test/helpers/dialog_helper.dart';
import 'package:youtube_test/helpers/locator.dart';
import 'package:youtube_test/services/BillingService.dart';
import 'package:youtube_test/viewmodel/favorite_viewmodel.dart';
import 'package:youtube_test/widgets/AudioPlayerWidget.dart';
import 'package:youtube_test/widgets/panel.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    InAppPurchaseConnection.enablePendingPurchases();
    await setupLocator();
    runApp(MyApp());
  } catch (error) {
    print('Locator setup has failed');
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentSelectedIndex = 0;
  List<Widget> tabs = [];
  bool isSearching = false;
  final _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _viewModel = FavoriteViewModel();
  final panelController = PanelController();
  final snackBar = SnackBar(content: Text('New song added to favorite!!!'));
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<SearchPageState> searchPageState = GlobalKey();
  StreamSubscription _intentDataStreamSubscription;
  bool _appFullVersionIsPaid = true;

  @override
  void initState() {
    super.initState();

    tabs.add(FavoriteSongsPage(
      viewModel: _viewModel,
      panelController: panelController,
    ));

    tabs.add(SearchPage(
      key: searchPageState,
      viewModel: _viewModel,
      panelController: panelController,
    ));

    locator<BillingService>().appPaid = () {
      setState(() {
        _appFullVersionIsPaid = true;
      });
    };

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String videoURL) {
      addMusic(videoURL);
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    ReceiveSharingIntent.getInitialText().then((String videoURL) {
      if (videoURL != null && videoURL.isNotEmpty) {
        addMusic(videoURL);
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context, title) {
    AlertDialog alert = AlertDialog(
      content: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(title),
          )
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addMusic(url) async {
    if (_viewModel.getListSize() > 5 && !_appFullVersionIsPaid) {
      DialogHelper.buyPremium(context);
      return;
    }

    showAlertDialog(context, "Getting audio source, please wait");

    _viewModel.addSong(url).then((songAdded) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Youtube URL'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter URL';
                  }

                  var expression = RegExp(
                      r'^(http(s)??\:\/\/)?(www\.)?(((m.)?youtube\.com\/watch\?v=)|(youtu.be\/))([a-zA-Z0-9\-_])+$');

                  if (!expression.hasMatch(value)) {
                    return "Invalid Youtube URL!";
                  }

                  return null;
                },
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Enter Youtube URL"),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Add'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.of(context).pop();
                    addMusic(_textFieldController.text.toString());
                    _textFieldController.clear();
                  }
                },
              ),
              new FlatButton(
                child: new Text('Close'),
                onPressed: () {
                  _textFieldController.clear();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _updateSearchState() {
    setState(() {
      isSearching = !isSearching;

      if (!isSearching) {
        _currentSelectedIndex = 0;
      } else {
        _currentSelectedIndex = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final panelSize = MediaQuery.of(context).size.height * 0.08;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: isSearching
            ? TextField(
                onSubmitted: (value) {
                  searchPageState.currentState.updateQuery(value);
                },
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                decoration: InputDecoration(
                    hintText: "Type to search in youtube",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30.0,
                      color: Colors.white,
                    )),
              )
            : Text(
                'Youtube Background',
                style: TextStyle(color: Colors.white),
              ),
        actions: <Widget>[
          IconButton(
              onPressed: () => _displayDialog(context),
              icon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.add,
                  size: 35.0,
                ),
              )),
          IconButton(
            onPressed: () => _updateSearchState(),
            icon: Icon(
              isSearching ? Icons.cancel : Icons.search,
              size: 30.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(32.0), topLeft: Radius.circular(32.0)),
        minHeight: panelSize,
        controller: panelController,
        defaultVisible: true,
        panel: AudioPlayerWidget(
          panelController: panelController,
          viewModel: _viewModel,
          onNewSongAdded: () {
            addMusic(_viewModel.playerService.currentSong.url);
          },
        ),
        body: IndexedStack(
          index: _currentSelectedIndex,
          children: tabs,
        ),
      ),
    );
  }
}
