import 'package:flutter/material.dart';
import 'package:youtube_test/models/SongObj.dart';
import 'package:youtube_test/viewmodel/favorite_viewmodel.dart';
import 'package:youtube_test/widgets/AudioControllerWidget.dart';
import 'package:youtube_test/widgets/panel.dart';

class AudioPlayerWidget extends StatelessWidget {
  final PanelController panelController;
  final FavoriteViewModel viewModel;
  final VoidCallback onNewSongAdded;

  AudioPlayerWidget(
      {this.panelController, this.viewModel, this.onNewSongAdded});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SongObj>(
        stream: viewModel.playerService.songsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      viewModel.playerService.currentSong.name != null
                          ? viewModel.playerService.currentSong.name
                          : "",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                viewModel.playerService.currentSong.thumb_url != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Image.network(
                            viewModel.playerService.currentSong.thumb_url),
                      )
                    : Container(),
                AudioControllerWidget(
                  controller: panelController,
                  viewModel: viewModel,
                  onAddedToFavorite: onNewSongAdded,
                ),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: Text(
              "[SELECT SONG TO PLAY]",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          );
        });
  }
}
