import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../domain/models/video_model.dart';
import '../../../base/base_viewmodel.dart';
import '../../home/view/home_view.dart';
import '../../login/view/login_view.dart';

class SplashViewModel extends BaseViewModel
    with SplashViewModelInputs, SplashViewModelOutputs {
  // final _controller = StreamController<ChewieController>();
  final _controller = StreamController<VideoPlayerController>();
  late final VideoPlayerController videoPlayerController;
  late final ChewieController _chewieController;

  late final VideoModel _model;
  late bool _isLoggedIn;

  // late final Duration _remainingDuration;

  @override
  // Stream<ChewieController> get outputVideoStream => _controller.stream;
  Stream<VideoPlayerController> get outputVideoStream => _controller.stream;

  @override
  void onSkip() {
    _chewieController.pause();
    _chewieController
        .seekTo(_chewieController.videoPlayerController.value.duration);
    _isLoggedIn
        ? Get.off(const HomeView())
        : Get.to(const LoginView());
  }

  @override
  void onVideoTap() {
    if (_chewieController.isPlaying) {
      _chewieController.pause();
    } else {
      _chewieController.play();
    }
  }

  SplashViewModel(VideoModel model, bool isLoggedIn) {
    _model = model;
    _isLoggedIn = isLoggedIn;
  }

  @override
  void initializePlayer() {
    videoPlayerController = VideoPlayerController.asset(
      _model.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: true,
        mixWithOthers: true,
      ),
    );
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      allowFullScreen: false,
      looping: false,

      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      allowMuting: false,
      showControlsOnInitialize: false,
      fullScreenByDefault: true,
      aspectRatio: videoPlayerController.value.aspectRatio,
      placeholder: Container(color: Colors.black),
    );
    _controller.sink.add(videoPlayerController);
  }

  @override
  void start() {
    _model.skipDuration = const Duration(seconds: 7);
    initializePlayer();
    _updateRemainingDuration();
  }

  @override
  // Sink<ChewieController> get inputVideoStream => _controller.sink;
  Sink<VideoPlayerController> get inputVideoStream => _controller.sink;

  @override
  void dispose() {
    _controller.close();
    _chewieController.dispose();
    videoPlayerController.dispose();
  }

  void _updateRemainingDuration() {
    final remaining =
        _model.skipDuration! - videoPlayerController.value.position;
    if (remaining <= Duration.zero) {
      onSkip();
    } else {
      // _remainingDuration = remaining;
      Future.delayed(const Duration(milliseconds: 500), _updateRemainingDuration);
    }
  }
}

// inputs mean "orders" that our view model will receive from view
abstract class SplashViewModelInputs {
  void onSkip();

  void onVideoTap();

  void initializePlayer();

  // Sink<ChewieController> get inputVideoStream;
  Sink<VideoPlayerController> get inputVideoStream;

  void dispose();
}

abstract class SplashViewModelOutputs {
  Stream get outputVideoStream;
}
