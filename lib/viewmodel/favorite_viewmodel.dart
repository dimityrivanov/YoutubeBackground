import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_test/helpers/locator.dart';
import 'package:youtube_test/models/SongObj.dart';
import 'package:youtube_test/services/LocalStorageService.dart';
import 'package:youtube_test/services/player_service.dart';

class FavoriteViewModel {
  final LocalStorageService _storageService = locator<LocalStorageService>();
  final PlayerService playerService = locator<PlayerService>();
  StreamController _songsController;

  StreamSink<List<String>> get songListSink => _songsController.sink;

  Stream<List<String>> get songListStream => _songsController.stream;

  FavoriteViewModel() {
    _songsController = StreamController<List<String>>();
  }

  Stream<AudioPlayerState> get onPlayerStateChanged =>
      playerService.onPlayerStateChanged;

  int getListSize() {
    final songItems = _storageService.getSongs();

    if (songItems == null) {
      return 0;
    } else {
      return songItems.length;
    }
  }

  void getAllFavoriteSongs() {
    final songItems = _storageService.getSongs();

    if (songItems == null) {
      songListSink.add(List<String>());
    } else {
      songListSink.add(songItems);
    }
  }

  storeFavoriteSongs(List<String> songs) {
    _storageService.songs = songs;
  }

  void stopMusic() async {
    playerService.stopMusic();
  }

  void pauseMusic() async {
    playerService.pauseMusic();
  }

  Stream<Video> searchResults(searchQuery) {
    return playerService.getVideoBySearchTerm(searchQuery);
  }

  void playMusic(SongObj songData) async {
    var manifest = await playerService.getVideoManifest(songData.url);

    var audioURL = Platform.isAndroid
        ? manifest.audioOnly.withHighestBitrate().url.toString()
        : manifest.audioOnly.first.url.toString();

//    var audioURL = manifest.audioOnly.withHighestBitrate().url.toString();

    playerService.playMusicFromUrl(audioURL);
  }

  bool containsSong(songURL) {
    try {
      var storedSongs = _storageService.getSongs();

      if (storedSongs == null) return false;

      final songList = storedSongs.map((e) {
        return SongObj.fromJson(json.decode(e));
      }).toList();

      final songExist =
          songList.where((element) => element.url == songURL).toList();

      if (songExist.length != 0) {
        return true;
      }
    } catch (ex) {
      return false;
    }
    return false;
  }

  bool removeSong(songURL) {
    try {
      final storedSongs = _storageService.getSongs();
      var deleted = false;

      for (var songIndex = 0; songIndex < storedSongs.length; songIndex++) {
        final songObj = SongObj.fromJson(json.decode(storedSongs[songIndex]));

        if (songObj.url == songURL) {
          storedSongs.remove(storedSongs[songIndex]);
          deleted = true;
        }
      }

      if (deleted) {
        storeFavoriteSongs(storedSongs);
        return true;
      }
    } catch (ex) {
      return false;
    }
    return false;
  }

  Future<bool> addSong(url) async {
    try {
      var storedSongs = _storageService.getSongs();

      if (storedSongs == null) storedSongs = List<String>();

      if (containsSong(url)) return false;

      var video = await playerService.getVideoInfo(url);

      var song = SongObj(
          name: video.title,
          url: url,
          author: video.author,
          thumb_url: video.thumbnails.highResUrl,
          time: video.duration.toString());

      storedSongs.add(json.encode(song));
      songListSink.add(storedSongs);
      storeFavoriteSongs(storedSongs);
    } catch (ex) {
      return false;
    }
    return true;
  }

  dispose() {
    _songsController.close();
    playerService.dispose();
  }
}
