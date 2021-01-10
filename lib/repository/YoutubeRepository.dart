import 'package:youtube_test/models/SearchItem.dart';
import 'package:youtube_test/models/YoutubeVideoResponse.dart';
import 'package:youtube_test/services/api_service.dart';

class YoutubeRepository {
  YoutubeDataSource _youtubeDataSource;

  YoutubeRepository(this._youtubeDataSource);

  Future<List<SearchItem>> searchVideos(String query) async {
    final searchResult = await _youtubeDataSource.searchVideos(query: query);
    if (searchResult.items.isEmpty) throw NoSearchResultsException();
    return searchResult.items;
  }

  Future<YoutubeVideoResponse> fetchVideoInfo(String youtube_url) async {
    final videoResponse = await _youtubeDataSource.fetchVideoInfo(youtube_url);
    if (videoResponse == null) throw NoSuchVideoException();
    return videoResponse;
  }
}

class NoSearchResultsException implements Exception {
  final message = 'No results';
}

class SearchNotInitiatedException implements Exception {
  final message = 'Cannot get the next result page without searching first.';
}

class NoNextPageTokenException implements Exception {}

class NoSuchVideoException implements Exception {
  final message = 'No such video';
}
