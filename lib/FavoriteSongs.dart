import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youtube_test/models/SongObj.dart';
import 'package:youtube_test/viewmodel/favorite_viewmodel.dart';
import 'package:youtube_test/widgets/FavoriteListTile.dart';
import 'package:youtube_test/widgets/HeaderWidget.dart';
import 'package:youtube_test/widgets/panel.dart';

class FavoriteSongsPage extends StatefulWidget {
  final FavoriteViewModel viewModel;
  final PanelController panelController;

  FavoriteSongsPage({Key key, this.viewModel, this.panelController})
      : super(key: key);

  @override
  _FavoriteSongsPageState createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage> {
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

  void playMusic(SongObj songData) async {
    //user send same song
    if (widget.viewModel.playerService.currentSong.url == songData.url) {
      if (widget.panelController.isPanelClosed) widget.panelController.open();
      return;
    }

//    if (!widget.panelController.isPanelShown) widget.panelController.show();
    widget.viewModel.playerService.currentSong = songData;
    widget.viewModel.playMusic(songData);
  }

  @override
  void initState() {
    super.initState();

    widget.viewModel.playerService.songsStream.listen((event) {
      setState(() {});
    });

    widget.viewModel.getAllFavoriteSongs();
  }

  @override
  Widget build(BuildContext context) {
    final listSize = MediaQuery.of(context).size.height * 0.86;

    return Scaffold(
      body: StreamBuilder<List<String>>(
          stream: widget.viewModel.songListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: listSize,
                child: ListView.builder(
                    itemCount: snapshot.data.length + 1,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return HeaderWidget(
                          title: "Favorite songs",
                        );
                      }

                      SongObj obj = SongObj.fromJson(
                          json.decode(snapshot.data[index - 1]));

                      return Dismissible(
                        onDismissed: (direction) {
                          setState(() {
                            snapshot.data.removeAt(index - 1);
                            widget.viewModel.removeSong(obj.url);
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        key: UniqueKey(),
                        child: MusicListTile(
                          song: obj,
                          onTap: playMusic,
                          isPlaying:
                              widget.viewModel.playerService.currentSong.url ==
                                      obj.url
                                  ? true
                                  : false,
                        ),
                      );
                    }),
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              );
            }
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
