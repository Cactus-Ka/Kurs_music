import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class Mp3Finder extends StatefulWidget {
  @override
  _Mp3FinderState createState() => _Mp3FinderState();
}

class _Mp3FinderState extends State<Mp3Finder> {
  final List<FileSystemEntity> _folders = [];
  final List<FileSystemEntity> _mp3Files = [];

  Future<void> _getMp3FilesInFolder(String path) async {
    final directory = Directory('$path/');
    final files = directory.listSync();

    for (FileSystemEntity file in files) {
      if (file is Directory) {
        _folders.add(file);
      } else if (file.path.endsWith('.mp3')) {
        _mp3Files.add(file);
      }
    }
  }

  void _openFolder(String path) async {
    _folders.clear();
    _mp3Files.clear();
    await _getMp3FilesInFolder(path);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Mp3FolderView(folders: _folders, mp3Files: _mp3Files),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Directory?>(
        future: getExternalStorageDirectory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final String path = snapshot.data!.path;
          _openFolder(path);

          return Center(child: Text('Mp3 files are loading...'));
        },
      ),
    );
  }
}

class Mp3FolderView extends StatelessWidget {
  final List<FileSystemEntity> folders;
  final List<FileSystemEntity> mp3Files;

  Mp3FolderView({required this.folders, required this.mp3Files});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: folders.length + mp3Files.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < folders.length) {
            return ListTile(
              leading: Icon(Icons.folder),
              title: Text(folders[index].path.split('/').last),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Mp3FolderView(folders: [], mp3Files: []))),
            );
          }

          final int mp3Index = index - folders.length;
          final FileSystemEntity file = mp3Files[mp3Index];

          return ListTile(
            leading: Icon(Icons.music_note),
            title: Text(file.path.split('/').last),
            onTap: () async {
              final AudioPlayer player = AudioPlayer();
              await player.play(UrlSource(file.path));
            },
          );
        },
      ),
    );
  }
}