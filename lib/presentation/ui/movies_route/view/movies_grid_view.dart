import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/movie_response.dart';
import '../../../../domain/response/serie_response.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../widgets/filter_widget.dart';
import '../viewmodel/movies_grid_viewmodel.dart';
import 'details_movie.dart';

class MoviesGridView extends StatefulWidget {
  List<ResponseMoviesInfo>? listMovies;
  Future<dynamic>? repositoryFunction;
  String nameSlider;

  MoviesGridView({
    required this.nameSlider,
    // required this.listMovies,
    required this.repositoryFunction,
    super.key,
  });

  @override
  _MoviesGridViewState createState() => _MoviesGridViewState();
}

class _MoviesGridViewState extends State<MoviesGridView> {
  late MoviesGridViewModel _viewModel;

  // String bgImage = "";
  int _selectedSliderIndex = 0;
  int _selectedFilterIndex = 0;

  late List<dynamic> listOfUnderCategories = [];
  late List<SaisonModel> _listSesons = [];
  bool _showMenuFilter = false;

  // late final StreamSubscription _subscriptionNavItem;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _viewModel = MoviesGridViewModel(widget.repositoryFunction!);
    _viewModel.start();
    _viewModel.selectedSliderIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedSliderIndex = index;
      });
    });
    _viewModel.selectedFilterIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedFilterIndex = index;
      });
    });
    _viewModel.getListMovies.listen((list) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        listOfUnderCategories = list;
      });
    });
    print("_ListMoviesStreamController : $listOfUnderCategories");
  }

  void _toggleMenu() {
    setState(() {
      _showMenuFilter = !_showMenuFilter;
      print("_showMenu = $_showMenuFilter");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        if (_showMenuFilter == true) {
          _toggleMenu();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: ColorManager.backgroundSeries,
                ),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .06,
                    horizontal: MediaQuery.of(context).size.width * .05,
                  ),
                  width: MediaQuery.of(context).size.width * .9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorManager.selectedNavBarItem,
                        ),
                        width: widget.nameSlider.length <= 10
                            ? MediaQuery.of(context).size.width * 0.35
                            : MediaQuery.of(context).size.width *
                                4 /
                                widget.nameSlider.length,
                        height: 2.5,
                      ),
                      Text(
                        widget.nameSlider,
                        style: getSemiBoldStyle(
                            color: ColorManager.white, fontSize: FontSize.s22),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorManager.selectedNavBarItem,
                        ),
                        width: widget.nameSlider.length <= 10
                            ? MediaQuery.of(context).size.width * 0.35
                            : MediaQuery.of(context).size.width *
                                4 /
                                widget.nameSlider.length,
                        height: 2.5,
                      ),
                    ],
                  ),
                )),
            FilterWidget(
              marginVertical: MediaQuery.of(context).size.height * .13,
              marginHorizental: MediaQuery.of(context).size.width * .1,
              toggleMenu: _toggleMenu, filterBtnNode: FocusNode(),
            ),
            StreamBuilder<RouteScreenModel>(
              stream: _viewModel.MoviesGridViewDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Use the home data from the snapshot to build the UI
                  final screenData = snapshot.data!;

                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .25),
                      width: MediaQuery.of(context).size.width * .95,
                      height: MediaQuery.of(context).size.height * .8,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.75,
                          crossAxisCount: 5,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width * .03,
                          mainAxisSpacing:
                              MediaQuery.of(context).size.height * .1,
                        ),
                        itemCount: listOfUnderCategories.length,
                        itemBuilder: (BuildContext context, int index) {
                          final slider = listOfUnderCategories[index];
                          screenData.listOfUnderCategories =
                              listOfUnderCategories;
                          String? yearOfMovie =
                              slider.date.toString().split('-')[0];
                          return GestureDetector(
                            onTap: () {
                              _viewModel.onSliderClicked(index);
                              if (screenData.indexSliderClicked == index) {
                                Get.to(() => DetailsMovie(
                                      slider: slider,
                                    ));
                              }
                              screenData.indexSliderClicked = index;
                            },
                            child: Container(
                              // margin: const EdgeInsets.symmetric(horizontal: 5.0),

                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.3,

                              decoration: BoxDecoration(
                                color: _selectedSliderIndex == index
                                    ? ColorManager.darkPrimary
                                    : ColorManager.white,
                                boxShadow: _selectedSliderIndex == index
                                    ? [
                                        const BoxShadow(
                                          color: Colors.blue,
                                          spreadRadius: 8,
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ]
                                    : null,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(0)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .35,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(slider.icon),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    // alignment: Alignment.centerLeft,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.12,
                                        child: Text(
                                          slider.name,
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: FontSize.s14,
                                            color: _selectedSliderIndex == index
                                                ? ColorManager.white
                                                : ColorManager.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      yearOfMovie.isNotEmpty
                                          ? Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: ColorManager
                                                      .selectedNavBarItem,
                                                ),
                                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05),
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Text(
                                                  yearOfMovie,
                                                  style: getRegularStyle(
                                                      color: ColorManager.white,
                                                      fontSize: FontSize.s12),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error loading home data');
                } else {
                  // return const Center(child: CircularProgressIndicator());
                  // return WaitingWidget(title: widget.nameSlider);
                  return Container();
                }
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: _showMenuFilter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.grey,
                  ),
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.height,
                  // margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * .05,),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .05),
                          const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                            size: FontSize.s40,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .02),
                          Text(
                            "Filter",
                            style: getSemiBoldStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s30),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        thickness: 2,
                        color: ColorManager.white,
                        height: 10,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: AppConstants.menusFilterKey.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: index == _selectedFilterIndex
                                    ? LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          ColorManager.selectedNavBarItem,
                                          Colors.transparent
                                        ],
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // screenData.indexClicked;
                                  // final itemClicked =
                                  // _mapMenus[_menuLevel]
                                  // [index];
                                  // _menuLevel == 0
                                  //     ? _onItemSelected(index)
                                  //     : getNewData(itemClicked);
                                  //
                                  _viewModel.onFilterClicked(index);
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppConstants.menusFilterKey[index],
                                        style: getRegularStyle(
                                            color: ColorManager.white,
                                            fontSize: FontSize.s16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        AppConstants.menusFilterValue[index],
                                        style: getRegularStyle(
                                            color: ColorManager.white,
                                            fontSize: FontSize.s12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * .025,
                            ),
                            color: ColorManager.white,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .15,
                            child: Center(
                              child: Text(
                                "APPLY FILTERS",
                                style: getBoldStyle(
                                    color: ColorManager.selectedNavBarItem,
                                    fontSize: FontSize.s30),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
