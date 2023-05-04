import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/category_response.dart';
import '../../../../domain/response/channel_response.dart';
import '../../../resources/color_manager.dart';
import '../../../widgets/waiting_widget.dart';
import '../../list_channel/view/list_channel_view.dart';
import '../viewmodel/favorite_screen_viewmodel.dart';

class FavoriteScreenView extends StatefulWidget {
  Future<dynamic>? repositoryFunction;
  String nameSlider;

  FavoriteScreenView(
      {required this.nameSlider, required this.repositoryFunction, super.key});

  @override
  _FavoriteScreenViewState createState() => _FavoriteScreenViewState();
}

class _FavoriteScreenViewState extends State<FavoriteScreenView> {
  late FavoriteScreenViewModel _viewModel;
  String bgImage = "";
  int _selectedItemIndex = 0;
  late List<ChannelModel> _listOfFavoriteChannels = [];
  late List<CategoryModel> _listNavBarItems = [];

  // late final StreamSubscription _subscriptionNavItem;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _viewModel = FavoriteScreenViewModel(widget.repositoryFunction!);
    _viewModel.start();
    _viewModel.FavoriteRouteDataStream.listen((moviesScreen) {
      // final list = moviesScreen.;
      setState(() {
        bgImage = moviesScreen.backgroundImage!;
        // listOfUnderCategories = ;
      });
    });

    // _listItems = _viewModel.listNavBarItems;

    _viewModel.selectedSliderIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedItemIndex = index;
      });
    });
    _viewModel.getlistFavoriteChannels.listen((list) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _listOfFavoriteChannels = list;
      });
    });
    _viewModel.getListNavBarItems.listen((listNav) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _listNavBarItems = listNav;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: ColorManager.darkPrimary,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.nameSlider,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(
                    color: ColorManager.white,
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<RouteScreenModel>(
            stream: _viewModel.FavoriteRouteDataStream,
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
                    // Carousel slider
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
                          scrollDirection: Axis.horizontal,
                          itemCount: _listNavBarItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TextButton(
                              onPressed: () {
                                // screenData.indexClicked;
                                final itemClicked = _listNavBarItems[index];

                                screenData.categoryChoosen = itemClicked.name;

                                // _viewModel.onItemClicked(
                                //   index,
                                //   liveChannelService
                                //       .getCategoriesChannelsByParentID(
                                //           itemClicked.id),
                                // );

                                // _selectedItemIndex = index;
                                // print("selected index : $_selectedItemIndex");
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                backgroundColor: _selectedItemIndex == index
                                    ? ColorManager.selectedNavBarItem
                                    : Colors.transparent,
                              ),
                              child: Text(
                                _listNavBarItems[index].name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * .06,
                      child: SizedBox(
                        // color: Colors.yellow,
                        // alignment: AlignmentGeometry.lerp(Alignment.centerLeft, Alignment.center, 3),
                        // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .05),
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: CarouselSlider.builder(
                          itemCount: _listOfFavoriteChannels.length,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            final slider = _listOfFavoriteChannels[index];
                            screenData.listOfChannels = _listOfFavoriteChannels;

                            return GestureDetector(
                              onTap: () {
                                Get.to(() => ListChannelView(
                                      nameSlider: slider.name,
                                      id: slider.id,
                                      routeScreenModel: screenData,
                                    ));
                              },
                              // onDoubleTap: () =>
                              //     Get.to(() => const MoviesScreenView()),
                              child: Container(
                                // margin: const EdgeInsets.symmetric(horizontal: 5.0),

                                // height: MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width * 0.2,

                                decoration: BoxDecoration(
                                  boxShadow:
                                      screenData.indexNavbarClicked == index
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
                                        screenData.indexNavbarClicked == index
                                            ? null
                                            : const ColorFilter.mode(
                                                Colors.black87,
                                                BlendMode.saturation,
                                              ),
                                    image: NetworkImage(slider.icon),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    slider.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: ColorManager.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            pauseAutoPlayOnTouch: true,
                            padEnds: _listOfFavoriteChannels.length < 3
                                ? true
                                : false,
                            pauseAutoPlayOnManualNavigate: true,
                            height: MediaQuery.of(context).size.height * 0.45,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: false,
                            viewportFraction: 0.28,
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
                );
              } else if (snapshot.hasError) {
                return const Text('Error loading home data');
              } else {
                // return const Center(child: CircularProgressIndicator());
                return WaitingWidget(
                  title: widget.nameSlider,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
