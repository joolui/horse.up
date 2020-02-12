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
      title: 'Horse.UP',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Horse.UP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioCache audioCache = AudioCache();
  AudioPlayer futasPlayer = AudioPlayer();
  AudioPlayer hangokPlayer = AudioPlayer();

  File audioFile;

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
        child: Column(children: [
          getHangeroszabalyozo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getHangok(),
              getMozgas(),
            ],
          )
        ]),
      ),
    );
  }

  Widget getHangeroszabalyozo() {
    return Column(children: [
      Text(
        'Volume',
        style: Theme
            .of(context)
            .textTheme
            .headline,
      ),
      Row(children: [
        _Btn(txt: '0.5', onPressed: () => futasPlayer.setVolume(0.5)),
        _Btn(txt: '1.0', onPressed: () => futasPlayer.setVolume(1.0)),
      ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
    ]);
  }

  Widget getHangok() {
    return Column(
      children: <Widget>[
        Text(
          'Hangok',
          style: Theme
              .of(context)
              .textTheme
              .headline,
        ),
        SizedBox(height: 10),
        _ImageBtn(
            txt: 'assets/horse_brr.jpg',
            onPressed: () async {
              audioFile = await audioCache.load('Brrr2.ogg');
              return hangokPlayer.play(audioFile.path);
            }),
        SizedBox(height: 30),
        _ImageBtn(
            txt: 'assets/horse_laughinh.jpg',
            onPressed: () async {
              audioFile = await audioCache.load('Nyihaha3.mp3');
              return hangokPlayer.play(audioFile.path);
            }),
        SizedBox(height: 10),
        _Btn(
            txt: 'Stop',
            onPressed: () async {
              return hangokPlayer.release();
            }),
      ],
    );
  }

  Widget getMozgas() {
    return Column(
      children: <Widget>[
        Text(
          'Mozgás',
          style: Theme
              .of(context)
              .textTheme
              .headline,
        ),
        SizedBox(height: 10),
        _ImageBtn(
            txt: 'assets/running_horse.jpg',
            onPressed: () async {
              audioFile = await audioCache.load('Futas4.mp3');
              futasPlayer.setReleaseMode(ReleaseMode.LOOP);
              return futasPlayer.play(audioFile.path);
            }),
        SizedBox(height: 30),
        _ImageBtn(
            txt: 'assets/horse_walking.jpg',
            onPressed: () async {
              audioFile = await audioCache.load('Gyalog1.ogg');
              futasPlayer.setReleaseMode(ReleaseMode.LOOP);
              return futasPlayer.play(audioFile.path);
            }),
        SizedBox(height: 10),
        _Btn(
            txt: 'Stop',
            onPressed: () async {
              return futasPlayer.release();
            }),
      ],
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
      child: RaisedButton(
        child: Text(
          txt,
          style: Theme
              .of(context)
              .textTheme
              .headline,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _ImageBtn extends StatelessWidget {
  final String txt;
  final VoidCallback onPressed;

  const _ImageBtn({Key key, this.txt, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Image.asset(
        txt,
        width: 150,
        height: 150,
      ),
      onPressed: onPressed,
    );
  }
}
