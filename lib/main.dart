import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wakelock/wakelock.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Horse.UP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  AudioPlayer advancedPlayer = AudioPlayer();
  String localFilePath;

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();

  _play_sound1() {}


  @override
  void initState() {
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onTap: _play_sound1(),
                child: Text(
                  'Sound 1',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline,
                ),
              ),
            ),
            Column(children: [
              Text('Volume'),
              Row(children: [
                _Btn(
                    txt: '0.0',
                    onPressed: () => widget.advancedPlayer.setVolume(0.0)),
                _Btn(
                    txt: '0.5',
                    onPressed: () => widget.advancedPlayer.setVolume(0.5)),
                _Btn(
                    txt: '1.0',
                    onPressed: () => widget.advancedPlayer.setVolume(1.0)),
                _Btn(
                    txt: '2.0',
                    onPressed: () => widget.advancedPlayer.setVolume(2.0)),
              ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
            ]),
            Text('Play Local Asset \'audio.mp3\':'),
            _Btn(txt: 'Play', onPressed: () => audioCache.play('audio.mp3')),
            Text('Loop Local Asset \'audio.mp3\':'),
            _Btn(txt: 'Loop', onPressed: () => audioCache.loop('audio.mp3')),
            Text('Play Local Asset \'audio2.mp3\':'),
            _Btn(txt: 'Play', onPressed: () => audioCache.play('audio2.mp3')),
            Text('Play Local Asset In Low Latency \'audio.mp3\':'),
            _Btn(
                txt: 'Play',
                onPressed: () =>
                    audioCache.play('audio.mp3',
                        mode: PlayerMode.LOW_LATENCY)),
            Text(
                'Play Local Asset Concurrently In Low Latency \'audio.mp3\':'),
            _Btn(
                txt: 'Play',
                onPressed: () async {
                  await audioCache.play('audio.mp3',
                      mode: PlayerMode.LOW_LATENCY);
                  await audioCache.play('audio2.mp3',
                      mode: PlayerMode.LOW_LATENCY);
                }),
            Text('Play Local Asset In Low Latency \'audio2.mp3\':'),
            _Btn(
                txt: 'Play',
                onPressed: () =>
                    audioCache.play('audio2.mp3',
                        mode: PlayerMode.LOW_LATENCY)),
            getLocalFileDuration(),
          ],
        ),
      ),
    );
  }


  Future<int> _getDuration() async {
    File audiofile = await audioCache.load('audio2.mp3');
    await advancedPlayer.setUrl(
      audiofile.path,
    );
    int duration = await Future.delayed(
        Duration(seconds: 2), () => advancedPlayer.getDuration());
    return duration;
  }

  getLocalFileDuration() {
    return FutureBuilder<int>(
      future: _getDuration(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Text(
                'audio2.mp3 duration is: ${Duration(
                    milliseconds: snapshot.data)}');
        }
        return null; // unreachable
      },
    );
  }
}

class _Btn extends StatelessWidget {
  final String txt;
  final VoidCallback onPressed;

  const _Btn({Key key, this.txt, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }
}
