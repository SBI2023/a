import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/storage/local_data.dart';
import '../../../../domain/models/list_channel_screen_model.dart';
import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/category_response.dart';
import '../../../../domain/response/channel_response.dart';
import '../../../../domain/services/livechannel_services.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../widgets/background_animated.dart';
import '../../../widgets/infobar_channel.dart';
import '../../../widgets/waiting_widget.dart';
import '../viewmodel/list_channel_viewmodel.dart';
import 'package:wakelock/wakelock.dart';
import 'package:iptv_sbi_v2/data/storage/local_data.dart';
import 'package:iptv_sbi_v2/domain/models/list_channel_screen_model.dart';

class ListChannelView extends StatefulWidget {
  // List<CategoryModel> listPackageCategory;
  // Future<dynamic>? repositoryFunction;
  String nameSlider;
  String id;
  RouteScreenModel routeScreenModel;

  ListChannelView({
    required this.nameSlider,
    required this.id,
    required this.routeScreenModel,
    // required this.listPackageCategory,
    // required this.repositoryFunction,
    super.key,
  });

  @override
  _ListChannelViewState createState() => _ListChannelViewState();
}

class _ListChannelViewState extends State<ListChannelView> {
  late ListChannelViewModel _viewModel;

  List<String> listOfBackgrounds = [];
  int _selectedItemIndex = -1;
  late List<dynamic> listOfChannels = [];
  late VideoPlayerController _controller;
  bool _showMenu = true;

  // late final StreamSubscription _subscriptionNavItem;
  Map<int, dynamic> _mapMenus = {};
  int _menuLevel = 0;
  List<String> listTitleLevel = [];

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _viewModel = ListChannelViewModel(widget.id);
    _viewModel.start();
    _viewModel.listChannelsDataStream.listen((menuChannelsScreen) {
      // final list = moviesScreen.;
      setState(() {
        listOfBackgrounds = menuChannelsScreen.backgroundImages!;
        // listOfUnderCategories = ;
      });
    });

    // _listItems = _viewModel.listNavBarItems;

    _viewModel.selectedChannelIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedItemIndex = index;
      });
    });
    _viewModel.listChannels.listen((list) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        listOfChannels = list;
        _mapMenus[0] = list;
      });
    });
    _viewModel.mapMenusData.listen((mapMenus) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _mapMenus = mapMenus;
      });
    });
    _controller = VideoPlayerController.network("");

    _mapMenus = {
      1: widget.routeScreenModel.listOfUnderCategories!,
      2: widget.routeScreenModel.navbarItems!,
    };

    listTitleLevel = [
      widget.nameSlider,
      widget.routeScreenModel.categoryChoosen ?? "",
      "Categories",
    ];
  }

  void _onItemSelected(int index) {
    if (index != _selectedItemIndex) {
      _selectedItemIndex = index;
      _controller.dispose();
      if (_mapMenus[0][_selectedItemIndex].url.isNotEmpty) {
        _controller =
            VideoPlayerController.network(_mapMenus[0][_selectedItemIndex].url)
              ..initialize().then((_) {
                _controller.setLooping(true);
                _controller.play();
                setState(() {});
              });
      }
    }
  }

  void getNewData(CategoryModel itemClicked) async {
    if (_menuLevel == 1) {
      ResponseChannel responseChannels =
          await liveChannelService.getLiveChannelsByCategory(itemClicked.id);

      _viewModel.onChangeList(responseChannels.listChannels);

      print("list Of Channels 2 ${_mapMenus[0][3].name}");

      //   if (responseChannels.listChannels.isNotEmpty) {
      //     _mapMenus[0] = responseChannels.listChannels;
      // }
      setState(() {
        widget.nameSlider = itemClicked.name;
        listTitleLevel = [
          widget.nameSlider,
          widget.routeScreenModel.categoryChoosen ?? "",
          "Categories",
        ];
        _mapMenus[0] = responseChannels.listChannels;
        _viewModel.addToMapMenus(_mapMenus);
        _selectedItemIndex = 0;
        // _mapMenus[0] = responseChannels.listChannels;

        _menuLevel = 0;
        print("list Of Channels ${listOfChannels[3].name}");

        // print("list Of Channels Screen data ${screenData.listOfChannels!.first.name}");
      });
    } else if (_menuLevel == 2) {
      _selectedItemIndex = 0;
      ResponseCategory responseCategories = await liveChannelService
          .getCategoriesChannelsByParentID(itemClicked.id);
      // if (responseCategories.listCategories.isNotEmpty) {
      // }

      setState(() {
        _mapMenus[1] = responseCategories.listCategories;
        _viewModel.addToMapMenus(_mapMenus);
        widget.routeScreenModel.categoryChoosen = itemClicked.name;
        listTitleLevel = [
          widget.nameSlider,
          widget.routeScreenModel.categoryChoosen ?? "",
          "Categories",
        ];
        _menuLevel = 1;
      });
    }
  }

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;

      if (_showMenu == false) {
        _menuLevel = 0;
      }
      print("_showMenu = $_showMenu");
    });
  }

  Widget _buildBackgroundVideo() {
    if (_controller.value.isInitialized) {
      // _showMenu = false;
      return Stack(
        children: [
          GestureDetector(
            onTap: _toggleMenu,
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: VideoPlayer(
                    _controller,
                  ),
                ),
              ),
            ),
          ),
          if (_menuLevel == 0 && _mapMenus[0].length > 0)
            InfoBarChannel(channelModel: _mapMenus[0][_selectedItemIndex]),
        ],
      );
    } else {
      // _selectedItemIndex = 0;
      // setState(() {
      //   _selectedItemIndex = 0;
      // });

      return Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorManager.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a dialog box asking the user to confirm the exit.
        // bool shouldExit = _viewModel.onWillPop(context, 0);
        bool shouldExit = await onWillPop(context);

        print("should Exit : $shouldExit");
        // If the user confirms the exit, close the app.
        if (shouldExit == true) {
          return true;
        }

        // Otherwise, don't close the app.
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              _selectedItemIndex == -1
                  ? BackgroundSlider(images: listOfBackgrounds)
                  : _buildBackgroundVideo(),
              StreamBuilder<ListChannelScreenModel>(
                stream: _viewModel.listChannelsDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Use the home data from the snapshot to build the UI
                    final screenData = snapshot.data!;
                    // listMenuLevel = [
                    //   screenData.listOfChannels!,
                    //   screenData.listOfChannels!,
                    //   widget.routeScreenModel.listOfUnderCategories!,
                    //   widget.routeScreenModel.navbarItems!,
                    // ];
                    // if (_selectedItemIndex == -1) {
                    //   listOfChannels = screenData.listOfChannels!;
                    // }

                    return Visibility(
                      visible: _showMenu,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black87.withOpacity(0.5),
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * .04,
                            horizontal:
                                MediaQuery.of(context).size.height * .05,
                          ),
                          width: MediaQuery.of(context).size.width * .45,
                          height: MediaQuery.of(context).size.height * .9,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                listTitleLevel[_menuLevel],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              Divider(
                                thickness: 2,
                                color: ColorManager.white,
                                height: 10,
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: _mapMenus[_menuLevel].length > 0
                                    ? ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: /*_menuLevel < 1
                                      ? listOfChannels.length
                                      : */
                                            _mapMenus[_menuLevel].length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              gradient: index ==
                                                      _selectedItemIndex
                                                  ? LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        ColorManager
                                                            .selectedNavBarItem,
                                                        Colors.transparent
                                                      ],
                                                    )
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                // screenData.indexClicked;
                                                final itemClicked =
                                                    _mapMenus[_menuLevel]
                                                        [index];
                                                _menuLevel == 0
                                                    ? _onItemSelected(index)
                                                    : getNewData(itemClicked);

                                                _viewModel.onItemClicked(index);
                                              },
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 5),
                                              ),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                // crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    height: _menuLevel == 0
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              /*_menuLevel == 0
                                                        ? listOfChannels[index]
                                                        .icon
                                                        : */
                                                              _mapMenus[_menuLevel]
                                                                      [index]
                                                                  .icon),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  _menuLevel == 0
                                                      ? Text(
                                                          index < 9
                                                              ? "0${index + 1}"
                                                              : (index + 1)
                                                                  .toString(),
                                                          style: getMediumStyle(
                                                            color: ColorManager
                                                                .selectedNavBarItem,
                                                            fontSize:
                                                                _menuLevel == 0
                                                                    ? FontSize
                                                                        .s20
                                                                    : FontSize
                                                                        .s22,
                                                          ),
                                                        )
                                                      : Container(),
                                                  _menuLevel == 0
                                                      ? Container(
                                                          width: 2,
                                                          height:
                                                              24, // adjust as needed
                                                          color: ColorManager
                                                              .selectedNavBarItem,
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                        )
                                                      : Container(),
                                                  SizedBox(
                                                      width: _menuLevel == 0
                                                          ? 5
                                                          : 10),
                                                  Expanded(
                                                    child: Text(
                                                      /*_menuLevel == 0
                                                    ? listOfChannels[index].name
                                                    :*/
                                                      _mapMenus[_menuLevel]
                                                                  [index]
                                                              .name ??
                                                          "Loading ...",
                                                      overflow:
                                                          TextOverflow.clip,
                                                      maxLines: 1,
                                                      style: getSemiBoldStyle(
                                                        color:
                                                            ColorManager.white,
                                                        fontSize:
                                                            _menuLevel == 0
                                                                ? FontSize.s20
                                                                : FontSize.s22,
                                                      ),
                                                    ),
                                                  ),
                                                  if (index ==
                                                      _selectedItemIndex)
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Icon(
                                                          Icons.play_arrow,
                                                          color: ColorManager
                                                              .selectedNavBarItem,
                                                          size: FontSize.s40),
                                                    ),
                                                  if (_menuLevel == 0)
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: IconButton(
                                                        icon: Icon(
                                                            _mapMenus[_menuLevel]
                                                                        [index]
                                                                    .isFavorite
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_outline,
                                                            color: ColorManager
                                                                .selectedNavBarItem,
                                                            size: FontSize.s30),
                                                        onPressed: () {
                                                          setState(() {
                                                            _mapMenus[_menuLevel]
                                                                        [index]
                                                                    .isFavorite =
                                                                !_mapMenus[_menuLevel]
                                                                        [index]
                                                                    .isFavorite;
                                                            ChannelModel
                                                                channel =
                                                                _mapMenus[
                                                                        _menuLevel]
                                                                    [index];
                                                            List<ChannelModel>
                                                                listFavorite;
                                                            if (LocalData()
                                                                .checkKey(
                                                                    AppConstants
                                                                        .liveFavorite)) {
                                                              listFavorite =
                                                                  LocalData().getData(
                                                                      AppConstants
                                                                          .liveFavorite);
                                                              listFavorite
                                                                  .add(channel);
                                                              LocalData().saveData(
                                                                  AppConstants
                                                                      .liveFavorite,
                                                                  listFavorite);
                                                            } else {
                                                              listFavorite = [
                                                                channel
                                                              ];
                                                              LocalData().saveData(
                                                                  AppConstants
                                                                      .liveFavorite,
                                                                  listFavorite);
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : WaitingWidget(
                                        title: listTitleLevel[_menuLevel]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error loading home data');
                  } else {
                    // return const Center(child: CircularProgressIndicator());
                    return WaitingWidget(title: widget.nameSlider);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (_menuLevel == 0) {
      // print("_backButtonCountController.value ${_backButtonCountController.value}");
      // Display time and info
      // onBackButtonClicked(_backButtonCountController.value);
      if (_showMenu == false) {
        _toggleMenu();
      }
      setState(() {
        _selectedItemIndex = 0;

        _menuLevel++;
      });
      print("backButtonCount $_menuLevel");

      return false;
    } else if (_menuLevel == 1) {
      // print("_backButtonCountController.value ${_backButtonCountController.value}");
      // Display time and info
      // onBackButtonClicked(_backButtonCountController.value);
      // _toggleMenu();
      setState(() {
        // _selectedItemIndex = 0;
        _menuLevel++;
      });
      print("backButtonCount $_menuLevel");
      return false;
    } else if (_menuLevel == 2) {
      // print("_backButtonCountController.value ${_backButtonCountController.value}");
      // Display time and info
      // onBackButtonClicked(_backButtonCountController.value);
      _menuLevel = 0;
      setState(() {
        // _selectedItemIndex = 0;
      });
      print("backButtonCount $_menuLevel");
      return true;
    }
    return true;
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _controller.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
