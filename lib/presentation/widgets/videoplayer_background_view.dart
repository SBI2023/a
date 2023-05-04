import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../domain/models/video_model.dart';
import '../resources/color_manager.dart';
import 'infobar_channel.dart';
import '../ui/video_player/viewmodel/videoplayer_viewmodel.dart';

class VideoPlayerBackgroundView extends StatefulWidget {
  VideoPlayerViewModel viewModel;

  // bool changeIt;
  // bool isLive;

  VideoPlayerBackgroundView({required this.viewModel, super.key});

  @override
  _VideoPlayerBackgroundViewState createState() =>
      _VideoPlayerBackgroundViewState();
}

class _VideoPlayerBackgroundViewState extends State<VideoPlayerBackgroundView> {

  @override
  void initState() {
    super.initState();
    // print("sliderVideoUrl = ${widget.sliderVideoUrl}");

    /*_viewModel = VideoPlayerViewModel(
      VideoModel(
        videoUrl: widget.sliderVideoUrl,
        //skipDuration: const Duration(seconds: 40),
      ),
    );
    */
    // widget.viewModel.initializePlayer();

    // setState(() {
    //   widget.viewModel.initializePlayer();
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorManager.black,
      body: SafeArea(
        child: /*StreamBuilder<VideoPlayerController>(
          stream: widget.viewModel.videoPlayerController,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: ColorManager.white),
              );
            }
            return Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: VideoPlayer(
                        widget.viewModel.videoPlayerController,
                      ),
                    ),
                  ),
                ),
                InfoBarChannel(),
              ],
            );
          },
        ),*/Container(),
      ),
    );
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }
}
