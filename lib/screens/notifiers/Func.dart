import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
//------------------------------------------------------------------------------
class Func{
  static late Directory externalStorage;
  static List<String> mp3Files = [];
  static List<String> playlist = [];
  static String? treck ;

  static AudioPlayer audioPlayer = AudioPlayer();
  static bool isPlaying = false;

  static int currentTrackIndex = 1;
  static int index = 0;

  static Duration duration = const Duration();
  static Duration position = const Duration();
//------------------------------------------------------------------------------
Func(){
  init();
}
  void init() async {
    externalStorage = (await getExternalStorageDirectory())!;
    getFilesList(externalStorage).then((list) {
      playlist = list;
    });
    pos();
  }
//------------------------------------------------------------------------------
  static  Future<void> pos() async {
    audioPlayer.onDurationChanged.listen((Duration d) {
      {
        duration = d;
      }
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      {
        position = p;
      }
    });
  }

  static Future<List<String>> getFilesList(Directory directory) async {
    try {
      Directory? directory = await getExternalStorageDirectory();
      String path = "${directory?.path}/Music/";
      Directory dir = Directory(path);
      List contents = dir.listSync();
      for (var file in contents) {
        if (file.path.endsWith(".mp3")) {
          mp3Files.add(file.path);
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return mp3Files;
  }
//------------------------------------------------------------------------------
  static void play () async{
    if (isPlaying == false) {
      audioPlayer.play(UrlSource(playlist[index]));
      isPlaying = true;
      treck = playlist[index].split('/').last;
    } else {
      audioPlayer.pause();
    }
  }

  static Future<void> pause() async {
    audioPlayer.pause();
    isPlaying = false;
    treck = playlist[index].split('/').last;
  }

  static void playNextTrack() async{
    currentTrackIndex++;
    if (currentTrackIndex < playlist.length - 1) {
      index++;
      treck = playlist[index].split('/').last;
    } else {
      currentTrackIndex = 1;
      index = 0;
      treck = playlist[index].split('/').last;
    }
    if (isPlaying == true) {
      audioPlayer.play(UrlSource(playlist[index]));
      treck = playlist[index].split('/').last;
    } else {
      audioPlayer.pause();
      treck = playlist[index].split('/').last;
    }
  }

  static void playPreviousTrack()async {
    currentTrackIndex--;
    if (currentTrackIndex >= 1) {
      index--;
    } else {
      currentTrackIndex = playlist.length;
      index = playlist.length - 1;
    }
    if (isPlaying == true) {
      audioPlayer.play(UrlSource(playlist[index]));
      treck = playlist[index].split('/').last;
    } else {
      audioPlayer.pause();
      treck = playlist[index].split('/').last;
    }
  }

  void setState(Null Function() param0) {
      isPlaying;
      treck;
      position;
      duration;
  }
}
//------------------------------------------------------------------------------