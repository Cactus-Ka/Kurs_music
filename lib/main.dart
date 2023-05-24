
import 'package:flutter/material.dart';
import 'package:music5/screens/allMusic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'dart:async';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'screens/media.dart';
import 'screens/notifiers/Func.dart';

AllMusic? _allMusic;
AllMusic? get pageManager => const AllMusic();

void main() {
  runApp(const MyApp());
}

Future<void> factory () async {
  var statuses = await [Permission.storage,
      Permission.manageExternalStorage]
      .request();
  if (statuses.isNotEmpty) {
  return;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(), // standard dark theme
      themeMode: ThemeMode.system, // device controls
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Music', length: 2,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required int length});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
var iconC = const Color.fromRGBO(202 , 25, 208, 298);
var themaC = const Color.fromRGBO(73 , 73, 73, 1);

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    _allMusic = const AllMusic();
    factory();
    Func();
    super.setState(() {
      Func.isPlaying;
      Func.treck;
      Func.duration;
      Func.position;
    });
  }
//------------------------------------------------------------------------------
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Func();
    super.setState(() {
      Func.isPlaying;
      {
        setState(() {
          Func.isPlaying;
          Func.treck;
          Func.duration;
          Func.position;
        });
      }
    });
    Func.audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        Func.position = duration;
      });
    },
    );
  }
//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
          actions: [
      IconButton(
      icon: Icon(Icons.settings_outlined,
          color: iconC),
      tooltip: 'Open shopping cart',
      onPressed: () {
        // handle the press
      },
      ),
  ]
    ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        color: themaC,
        maxHeight: 740,
        minHeight: 70,
        panel: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(Func.treck ?? '',),
                ProgressBar(
                  progress: Func.position,
                  total: Func.duration,
                  progressBarColor: iconC,
                  thumbColor: iconC,
                  baseBarColor: Colors.grey,
                  onSeek: (duration) {
                    Func.audioPlayer.seek(duration);
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                      Icons.skip_previous,
                    color: iconC),
                  onPressed:  Func.playPreviousTrack,
                ),
                IconButton(
                  icon: Func.isPlaying ? Icon(
                      Icons.pause,
                      color: iconC) : Icon(
                    Icons.play_arrow,
                    color: iconC),
                  onPressed:
                    Func.isPlaying ? Func.pause : Func.play,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next,
                    color: iconC),
                  onPressed: Func.playNextTrack,
                ),
              ],
            ),
          ],
        ),
        collapsed: Container(
          decoration: BoxDecoration(
              color: themaC,
              borderRadius: radius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Func.treck ?? '',),
              IconButton(
                icon: Func.isPlaying ? Icon(
                    Icons.pause,
                  color: iconC) : Icon(
                    Icons.play_arrow,
                  color: iconC),
                onPressed:
                  Func.isPlaying ? Func.pause : Func.play,
              ),
            ],
          ),
        ),
        borderRadius: radius,
        body: PageView(
            children:  [
              const AllMusic(),
              Mp3Finder(),
            ]
        ),
      ),
    );
  }
}
//------------------------------------------------------------------------------
