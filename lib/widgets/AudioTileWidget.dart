import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:youtube_test/helpers/locator.dart';
import 'package:youtube_test/services/player_service.dart';

class AudioTileWidget extends StatefulWidget {
  @override
  _AudioTileWidgetState createState() => _AudioTileWidgetState();
}

class _AudioTileWidgetState extends State<AudioTileWidget> {
  final PlayerService _playerService = locator<PlayerService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _playerService.onPlayerStateChanged,
      builder: (ctx, AsyncSnapshot<AudioPlayerState> data) {
        if (data.hasData) {
          if (data.data == AudioPlayerState.PLAYING) {
            return Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.4),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 35.0,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }

        return Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.4),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 35.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
