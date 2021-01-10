import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_test/models/YoutubeSearchResult.dart';
import 'package:youtube_test/models/YoutubeVideoResponse.dart';

const int MAX_SEARCH_RESULTS = 10;
const String API_KEY = "AIzaSyACh0o_jF1bECZlQ44NPAdp5Z2G3zNfmgU";

class YoutubeDataSource {
  final http.Client client;

  YoutubeDataSource(this.client);

  final String _searchBaseUrl =
      'https://www.googleapis.com/youtube/v3/search?part=snippet' +
          '&maxResults=$MAX_SEARCH_RESULTS&type=video&key=$API_KEY';

//  Future<String> parseTest() async {
//    final response = await client
//        .get("https://www.youtube.com/results?search_query=100kila");
//WebV
//    var document = parse(response.body);
//    var data = document.getElementsByClassName("text-wrapper");
//    var allElements = document.getElementsByTagName("a");
//    print(document.getElementsByTagName("p").length);
//  }

  Future<YoutubeSearchResult> searchVideos({
    String query,
    String pageToken = '',
  }) async {
    final urlRaw = _searchBaseUrl +
        '&q=$query' +
        (pageToken.isNotEmpty ? '&pageToken=$pageToken' : '');

    final urlEncoded = Uri.encodeFull(urlRaw);
    final response = await client.get(urlEncoded);

    if (response.statusCode == 200) {
      return YoutubeSearchResult.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<YoutubeVideoResponse> fetchVideoInfo(String youtube_url) async {
    final url = "https://www.youtube.com/oembed?url=$youtube_url&format=json";
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final objResponse =
          YoutubeVideoResponse.fromJson(json.decode(response.body));
      objResponse.video_url = youtube_url;
      return objResponse;
    } else {
      return null;
    }
  }
}
