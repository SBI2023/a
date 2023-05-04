import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';

import '../../../resources/color_manager.dart';
import '../viewmodel/videoplayer_viewmodel.dart';

class VideoPlayerView extends StatefulWidget {
  final String url;

  const VideoPlayerView({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late final VideoPlayerViewModel _viewModel;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _viewModel = VideoPlayerViewModel();
    _viewModel.initializePlayer(widget.url);
    _viewModel.isPlayingStream.listen((isPlaying) {
      _isPlaying = isPlaying;
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<bool>(
          stream: _viewModel.isPlayingStream,
          builder: (context, snapshot) {
            return Stack(
              children: [
                _buildVideoPlayer(),
                if (snapshot.data ?? false) _buildPlayPauseOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return StreamBuilder<Duration>(
      stream: _viewModel.positionStream,
      builder: (context, snapshot) {
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Container(
              color: ColorManager.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Chewie(
                controller: _viewModel.chewieController,
              ),
            ),
          ),
        );

      },
    );
  }

  Widget _buildPlayPauseOverlay() {
    return GestureDetector(
      onTap: () {
        if (_isPlaying == true) {
          _viewModel.pause();
        } else {
          _viewModel.play();
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Icon(
            _isPlaying == true
                ? Icons.pause
                : Icons.play_arrow,
            size: 72.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
