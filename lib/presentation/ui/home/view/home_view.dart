import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/presentation/ui/search/viewmodel/old_search_viewmodel.dart';
import 'package:iptv_sbi_v2/presentation/widgets/no_data_widget.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../../../../data/repositories/favorite_repo.dart';
import '../../../../data/storage/local_data.dart';
import '../../../../domain/models/home_model.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../widgets/banner_page.dart';
import '../../../widgets/waiting_widget.dart';
import '../../favorite/view/favorite_screen_view.dart';
import '../../movies_route/view/movies_screen_view.dart';
import '../../search/view/search_view.dart';
import '../../series/view/series_home_view.dart';
import '../../music/view/music_view.dart';
import '../../radio/view/radio_view.dart';
import '../../settings/view/settings_view.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;
  String bgImage = "";
  int _selectedSliderIndex = 0;
  final FocusNode _rawMainFocusScope = FocusNode();
  final FocusNode _powerFocusNode = FocusNode();
  final FocusNode _settingsFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _favoriteFocusNode = FocusNode();

  bool _ispowerFocus = false;
  bool _isSettingsFocus = false;
  bool _isSearchFocus = false;
  bool _isFavoriteFocus = false;
  bool _isCarouselFocused = true;

  // final FocusNode _registerFocus = FocusNode();
  // late final StreamSubscription _subscription;
  final _carouselController = CarouselController();

  final NetworkInfo _networkInfo = NetworkInfo();
  String? macAddress;

  void getMacAddress() async {
    try {
      macAddress = await _networkInfo.getWifiBSSID();
      print("wifiBSSID = $macAddress");
    } on PlatformException {
      macAddress = 'Failed to get Wifi BSSID';
    }
    // 34:e8:94:d6:0c:70
  }

  @override
  void initState() {
    super.initState();
    getMacAddress();

    if (LocalData().checkKey("is_logged_in")) {
      bool isLoggedIn = LocalData().getData("is_logged_in");
      print("check logged in = $isLoggedIn");
    }

    print("mac address : $macAddress");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // _rawCarouselFocus.requestFocus();
    _viewModel = HomeViewModel();
    _viewModel.start();
    _viewModel.homeDataStream.listen((home) {
      setState(() {
        bgImage = home.sliders[0].backgroundImage;
      });
    });
    _viewModel.bgImageDataStream.listen((newBgImage) {
      setState(() {
        bgImage = newBgImage;
      });
    });
    _viewModel.selectedSliderIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedSliderIndex = index;
      });
    });
  }

  void _scrollToSelected() {
    _carouselController.animateToPage(
      _selectedSliderIndex,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a dialog box asking the user to confirm the exit.
        bool shouldExit = await _viewModel.onWillPop(context);

        // If the user confirms the exit, close the app.
        if (shouldExit == true) {
          return true;
        }

        // Otherwise, don't close the app.
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder<HomeModel>(
            stream: _viewModel.homeDataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Use the home data from the snapshot to build the UI
                final homeData = snapshot.data!;

                return RawKeyboardListener(
                  focusNode: _rawMainFocusScope,
                  onKey: (RawKeyEvent event) {
                    if (event is RawKeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                        if (_isCarouselFocused) {
                          // Switch focus to the buttons
                          // _ra.unfocus();
                          setState(() {
                            _isCarouselFocused = false;
                            _isSearchFocus = true;
                            _searchFocusNode.requestFocus();
                          });
                        }
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowDown) {
                        if (!_isCarouselFocused) {
                          _searchFocusNode.unfocus();
                          _favoriteFocusNode.unfocus();
                          _powerFocusNode.unfocus();
                          _settingsFocusNode.unfocus();

                          setState(() {
                            _ispowerFocus = false;
                            _isSettingsFocus = false;
                            _isSearchFocus = false;
                            _isFavoriteFocus = false;
                            _isCarouselFocused = true;
                          });
                        }
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowRight) {
                        if (_isCarouselFocused) {
                          setState(() {
                            _selectedSliderIndex = (_selectedSliderIndex ==
                                    (homeData.sliders.length - 1))
                                ? _selectedSliderIndex
                                : _selectedSliderIndex + 1;
                          });
                          _scrollToSelected();
                        } else if (_isSearchFocus) {
                          _searchFocusNode.unfocus();
                          _favoriteFocusNode.requestFocus();

                          setState(() {
                            _isSearchFocus = false;
                            _isFavoriteFocus = true;
                            _isSettingsFocus = false;
                            _ispowerFocus = false;
                          });
                        } else if (_isFavoriteFocus) {
                          _favoriteFocusNode.unfocus();
                          _settingsFocusNode.requestFocus();

                          setState(() {
                            _isSearchFocus = false;
                            _isFavoriteFocus = false;
                            _isSettingsFocus = true;
                            _ispowerFocus = false;
                          });
                        } else if (_isSettingsFocus) {
                          _settingsFocusNode.unfocus();
                          _powerFocusNode.requestFocus();

                          setState(() {
                            _isSearchFocus = false;
                            _isFavoriteFocus = false;
                            _isSettingsFocus = false;
                            _ispowerFocus = true;
                          });
                        }
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowLeft) {
                        if (_isCarouselFocused) {
                          setState(() {
                            _selectedSliderIndex = (_selectedSliderIndex == 0)
                                ? 0
                                : _selectedSliderIndex - 1;
                          });
                          _scrollToSelected();
                        } else if (_ispowerFocus) {
                          _powerFocusNode.unfocus();
                          _settingsFocusNode.requestFocus();

                          setState(() {
                            _isSearchFocus = false;
                            _isFavoriteFocus = false;
                            _isSettingsFocus = true;
                            _ispowerFocus = false;
                          });
                        } else if (_isSettingsFocus) {
                          _settingsFocusNode.unfocus();
                          _favoriteFocusNode.requestFocus();

                          setState(() {
                            _isSearchFocus = false;
                            _isFavoriteFocus = true;
                            _isSettingsFocus = false;
                            _ispowerFocus = false;
                          });
                        } else if (_isFavoriteFocus) {
                          _favoriteFocusNode.unfocus();
                          _searchFocusNode.requestFocus();

                          setState(() {
                            _isSearchFocus = true;
                            _isFavoriteFocus = false;
                            _isSettingsFocus = false;
                            _ispowerFocus = false;
                          });
                        }
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.select) {
                        if (_isCarouselFocused) {
                          if (homeData.indexClicked == _selectedSliderIndex) {
                            final listNavbarItems = homeData
                                    .sliders[_selectedSliderIndex].lives +
                                homeData.sliders[_selectedSliderIndex].movies +
                                homeData.sliders[_selectedSliderIndex].series;

                            switch (
                                homeData.sliders[_selectedSliderIndex].title) {
                              case "Series":
                                {
                                  Get.to(() => SeriesHomeView(
                                        nameSlider: homeData
                                            .sliders[_selectedSliderIndex]
                                            .title,
                                        repositoryFunction: homeData
                                            .sliders[_selectedSliderIndex]
                                            .fetchScreenRepo,
                                        listPackageCategory: listNavbarItems,
                                      ));
                                }
                                break;
                              case "Music":
                                Get.to(() => MusicPage());
                                break;
                              case "Radio":
                                Get.to(() => RadioPage());
                                break;

                              default:
                                {
                                  Get.to(() => MoviesScreenView(
                                        nameSlider: homeData
                                            .sliders[_selectedSliderIndex]
                                            .title,
                                        repositoryFunction: homeData
                                            .sliders[_selectedSliderIndex]
                                            .fetchScreenRepo,
                                        listPackageCategory: listNavbarItems,
                                      ));
                                }
                            }
                          } else {
                            homeData.indexClicked = _selectedSliderIndex;
                            print(
                                "index clicked from select remote is ${homeData.indexClicked}");
                            _viewModel.backgroundChange(homeData
                                .sliders[_selectedSliderIndex].backgroundImage);
                            _viewModel.onSliderClicked(_selectedSliderIndex);
                          }
                        } else if (_isSearchFocus) {
                          Get.to(() => SearchViewModel());
                        } else if (_isFavoriteFocus) {
                          Get.to(() => FavoriteScreenView(
                              nameSlider: "Favorite",
                              repositoryFunction: FavoriteScreenRepository()
                                  .fetchFavoriteScreenData()));
                        } else if (_isSettingsFocus) {
                          Get.to(() => const SettingsView());
                        } else if (_ispowerFocus) {
                          _viewModel.onWillPop(context);
                        }
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      // Background image
                      Image.network(
                        bgImage,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),

                      /*const Align(
                        alignment: Alignment.topLeft,
                        child: BannerFB(),
                      ),*/

                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .05,
                            right: MediaQuery.of(context).size.width * .08,
                          ),
                          width: MediaQuery.of(context).size.width * .55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            textDirection: TextDirection.rtl,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: _ispowerFocus
                                      ? [
                                          BoxShadow(
                                            color: ColorManager.yellow
                                                .withOpacity(0.6),
                                            spreadRadius: 3,
                                            blurRadius: 20,
                                            offset: const Offset(0, 0),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: IconButton(
                                  focusNode: _powerFocusNode,
                                  onPressed: () =>
                                      _viewModel.onWillPop(context),
                                  icon: Icon(
                                    Icons.power_settings_new,
                                    color: ColorManager.yellow,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: _isSettingsFocus
                                      ? [
                                          BoxShadow(
                                            color: ColorManager.yellow
                                                .withOpacity(0.6),
                                            spreadRadius: 3,
                                            blurRadius: 20,
                                            offset: const Offset(0, 0),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: IconButton(
                                  // onPressed: () => Get.to(() => const SettingsView()),

                                  onPressed: () =>
                                      Get.to(() => const SettingsView()),
                                  focusNode: _settingsFocusNode,
                                  icon: Icon(
                                    Icons.settings,
                                    color: ColorManager.yellow,
                                    size: 35,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                focusNode: _favoriteFocusNode,
                                onPressed: () =>
                                    Get.to(() => FavoriteScreenView(
                                          nameSlider: "Favorite",
                                          repositoryFunction:
                                              FavoriteScreenRepository()
                                                  .fetchFavoriteScreenData(),
                                        )),
                                style: OutlinedButton.styleFrom(
                                  primary: ColorManager.yellow,
                                  side: BorderSide(
                                    color: ColorManager.yellow,
                                    width: _isFavoriteFocus ? 2.5 : 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: _isFavoriteFocus
                                      ? ColorManager.yellow.withOpacity(.8)
                                      : ColorManager.transparent,
                                  foregroundColor: ColorManager.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.favorite_outlined,
                                      color: ColorManager.yellow,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "FAVORITES",
                                      style: getSemiBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s18,
                                        isUnderline: _isFavoriteFocus,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                focusNode: _searchFocusNode,
                                onPressed: () =>
                                    Get.to(() => SearchViewModel()),
                                style: OutlinedButton.styleFrom(
                                  primary: ColorManager.yellow,
                                  side: BorderSide(
                                    color: ColorManager.yellow,
                                    width: _isSearchFocus ? 2.5 : 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: _isSearchFocus
                                      ? ColorManager.yellow.withOpacity(.8)
                                      : ColorManager.transparent,
                                  foregroundColor: ColorManager.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: ColorManager.yellow,
                                      size: 35,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      "SEARCH",
                                      style: getSemiBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s18,
                                        isUnderline: _isSearchFocus,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Carousel slider
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.1,
                        child: SizedBox(
                          // color: Colors.yellow,
                          // alignment: AlignmentGeometry.lerp(Alignment.centerLeft, Alignment.center, 3),
                          // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .05),
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider.builder(
                            carouselController: _carouselController,
                            itemCount: homeData.sliders.length,
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              final slider = homeData.sliders[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (homeData.indexClicked == index) {
                                      final listNavbarItems =
                                          homeData.sliders[index].lives +
                                              homeData.sliders[index].movies +
                                              homeData.sliders[index].series;

                                      switch (homeData.sliders[index].title) {
                                        case "Series":
                                          {
                                            Get.to(() => SeriesHomeView(
                                                  nameSlider: homeData
                                                      .sliders[index].title,
                                                  repositoryFunction: homeData
                                                      .sliders[index]
                                                      .fetchScreenRepo,
                                                  listPackageCategory:
                                                      listNavbarItems,
                                                ));
                                          }
                                          break;

                                        case "Music":
                                          Get.to(() => MusicPage());
                                          break;
                                        case "Radio":
                                          Get.to(() => RadioPage());
                                          break;

                                        default:
                                          {
                                            Get.to(() => MoviesScreenView(
                                                  nameSlider: homeData
                                                      .sliders[index].title,
                                                  repositoryFunction: homeData
                                                      .sliders[index]
                                                      .fetchScreenRepo,
                                                  listPackageCategory:
                                                      listNavbarItems,
                                                ));
                                          }
                                      }
                                    } else {
                                      homeData.indexClicked = index;
                                      _viewModel.backgroundChange(
                                          slider.backgroundImage);
                                      _viewModel.onSliderClicked(index);
                                    }
                                  });
                                },
                                // onFocus: (bool isFocused) =>
                                //     setState(() => _foccusedIndex = index),
                                child: Container(
                                  // margin: const EdgeInsets.symmetric(horizontal: 5.0),

                                  // height: MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,

                                  decoration: BoxDecoration(
                                    boxShadow: _selectedSliderIndex == index
                                        // _foccusedIndex == index
                                        ? [
                                            const BoxShadow(
                                              color: Colors.blue,
                                              spreadRadius: 3,
                                              blurRadius: 2,
                                              offset: Offset(0, 0),
                                            ),
                                          ]
                                        : null,
                                    // color:
                                    // homeData.indexClicked == index ? null : Colors.yellow,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    image: DecorationImage(
                                      colorFilter:
                                          homeData.indexClicked == index
                                              ? null
                                              : const ColorFilter.mode(
                                                  Colors.black87,
                                                  BlendMode.saturation,
                                                ),
                                      // image: AssetImage(slider.sliderImage),
                                      image: NetworkImage(slider.sliderImage),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  /*child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      slider.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ColorManager.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),*/
                                ),
                              );
                            },
                            options: CarouselOptions(
                              pauseAutoPlayOnManualNavigate: true,
                              height: MediaQuery.of(context).size.height * 0.6,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.215,
                              aspectRatio: 16 / 9,
                              initialPage: 0,
                              reverse: false,
                              autoPlay: true,
                              padEnds: false,
                              autoPlayInterval: const Duration(seconds: 15),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              enlargeCenterPage: false,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, _) {
                                // _viewModel.backgroundChange(
                                //     homeData.sliders[index].backgroundImage);
                              },
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.all(
                            MediaQuery.of(context).size.height * .02,
                          ),
                          child: Text(
                            "Expire Date [2023-10-06]",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 14,
                                  color:
                                      Colors.white, // Set text color to white
                                ), // Add null check to the target
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const NoDataWidget();
              } else {
                // return const Center(child: CircularProgressIndicator());
                return WaitingWidget(title: "Home Page");
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _rawMainFocusScope.dispose();
    _carouselController.stopAutoPlay();
    _powerFocusNode.dispose();
    _settingsFocusNode.dispose();
    _searchFocusNode.dispose();
    _favoriteFocusNode.dispose();
    super.dispose();
  }

// Widget _homeListButtons(){
//   return ;
// }
}
