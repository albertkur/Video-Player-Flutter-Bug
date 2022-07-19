import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _BumbleBeeFileVideo(),
      ),
    );
  }
}

class _BumbleBeeFileVideo extends StatefulWidget {
  @override
  _BumbleBeeFileVideoState createState() => _BumbleBeeFileVideoState();
}

class _BumbleBeeFileVideoState extends State<_BumbleBeeFileVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final File file =
        await _downloadFile('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 'bee.mp4');
    _controller = VideoPlayerController.file(
      file,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller!.addListener(() {
      setState(() {});
    });
    _controller!.setLooping(true);

    print('init start');
    await _controller!.initialize();
    print('init end');
    await _controller!.play();
  }

  Future<File> _downloadFile(String url, String name) async {
    // final String documentDirPath = (await path_provider.getApplicationSupportDirectory()).path;
    final String documentDirPath = (await path_provider.getApplicationDocumentsDirectory()).path;

    final String path = '$documentDirPath/$name';

    await Dio().download(url, path);

    return File(path);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: _controller != null
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller!),
                    VideoProgressIndicator(_controller!, allowScrubbing: true),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
