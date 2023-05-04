import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

abstract class VideoPlayerViewModelInputs {
  void initializePlayer(String url);

  void play();

  void pause();

  void seekTo(Duration duration);

  void dispose();
}

abstract class VideoPlayerViewModelOutputs {
  Stream<Duration> get positionStream;

  Stream<Duration> get durationStream;

  Stream<bool> get isPlayingStream;
}

class VideoPlayerViewModel
    implements VideoPlayerViewModelInputs, VideoPlayerViewModelOutputs {
  final _positionSubject = BehaviorSubject<Duration>();
  final _durationSubject = BehaviorSubject<Duration>();
  final _isPlayingSubject = BehaviorSubject<bool>.seeded(false);

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initializePlayer(String url) {
    videoPlayerController = VideoPlayerController.network(
      url,
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: true,
        mixWithOthers: true,
      ),
    );
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
      allowMuting: true,
      placeholder: Container(),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white,
      ),
      autoInitialize: true,
    );

    videoPlayerController.addListener(() {
      _positionSubject.add(videoPlayerController.value.position);
      _durationSubject.add(videoPlayerController.value.duration);
    });
  }

  @override
  void play() {
    chewieController.play();
    _isPlayingSubject.add(true);
  }

  @override
  void pause() {
    chewieController.pause();
    _isPlayingSubject.add(false);
  }

  @override
  void seekTo(Duration duration) {
    videoPlayerController.seekTo(duration);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    _positionSubject.close();
    _durationSubject.close();
    _isPlayingSubject.close();
  }

  @override
  Stream<Duration> get positionStream => _positionSubject.stream;

  @override
  Stream<Duration> get durationStream => _durationSubject.stream;

  @override
  Stream<bool> get isPlayingStream => _isPlayingSubject.stream;
}
