import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:youtube_test/models/SongObj.dart';
import 'package:youtube_test/viewmodel/favorite_viewmodel.dart';
import 'package:youtube_test/widgets/panel.dart';

class AudioControllerWidget extends StatefulWidget {
  final PanelController controller;
  final FavoriteViewModel viewModel;
  final VoidCallback onAddedToFavorite;

  const AudioControllerWidget(
      {this.controller, this.viewModel, this.onAddedToFavorite});

  @override
  _AudioControllerWidgetState createState() => _AudioControllerWidgetState();
}

class _AudioControllerWidgetState extends State<AudioControllerWidget> {
  Stream<AudioPlayerState> stream;
  Stream<Duration> streamAudio;

  @override
  void initState() {
    this.stream = widget.viewModel.playerService.onPlayerStateChanged;
    this.streamAudio = widget.viewModel.playerService.onAudioPositionChanged;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: streamAudio,
          builder: (_, AsyncSnapshot<Duration> snapdata) {
            return Slider(
              onChanged: (v) {},
              value: snapdata.hasData == false
                  ? 0.0
                  : snapdata.data.inSeconds.toDouble(),
              max: snapdata.hasData == false
                  ? 0.0
                  : widget.viewModel.playerService
                      .getSongDuration()
                      .inSeconds
                      .toDouble(),
              min: 0,
              activeColor: Colors.red,
            );
          },
        ),
        StreamBuilder(
          stream: stream,
          builder: (ctx, AsyncSnapshot<AudioPlayerState> data) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.viewModel.containsSong(widget
                                .viewModel.playerService.currentSong.url) ==
                            false
                        ? GestureDetector(
                            onTap: widget.onAddedToFavorite,
                            child: Icon(
                              Icons.add_circle,
                              size: 50.0,
                            ),
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.grey,
                            size: 50.0,
                          ),
                    GestureDetector(
                      onTap: () {
                        if (widget.viewModel.playerService.playerState ==
                                AudioPlayerState.PAUSED ||
                            widget.viewModel.playerService.playerState ==
                                AudioPlayerState.COMPLETED) {
                          if (widget.viewModel.playerService.playerState ==
                              AudioPlayerState.COMPLETED) {
                            widget.viewModel.playMusic(
                                widget.viewModel.playerService.currentSong);
                          } else {
                            widget.viewModel.playerService.resumeMusic();
                          }
                        } else {
                          widget.viewModel.playerService.pauseMusic();
                        }
                      },
                      child: Icon(
                        data.data == AudioPlayerState.PAUSED ||
                                data.data == AudioPlayerState.COMPLETED
                            ? Icons.play_arrow
                            : Icons.pause,
                        size: 80.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.viewModel.playerService.stopMusic();
                        widget.viewModel.playerService.currentSong =
                            SongObj(url: "");
//                        widget.controller.hide();
                      },
                      child: Icon(
                        Icons.stop,
                        size: 80.0,
                      ),
                    ),
//                    Icon(
//                      Icons.fast_forward,
//                      color: Colors.grey,
//                      size: 80.0,
//                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
