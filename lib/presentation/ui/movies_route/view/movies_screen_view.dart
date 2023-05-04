import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/presentation/ui/search/viewmodel/old_search_viewmodel.dart';
import 'package:iptv_sbi_v2/presentation/widgets/no_data_widget.dart';
import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/category_response.dart';
import '../../../../domain/services/livechannel_services.dart';
import '../../../../domain/services/movie_services.dart';
import '../../../../domain/services/serie_services.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../widgets/waiting_widget.dart';
import '../../list_channel/view/list_channel_view.dart';
import '../../search/view/search_view.dart';
import '../viewmodel/movies_screen_viewmodel.dart';
import 'movies_grid_view.dart';

class MoviesScreenView extends StatefulWidget {
  List<CategoryModel> listPackageCategory;
  Future<dynamic>? repositoryFunction;
  String nameSlider;

  MoviesScreenView({
    required this.nameSlider,
    required this.listPackageCategory,
    required this.repositoryFunction,
    super.key,
  });

  @override
  _MoviesScreenViewState createState() => _MoviesScreenViewState();
}

class _MoviesScreenViewState extends State<MoviesScreenView> {
  late MoviesScreenViewModel _viewModel;
  String bgImage = "";
  RouteScreenModel screenModel = RouteScreenModel();
  int _selectedItemNavbarIndex = 0;
  int _selectedSliderIndex = 0;
  late List<dynamic> listOfUnderCategories = [];
  late List<CategoryModel> _listItems = [];
  Future<dynamic> repoEmptyForTest = Future(() => null);
  final FocusNode _rawMainFocusScope = FocusNode();
  // final FocusNode _homeFocusNode = FocusNode();
  // final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _navbarItemFocusNode = FocusNode();

  bool _isNavbarFocused = true
      // _isBodyFocused = false
      /*_isHomeFocused = false*/;
  final _carouselController = CarouselController();
  final _scrollNavbarController = ScrollController();

  // late final StreamSubscription _subscriptionNavItem;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _viewModel = MoviesScreenViewModel(
        widget.repositoryFunction ?? repoEmptyForTest, widget.nameSlider);
    _viewModel.start();
    _viewModel.MoviesRouteDataStream.listen((moviesScreen) {
      // final list = moviesScreen.;
      setState(() {
        bgImage = moviesScreen.backgroundImage!;
        screenModel = moviesScreen;
      });
    });

    // _listItems = _viewModel.listNavBarItems;
    _listItems = widget.listPackageCategory;

    _viewModel.selectedItemNavbarIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedItemNavbarIndex = index;
      });
    });
    _viewModel.selectedSliderIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedSliderIndex = index;
      });
    });
    _viewModel.listUnderCategories.listen((list) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        listOfUnderCategories = list;
      });
    });
  }

  void _scrollListViewToSelected() {
    if (_scrollNavbarController.hasClients) {
      double screenWidth = MediaQuery.of(context).size.width;
      double itemWidth = screenWidth * .15;

      double centerOffset = (screenWidth - itemWidth) / 2;
      double targetOffset =
          (_selectedItemNavbarIndex * itemWidth) - centerOffset;

      _scrollNavbarController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollCarouselToSelected() {
    _carouselController.animateToPage(
      _selectedSliderIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<RouteScreenModel>(
        stream: _viewModel.MoviesRouteDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Use the home data from the snapshot to build the UI
            final screenData = snapshot.data!;

            return RawKeyboardListener(
              focusNode: _rawMainFocusScope,
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    if (!_isNavbarFocused) {
                      setState(() {
                        _isNavbarFocused = true;
                        _navbarItemFocusNode.requestFocus();
                        _selectedSliderIndex = 0;
                        _selectedItemNavbarIndex =
                            screenData.indexNavbarClicked;
                      });
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    if (_isNavbarFocused) {
                      setState(() {
                        // _searchFocusNode.unfocus();
                        // _homeFocusNode.unfocus();
                        _navbarItemFocusNode.unfocus();
                        _isNavbarFocused = false;
                        _selectedSliderIndex = 0;
                      });
                    }
                  } else if (event.logicalKey ==
                      LogicalKeyboardKey.arrowRight) {
                    if (_isNavbarFocused) {
                      setState(() {
                        _selectedItemNavbarIndex = (_selectedItemNavbarIndex ==
                                (_listItems.length - 1))
                            ? _selectedItemNavbarIndex
                            : _selectedItemNavbarIndex + 1;
                        screenModel.indexNavbarClicked =
                            _selectedItemNavbarIndex;
                      });
                      _scrollListViewToSelected();
                    } else {
                      setState(() {
                        _navbarItemFocusNode.unfocus();
                        _isNavbarFocused = false;
                        _selectedSliderIndex = (_selectedSliderIndex ==
                                (listOfUnderCategories.length - 1))
                            ? _selectedSliderIndex
                            : _selectedSliderIndex + 1;
                        screenModel.indexSliderClicked = _selectedSliderIndex;
                      });
                      _scrollCarouselToSelected();
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                    if (_isNavbarFocused) {
                      setState(() {
                        _selectedItemNavbarIndex =
                            (_selectedItemNavbarIndex == 0)
                                ? 0
                                : _selectedItemNavbarIndex - 1;
                        screenModel.indexNavbarClicked =
                            _selectedItemNavbarIndex;
                      });
                      _scrollListViewToSelected();
                    } else {
                      setState(() {
                        _navbarItemFocusNode.unfocus();
                        _selectedSliderIndex = (_selectedSliderIndex == 0)
                            ? 0
                            : _selectedSliderIndex - 1;
                        screenModel.indexSliderClicked = _selectedSliderIndex;
                      });
                      _scrollCarouselToSelected();
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.select) {
                    if (_isNavbarFocused) {
                      final itemClicked =
                          widget.listPackageCategory[_selectedItemNavbarIndex];

                      screenData.categoryChoosen = itemClicked.name;
                      screenData.indexNavbarClicked = _selectedItemNavbarIndex;

                      Future<dynamic>? function;

                      switch (widget.nameSlider) {
                        case "Live TV":
                          {
                            function = liveChannelService
                                .getCategoriesChannelsByParentID(
                                    itemClicked.id);
                          }
                          break;
                        case "Movies":
                          {
                            function = movieService
                                .getCategoriesMovies(itemClicked.id);
                          }
                          break;
                        case "Series":
                          {
                            function = serieService
                                .getSeriesByCategory(itemClicked.id);
                          }
                          break;
                      }

                      _viewModel.onItemClickedNavbar(
                        _selectedItemNavbarIndex,
                        function!,
                      );
                    } else {
                      screenData.indexSliderClicked = _selectedSliderIndex;
                      screenData.listOfUnderCategories = listOfUnderCategories;
                      screenData.navbarItems = widget.listPackageCategory;
                      print(
                          "screenData.navbarItems = ${screenData.navbarItems}");
                      switch (widget.nameSlider) {
                        case "Live TV":
                          {
                            Get.to(() => ListChannelView(
                                  nameSlider: listOfUnderCategories[
                                          _selectedSliderIndex]
                                      .name,
                                  id: listOfUnderCategories[
                                          _selectedSliderIndex]
                                      .id,
                                  routeScreenModel: screenData,
                                ));
                          }
                          break;
                        case "Movies":
                          {
                            final function = movieService.getMoviesByCategory(
                                listOfUnderCategories[_selectedSliderIndex].id);
                            Get.to(() => MoviesGridView(
                                  nameSlider: listOfUnderCategories[
                                          _selectedSliderIndex]
                                      .name,
                                  repositoryFunction: function,
                                ));
                          }
                          break;
                        case "Series":
                          {}
                          break;
                      }
                    }
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
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .08,
                        // right: MediaQuery.of(context).size.width * .25,
                      ),
                      width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.height * .15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        textDirection: TextDirection.rtl,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .1,
                          ),
                          SizedBox(
                            // margin: const EdgeInsets.only(bottom: 20),
                            width: MediaQuery.of(context).size.width * .12,
                            height: MediaQuery.of(context).size.height * .2,

                            child: IconButton(
                              // focusNode: _homeFocusNode,
                              onPressed: () => Get.back(),
                              // alignment: Alignment.topLeft,
                              icon: Icon(
                                Icons.home,
                                color: ColorManager.yellow,
                                size: MediaQuery.of(context).size.height * .1,
                                /*shadows: _isHomeFocused
                                    ? <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.yellow.shade200,
                                    offset: const Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                  ),
                                ]
                                    : null,*/
                              ),
                            ),
                          ),
                          OutlinedButton(
                            // focusNode: _searchFocusNode,
                            onPressed: () => Get.to(() => SearchViewModel()),
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4), // Set the desired border radius value
                                ),
                              ),
                              backgroundColor: const MaterialStatePropertyAll(
                                Colors.transparent,
                              ),
                              side: MaterialStatePropertyAll(
                                BorderSide(
                                  width: 1,
                                  color: ColorManager.yellow,
                                ),
                              ),
                              minimumSize: MaterialStatePropertyAll(
                                Size(
                                  120,
                                  MediaQuery.of(context).size.height * .1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: ColorManager.yellow,
                                  size:
                                      MediaQuery.of(context).size.height * .08,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  "SEARCH",
                                  style: getRegularStyle(
                                    color: ColorManager.white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            .045,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // nav bar list view
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black87.withOpacity(0.5),
                      ),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .25),
                      width: MediaQuery.of(context).size.width * .9,
                      height: MediaQuery.of(context).size.height * .12,
                      child: ListView.builder(
                        controller: _scrollNavbarController,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.listPackageCategory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                            focusNode: _navbarItemFocusNode,
                            onPressed: () {
                              // screenData.indexClicked;
                              final itemClicked =
                                  widget.listPackageCategory[index];

                              screenData.categoryChoosen = itemClicked.name;

                              Future<dynamic>? function;

                              switch (widget.nameSlider) {
                                case "Live TV":
                                  {
                                    function = liveChannelService
                                        .getCategoriesChannelsByParentID(
                                            itemClicked.id);
                                  }
                                  break;
                                case "Movies":
                                  {
                                    function = movieService
                                        .getCategoriesMovies(itemClicked.id);
                                  }
                                  break;
                                case "Series":
                                  {
                                    function = serieService
                                        .getSeriesByCategory(itemClicked.id);
                                  }
                                  break;
                              }

                              _viewModel.onItemClickedNavbar(
                                index,
                                function!,
                              );

                              // _selectedItemIndex = index;
                              // print("selected index : $_selectedItemIndex");
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              backgroundColor: _selectedItemNavbarIndex == index
                                  ? _isNavbarFocused
                                      ? ColorManager.selectedNavBarItem
                                      : ColorManager.selectedNavBarItem
                                          .withOpacity(0.3)
                                  : ColorManager.transparent,
                              foregroundColor: ColorManager.transparent,
                            ),
                            child: Text(
                              widget.listPackageCategory[index].name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      // color: Colors.yellow,
                      // alignment: AlignmentGeometry.lerp(Alignment.centerLeft, Alignment.center, 3),
                      // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .05),
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider.builder(
                        itemCount: listOfUnderCategories.length,
                        carouselController: _carouselController,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          final slider = listOfUnderCategories[index];
                          screenData.listOfUnderCategories =
                              listOfUnderCategories;

                          return GestureDetector(
                            onTap: () {
                              screenData.navbarItems =
                                  widget.listPackageCategory;

                              switch (widget.nameSlider) {
                                case "Live TV":
                                  {
                                    Get.to(() => ListChannelView(
                                          nameSlider: slider.name,
                                          id: slider.id,
                                          routeScreenModel: screenData,
                                        ));
                                  }
                                  break;
                                case "Movies":
                                  {
                                    final function = movieService
                                        .getMoviesByCategory(slider.id);
                                    Get.to(() => MoviesGridView(
                                          nameSlider: slider.name,
                                          repositoryFunction: function,
                                        ));
                                  }
                                  break;
                                case "Series":
                                  {
                                    // function = serieService
                                    //     .getSeriesByCategory(itemClicked.id);
                                  }
                                  break;
                              }
                            },
                            // onDoubleTap: () =>
                            //     Get.to(() => const MoviesScreenView()),
                            child: Container(
                              // margin: const EdgeInsets.symmetric(horizontal: 5.0),

                              height: MediaQuery.of(context).size.height * 0.8,
                              width: MediaQuery.of(context).size.width * 0.175,

                              decoration: BoxDecoration(
                                boxShadow: _selectedSliderIndex == index
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                  colorFilter: _selectedSliderIndex == index
                                      ? null
                                      : const ColorFilter.mode(
                                          Colors.black87,
                                          BlendMode.saturation,
                                        ),
                                  image: NetworkImage(slider.icon),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              /*child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  slider.name,
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
                          pauseAutoPlayOnTouch: true,
                          padEnds:
                              listOfUnderCategories.length < 3 ? true : false,
                          pauseAutoPlayOnManualNavigate: true,
                          height: MediaQuery.of(context).size.height * 0.55,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.25,
                          aspectRatio: 16 / 9,
                          initialPage: 0,
                          reverse: false,
                          autoPlay: true,
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
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const NoDataWidget();
          } else {
            // return const Center(child: CircularProgressIndicator());
            return WaitingWidget(title: widget.nameSlider);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
