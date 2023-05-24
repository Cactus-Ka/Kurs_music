import 'package:flutter/material.dart';
import 'notifiers/Func.dart';


class AllMusic extends StatefulWidget {
  const AllMusic({Key? key}) : super(key: key);

  @override
  _AllMusicState createState() => _AllMusicState();
}

class _AllMusicState extends State<AllMusic> {

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    super.setState(() {});

    Func();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: Func.playlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(Func.playlist[index].split('/').last,),
                  onTap: () async {
                    Func.index = index;
                    Func.currentTrackIndex = index + 1;
                    Func.isPlaying = false;
                    Func.play();
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}