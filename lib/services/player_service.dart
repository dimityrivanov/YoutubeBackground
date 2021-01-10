import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_test/models/SongObj.dart';

class PlayerService {
  StreamController _songsController;

  StreamSink<SongObj> get songsSink => _songsController.sink;

  Stream<SongObj> get songsStream => _songsController.stream;

  PlayerService() {
    _songsController = StreamController<SongObj>.broadcast();
  }

  final _yt = YoutubeExplode();
  final _audioPlugin = AudioPlayer();
  var _selectedSong = SongObj(url: "");

  Stream<AudioPlayerState> get onPlayerStateChanged =>
      _audioPlugin.onPlayerStateChanged;

  Stream<Duration> get onAudioPositionChanged =>
      _audioPlugin.onAudioPositionChanged;

  AudioPlayerState get playerState => _audioPlugin.state;

  SongObj get currentSong => _selectedSong;

  set currentSong(SongObj song) {
    _selectedSong = song;
    songsSink.add(song);
  }

  Future<Video> getVideoInfo(url) async {
    return await _yt.videos.get(url);
  }

  Duration getSongDuration() {
    return _audioPlugin.duration;
  }

  Stream<Video> getVideoBySearchTerm(String searchQuery) {
    return _yt.search.getVideos(searchQuery);
  }

  Future<StreamManifest> getVideoManifest(url) async {
    return await _yt.videos.streamsClient.getManifest(url);
  }

  stopMusic() async {
    await _audioPlugin.stop();
  }

  resumeMusic() async {
    await _audioPlugin.resume();
  }

  pauseMusic() async {
    await _audioPlugin.pause();
  }

  playMusicFromUrl(audioURL) async {
    _audioPlugin.stop();
    await _audioPlugin.play(audioURL);
//    _audioPlugin.notification(
//        currentSong.name, currentSong.thumb_url, currentSong.author);
  }

  dispose() {
    _songsController.close();
  }
}
