import 'package:flutter/material.dart';
import 'package:youtube_test/models/SongObj.dart';
import 'package:youtube_test/widgets/AudioTileWidget.dart';

class MusicListTile extends StatefulWidget {
  final SongObj song;
  final Function(SongObj) onTap;
  final bool isPlaying;

  const MusicListTile({this.song, this.onTap, this.isPlaying});

  @override
  _MusicListTileState createState() => _MusicListTileState();
}

class _MusicListTileState extends State<MusicListTile> {
  _buildSongTimeWidget() {
    return Positioned(
      bottom: 5,
      right: 5,
      child: Text(
        "${widget.song.time.split(":")[1]}: ${widget.song.time.split(":")[2].split(".")[0]}",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(widget.song),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.song.thumb_url,
                    fit: BoxFit.fill,
                    height: 110.0,
                    width: 110.0,
                  ),
                ),

                widget.isPlaying
                    ? Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AudioTileWidget(),
                      )
                    : Container(),
//                Positioned(
//                  top: 0,
//                  left: 0,
//                  right: 0,
//                  bottom: 0,
//                  child: Icon(
//                    widget.isPlaying ? Icons.stop : Icons.play_arrow,
//                    color: Colors.white,
//                    size: 30.0,
//                  ),
//                ),
                _buildSongTimeWidget(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    widget.song.name,
                    maxLines: 3,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                widget.isPlaying
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          widget.isPlaying ? "Now playing" : "",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
