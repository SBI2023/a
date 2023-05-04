import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/presentation/resources/font_manager.dart';
import 'package:iptv_sbi_v2/presentation/resources/styles_manager.dart';
import 'package:video_player/video_player.dart';
import '../../../../domain/models/video_model.dart';
import '../../../resources/color_manager.dart';
import '../../home/view/home_view.dart';
import '../../login/view/login_view.dart';
import '../viewmodel/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  bool isLoggedIn;

  SplashView({super.key, required this.isLoggedIn});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel _viewModel;
  final FocusNode _skipFocusNode = FocusNode();
  final FocusNode _rawSplashFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _viewModel = SplashViewModel(
      VideoModel(
        videoUrl: "assets/videos/test_video.mp4",
        skipDuration: const Duration(seconds: 8),
      ),
      widget.isLoggedIn,
    );

    setState(() {
      _viewModel.start();
    });
  }

  @override
  void deactivate() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: SafeArea(
        child: StreamBuilder<VideoPlayerController>(
          stream: _viewModel.outputVideoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: ColorManager.white),
              );
            }
            return RawKeyboardListener(
              focusNode: _rawSplashFocusNode,
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
                      event.logicalKey == LogicalKeyboardKey.arrowLeft ||
                      event.logicalKey == LogicalKeyboardKey.arrowUp ||
                      event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    setState(() {
                      _skipFocusNode.requestFocus();
                    });
                  } else if (event.logicalKey == LogicalKeyboardKey.select) {
                    if (_skipFocusNode.hasFocus) {
                      // widget.isLoggedIn
                      //     ? Get.off(const HomeView())
                      //     : Get.to(const LoginView());
                      _viewModel.onSkip();
                    }
                  }
                } else {
                  _skipFocusNode.requestFocus();
                }
              },
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: VideoPlayer(
                          _viewModel.videoPlayerController,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      focusNode: _skipFocusNode,
                      onPressed: () {
                        // widget.isLoggedIn
                        //     ? Get.off(() => const HomeView())
                        //     : Get.to(() => const LoginView());
                        _viewModel.onSkip();
                      },
                      style: ButtonStyle(
                        side: const MaterialStatePropertyAll(
                            BorderSide(style: BorderStyle.none)),
                        minimumSize: MaterialStatePropertyAll(
                          Size(MediaQuery.of(context).size.width * .15,
                              MediaQuery.of(context).size.height * .17),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                          ColorManager.selectedNavBarItem,
                        ),
                      ),
                      child: Text(
                        "SKIP ",
                        // style: Theme.of(context).textTheme.headlineLarge,
                        style: getSemiBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s30,
                          isUnderline: _skipFocusNode.hasFocus,
                        ),
                        // style: TextStyle(color: Colors.white, fontSize: 50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
    _rawSplashFocusNode.dispose();
    _skipFocusNode.dispose();
  }
}
