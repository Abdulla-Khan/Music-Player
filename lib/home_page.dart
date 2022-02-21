// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool playing = false; // at the begining we are not playing any song
  IconData playBtn = Icons.play_arrow; // the main state of the play button icon

  //Now let's start by creating our music player
  //first let's declare some object
  late AudioPlayer _player;
  late AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  //we will create a custom slider

  Widget slider() {
    return Container(
      width: 280.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Now let's initialize our player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    //now let's handle the audioplayer time

    //this function will allow you to get the music duration
    _player.onDurationChanged.listen((Duration d) {
      setState(() {
        musicLength = d;
      });
    });

    //this function will allow us to move the cursor of the slider while we are playing the song
    _player.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.blue.shade800,
              Colors.blue.shade200,
            ])),
        child: Padding(
          padding: EdgeInsets.only(
            top: 48,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Music Beats',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: const Text(
                    'Listen to your favourite Music',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: AssetImage('assets/cover.jpg'))),
                  ),
                ),
                SizedBox(height: 18),
                Center(
                  child: Text(
                    'Good Kid',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${position.inMinutes}:${position.inSeconds.remainder(60)}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              slider(),
                              Text(
                                '${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.skip_previous),
                              iconSize: 45,
                              color: Colors.blue,
                            ),
                            IconButton(
                              onPressed: () {
                                if (!playing) {
                                  cache.play('song.mpeg');

                                  setState(() {
                                    // _audio.play('song.mpeg');
                                    playBtn = Icons.pause;
                                    playing = true;
                                  });
                                } else {
                                  _player.pause();
                                  setState(() {
                                    playBtn = Icons.play_arrow;
                                    playing = false;
                                  });
                                }
                              },
                              icon: Icon(playBtn),
                              iconSize: 62,
                              color: Colors.blue[800],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.skip_next),
                              iconSize: 45,
                              color: Colors.blue,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
