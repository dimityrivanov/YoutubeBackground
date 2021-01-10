import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as WidgetContainer;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_test/models/SongObj.dart';
import 'package:youtube_test/viewmodel/favorite_viewmodel.dart';
import 'package:youtube_test/widgets/FavoriteListTile.dart';
import 'package:youtube_test/widgets/HeaderWidget.dart';
import 'package:youtube_test/widgets/panel.dart';

class SearchPage extends StatefulWidget {
//  final String initialUrl;
  final FavoriteViewModel viewModel;
  final PanelController panelController;

  const SearchPage({Key key, this.viewModel, this.panelController})
      : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final videosList = List<Video>();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
  }

  void updateQuery(query) {
    setState(() {
      searchTerm = query;
      videosList.clear();
    });

    widget.viewModel.searchResults(query).listen((video) {
      setState(() {
        videosList.add(video);
      });
    });
  }

  void playMusic(SongObj songData) async {
    //user send same song
    if (widget.viewModel.playerService.currentSong.url == songData.url) {
      if (widget.panelController.isPanelClosed) widget.panelController.open();
      return;
    }

    widget.viewModel.playerService.currentSong = songData;
    widget.viewModel.playMusic(songData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final listSize = MediaQuery.of(context).size.height * 0.86;

    return searchTerm.isEmpty
        ? Center(
            child: Text("Тype something to search in youtube"),
          )
        : WidgetContainer.Container(
            height: listSize,
            child: videosList.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: videosList.length + 1,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return HeaderWidget(
                          title: "Search Term: $searchTerm",
                        );
                      }

                      final videoIndex = index - 1;
                      SongObj obj = SongObj();
                      obj.author = videosList[videoIndex].author;
                      obj.thumb_url =
                          "https://i.ytimg.com/vi/${videosList[videoIndex].id.value}/sddefault.jpg";
                      obj.url =
                          "https://www.youtube.com/watch?v=${videosList[videoIndex].id.value}";
                      obj.time = videosList[videoIndex].duration.toString();
                      obj.name = videosList[videoIndex].title;
//          obj.thumb_url = videosList[videoIndex].thumbnails.standardResUrl;

                      return MusicListTile(
                        song: obj,
                        onTap: playMusic,
                        isPlaying:
                            widget.viewModel.playerService.currentSong.url ==
                                    obj.url
                                ? true
                                : false,
                      );
                    }),
          );
  }
}
