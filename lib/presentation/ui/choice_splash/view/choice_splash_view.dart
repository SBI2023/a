import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/presentation/ui/login/view/login_view.dart';

import '../../../../data/storage/local_data.dart';
import '../../../../domain/models/choice_screen_model.dart';
import '../../../resources/color_manager.dart';
import '../../home/view/home_view.dart';
import '../viewmodel/choice_splash_viewmodel.dart';

class ChoiceScreenView extends StatefulWidget {
  const ChoiceScreenView({super.key});

  @override
  _ChoiceScreenViewState createState() => _ChoiceScreenViewState();
}

class _ChoiceScreenViewState extends State<ChoiceScreenView> {
  late ChoiceScreenViewModel _viewModel;
  String bgImage = "";
  int _selectedItemIndex = -1;
  bool isLoggedIn = false;
  final _scrollController = ScrollController();
  final FocusNode _rawMainFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    if (LocalData().checkKey("is_logged_in")) {
      isLoggedIn = LocalData().getData("is_logged_in");
    }
    _viewModel = ChoiceScreenViewModel();
    _viewModel.start();
    _viewModel.ChoiceScreenDataStream.listen((choiceScreen) {
      setState(() {
        bgImage = choiceScreen.backgroundImage;
      });
    });

    // _listBoxs = _viewModel.listOfBoxs;

    _viewModel.selectedBoxIndex.listen((index) {
      // bgImage = _viewModel.listSliders[index].backgroundImage;
      // _selectedItemIndex = index;
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedItemIndex = index;
      });
    });
  }

  void _scrollToSelected() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _selectedItemIndex * (MediaQuery.of(context).size.width * .3),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChoiceScreenModel>(
        stream: _viewModel.ChoiceScreenDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Use the home data from the snapshot to build the UI
            final screenData = snapshot.data!;

            return Stack(
              children: [
                // Background image
                Image.asset(
                  bgImage,
                  fit: BoxFit.fill,
                  height: double.infinity,
                  width: double.infinity,
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(50),
                  scrollDirection: Axis.horizontal,
                  itemCount: screenData.boxs.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return RawKeyboardListener(
                      focusNode: _rawMainFocus,
                      onKey: (RawKeyEvent event) {
                        if (event is RawKeyDownEvent) {
                          if (event.logicalKey ==
                              LogicalKeyboardKey.arrowRight) {
                            setState(() {
                              _selectedItemIndex = (_selectedItemIndex ==
                                      screenData.boxs.length - 1)
                                  ? _selectedItemIndex
                                  : _selectedItemIndex + 1;
                            });
                            _scrollToSelected();
                          } else if (event.logicalKey ==
                              LogicalKeyboardKey.arrowLeft) {
                            setState(() {
                              _selectedItemIndex = (_selectedItemIndex == 0)
                                  ? 0
                                  : _selectedItemIndex - 1;
                            });
                            _scrollToSelected();
                          } else if (event.logicalKey ==
                              LogicalKeyboardKey.select) {
                            if (_selectedItemIndex == 0) {
                              // Get.to(() => SplashView(
                              //       isLoggedIn: isLoggedIn,
                              //     ));
                              isLoggedIn
                                  ? Get.off(() => const HomeView())
                                  : Get.to(() => const LoginView());
                            } else if (_selectedItemIndex == 2) {
                              Get.to(() => const LoginView());
                            } else {
                              // screenData.indexClicked = 0;
                              _viewModel.onItemClicked(_selectedItemIndex);
                            }
                          }
                        }
                      },
                      child: GestureDetector(
                        onTap: () => setState(
                          () {
                            if (_selectedItemIndex == index && index == 0) {
                              /*Get.to(() => SplashView(
                                    isLoggedIn: isLoggedIn,
                                  ));*/
                              //   *
                              // /
                              // *
                              // *****
                              // *
                              // *
                              // **
                              // *****
                              // **
                              // *
                              // *
                              // *
                              // *
                              //
                              isLoggedIn
                                  ? Get.off(() => const HomeView())
                                  : Get.to(() => const LoginView());
                            } else {
                              // screenData.indexClicked = 0;
                              _viewModel.onItemClicked(index);
                            }
                          },
                        ),
                        child: screenData.boxs[index].boxImage.isEmpty
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                width: MediaQuery.of(context).size.width * .3,
                                height: MediaQuery.of(context).size.height * .8,
                                decoration: BoxDecoration(
                                  color: ColorManager.lightPrimary,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        "P${index + 1}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(50),
                                          ),
                                          color: _selectedItemIndex == index
                                              ? ColorManager.yellow
                                              : ColorManager.white,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .18,
                                        child: Icon(Icons.arrow_forward_sharp,
                                            color:
                                                ColorManager.mediumDarkPrimary),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * .3,
                                height: MediaQuery.of(context).size.height * .8,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: index == index
                                      ? ColorManager.lightPrimary
                                      : Colors.transparent,
                                  image: DecorationImage(
                                    fit: index == 0 ? BoxFit.none : BoxFit.fill,
                                    image: AssetImage(
                                      screenData.boxs[index].boxImage,
                                    ),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(50)),
                                      color: _selectedItemIndex == index
                                          ? ColorManager.yellow
                                          : ColorManager.white,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width * .1,
                                    height: MediaQuery.of(context).size.height *
                                        .18,
                                    child: Icon(Icons.arrow_forward_sharp,
                                        color: ColorManager.mediumDarkPrimary),
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Error loading home data');
          } else {
            // return const Center(child: CircularProgressIndicator());
            return Container();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _scrollController.dispose();
    _rawMainFocus.dispose();
    super.dispose();
  }
}
