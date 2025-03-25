import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  late AudioPlayer _audioPlayer;

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> initAndPlay() async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/11.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(0.5);
      await _audioPlayer.resume();
      print("Background music started");
    } catch (e) {
      print("Error initializing background music: $e");
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    print("Background music paused");
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    print("Background music resumed");
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    print("Background music stopped");
  }

  void dispose() {
    _audioPlayer.dispose();
    print("AudioPlayer disposed");
  }
}
