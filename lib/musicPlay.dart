import 'package:audioplayers/audioplayers.dart';

class Audio {
  final player = AudioPlayer();

  Future<void> playAudio() async {
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(
      AssetSource('music/music.mp3'),
      volume: 0.1,
    );
  }

  Future<void> stopAudio() async {
    await player.stop();
  }
}