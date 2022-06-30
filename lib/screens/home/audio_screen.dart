import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:brew_crew/screens/home/common.dart';
import 'package:rxdart/rxdart.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);
  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> with WidgetsBindingObserver {
  AudioPlayer player = AudioPlayer();

  final Map<String, String> content = {
    'image_url':
        'https://missiontothemoon.co/wp-content/uploads/2022/06/1200-%E0%B8%AD%E0%B8%AD%E0%B8%81%E0%B8%AA%E0%B8%B4%E0%B8%99%E0%B8%84%E0%B9%89%E0%B8%B2%E0%B9%83%E0%B8%AB%E0%B8%A1%E0%B9%88%E0%B8%97%E0%B8%B5%E0%B9%84%E0%B8%A3%E0%B8%AB%E0%B8%99%E0%B9%89%E0%B8%B2%E0%B8%95%E0%B8%B2%E0%B8%81%E0%B9%87%E0%B9%80%E0%B8%AB%E0%B8%A1%E0%B8%B7%E0%B8%AD%E0%B8%99%E0%B9%80%E0%B8%94%E0%B8%B4%E0%B8%A1-%E0%B9%80%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B9%83%E0%B8%88%E0%B8%81%E0%B8%A5%E0%B8%A2%E0%B8%B8%E0%B8%97%E0%B8%98%E0%B9%8C-MAYA-%E0%B8%82%E0%B8%AD%E0%B8%87-Apple-1920x1008.jpg',
    'title':
        'ออกสินค้าใหม่ทีไรหน้าตาก็เหมือนเดิม! เข้าใจกลยุทธ์ “MAYA” ของ Apple ที่ทำให้ขายดีแม้ไม่แปลกใหม่',
    'speaker': 'เอวา',
    'audio_url':
        'https://botnoi-voice.s3.amazonaws.com:443/audio/764650f8ddbc55be0cb16767b90f274b6195ade830d73205fa156e75115a4659_1_20220630110430293540.m4a'
  };

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await player.setAudioSource(
          AudioSource.uri(Uri.parse(content['audio_url'].toString())));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  content['image_url'].toString(),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    content['title'].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      content['speaker'].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF616161),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Slider(
              //   min: 0,
              //   max: duration.inSeconds.toDouble(),
              //   value: position.inSeconds.toDouble(),
              //   onChanged: (value) async {
              //     final position = Duration(seconds: value.toInt());
              //     await player.seek(position);
              //   },
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(formatTime(position)),
              //       Text(formatTime(duration - position)),
              //     ],
              //   ),
              // ),
              ControlButtons(player),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: player.seek,
                  );
                },
              ),
            ],
          ),
        ),
      );
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () => {},
        ),
        IconButton(
          icon: const Icon(
            Icons.replay_10,
            size: 30,
          ),
          onPressed: () => {
            player.seek(Duration(seconds: player.position.inSeconds - 10)),
            if (player.position.inSeconds <= 0)
              {player.seek(const Duration(seconds: 0))},
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        IconButton(
            icon: const Icon(
              Icons.forward_10,
              size: 30,
            ),
            onPressed: () => {
                  player
                      .seek(Duration(seconds: player.position.inSeconds + 10)),
                  if (player.position.inSeconds >= player.duration!.inSeconds)
                    {
                      player.seek(Duration(seconds: player.duration!.inSeconds))
                    },

                  // player.seek(Duration(seconds: player.position.inSeconds + 10)),
                }),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.2,
                max: 2.0,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
