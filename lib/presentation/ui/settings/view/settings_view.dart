import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv_sbi_v2/presentation/resources/assets_manager.dart';
import 'package:iptv_sbi_v2/presentation/resources/constants_manager.dart';
import '../../../../domain/models/settings_model.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../viewmodel/settings_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SettingsViewModel _viewModel;
  String bgImage = "";
  int _selectedItemIndex = 0;
  late bool _isChecked;
  bool _isAbout = false, _isUrlAboutFocus = false;
  List<String> _listMenuItems = [];
  List<String> _listMenuInformations = [];
  List<String> _listOfInformations = [];
  final FocusNode _rawMainFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _viewModel = SettingsViewModel();
    _viewModel.start();
    _viewModel.SettingsDataStream.listen((settingsScreen) {
      setState(() {
        bgImage = settingsScreen.backgroundImage!;
      });
    });

    _isChecked = false;

    _listMenuItems = _viewModel.listMenuItems;
    _listMenuInformations = _viewModel.listMenuInformations;
    _listOfInformations = _viewModel.listOfInformations;

    _viewModel.selectedItemIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedItemIndex = index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<SettingsModel>(
        stream: _viewModel.SettingsDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Use the home data from the snapshot to build the UI
            final screenData = snapshot.data!;

            return RawKeyboardListener(
              focusNode: _rawMainFocus,
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                    if (/*_selectedItemIndex == 1 && */ _isAbout) {
                      setState(() {
                        _selectedItemIndex = -1;
                        _isUrlAboutFocus = true;
                      });
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                    if (_isUrlAboutFocus) {
                      setState(() {
                        _selectedItemIndex = 1;
                        _isUrlAboutFocus = false;
                      });
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    setState(() {
                      _selectedItemIndex =
                          (_selectedItemIndex == _listMenuItems.length)
                              ? _selectedItemIndex
                              : _selectedItemIndex + 1;
                      _isUrlAboutFocus = false;
                    });
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    setState(() {
                      _selectedItemIndex = (_selectedItemIndex == 0)
                          ? 0
                          : _selectedItemIndex - 1;
                      _isUrlAboutFocus = false;
                    });
                  } else if (event.logicalKey == LogicalKeyboardKey.select) {
                    _viewModel.onItemClicked(_selectedItemIndex);

                    if (_selectedItemIndex == 1) {
                      setState(() {
                        _isAbout = true;
                      });
                    } else {
                      setState(() {
                        _isAbout = false;
                      });
                    }

                    if (_selectedItemIndex == 2) {
                      _viewModel.openSettings();
                    } else if (_selectedItemIndex == 3) {
                      setState(() {
                        _isChecked = !_isChecked;
                        // _isAbout = false;
                      });
                    } else if (_isUrlAboutFocus) {
                      _viewModel.launchUrlWebsite();
                    }
                    // _selectedItemIndex = index;
                    // print("selected index : $_selectedItemIndex");
                  }
                }
              },
              child: Stack(
                children: [
                  // Background image
                  Image.asset(
                    bgImage,
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  // Carousel slider
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      // alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: ColorManager.darkPrimary.withOpacity(0.65),
                      ),
                      width: MediaQuery.of(context).size.width * .42,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .2,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.vertical,
                        itemCount: _listMenuItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return index != 3
                              ? TextButton(
                                  onPressed: () {
                                    // screenData.indexClicked;
                                    _viewModel.onItemClicked(index);
                                    if (index == 2) {
                                      _viewModel.openSettings();
                                    }
                                    // _selectedItemIndex = index;
                                    // print("selected index : $_selectedItemIndex");
                                    setState(() {
                                      if (index == 1) {
                                        _isAbout = true;
                                      } else {
                                        _isAbout = false;
                                      }
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .05,
                                    ),
                                    elevation: 25,
                                    alignment: Alignment.centerLeft,
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width,
                                        MediaQuery.of(context).size.height *
                                            .2),
                                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                                    backgroundColor: _selectedItemIndex == index
                                        ? ColorManager.selectedNavBarItem
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    _listMenuItems[index],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.start,
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    // screenData.indexClicked;
                                    _viewModel.onItemClicked(index);

                                    setState(() {
                                      _isChecked = !_isChecked;
                                      // _isAbout = false;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    elevation: 25,
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .06,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width,
                                        MediaQuery.of(context).size.height *
                                            .2),
                                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        _listMenuItems[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .08,
                                      ),
                                      Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          value: _isChecked,
                                          // visualDensity: VisualDensity(horizontal: 4, vertical: 4),
                                          onChanged: (bool? value) {
                                            _viewModel.onItemClicked(index);
                                            setState(() {
                                              _isChecked = value!;
                                            });
                                          },
                                          activeColor:
                                              ColorManager.selectedNavBarItem,
                                          checkColor: ColorManager.white,
                                          side: BorderSide(
                                            color: _isChecked
                                                ? ColorManager
                                                    .selectedNavBarItem
                                                : ColorManager.white,
                                            width: 2,
                                          ),
                                          fillColor: MaterialStatePropertyAll(
                                            _isChecked
                                                ? ColorManager
                                                    .selectedNavBarItem
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                  _isAbout
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            color: ColorManager.black.withOpacity(0.6),
                            width: MediaQuery.of(context).size.width * .58,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(ImageAssets.alphaLogoSetting),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: _isUrlAboutFocus
                                          ? [
                                              BoxShadow(
                                                color: ColorManager
                                                    .selectedNavBarItem
                                                    .withOpacity(0.3),
                                                spreadRadius: 3,
                                                blurRadius: 20,
                                                offset: const Offset(0, 0),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        _viewModel.launchUrlWebsite();
                                      },
                                      // onPressed: (){},
                                      child: Text(
                                        AppConstants.alphaIptvUrl,
                                        style: getSemiBoldStyle(
                                          color: ColorManager.white,
                                          fontSize: FontSize.s20,
                                          isUnderline: true,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            // alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: ColorManager.darkPrimary.withOpacity(0.45),
                            ),
                            width: MediaQuery.of(context).size.width * .58,
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .1,
                                left: MediaQuery.of(context).size.width * .12,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              // scrollDirection: Axis.vertical,
                              itemCount: _listMenuItems.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _listMenuInformations[index],
                                      style: getSemiBoldStyle(
                                          color: ColorManager.white,
                                          fontSize: FontSize.s22),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      _listOfInformations[index],
                                      style: getMediumStyle(
                                          color: ColorManager.white,
                                          fontSize: FontSize.s16),
                                      textAlign: TextAlign.start,
                                    ),
                                    index < _listMenuInformations.length - 0
                                        ? Container(
                                            color: ColorManager.white,
                                            margin: EdgeInsets.symmetric(
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .035),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .09,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .01,
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                ],
              ),
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
    _rawMainFocus.dispose();
    super.dispose();
  }
}
