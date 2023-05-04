import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/presentation/resources/font_manager.dart';
import 'package:iptv_sbi_v2/presentation/resources/styles_manager.dart';
import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/category_response.dart';
import '../../../../domain/response/serie_response.dart';
import '../../../../domain/services/serie_services.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../../widgets/filter_widget.dart';
import '../../../widgets/waiting_widget.dart';
import '../viewmodel/series_home_viewmodel.dart';
import 'details_serie.dart';

class SeriesHomeView extends StatefulWidget {
  List<CategoryModel> listPackageCategory;
  Future<dynamic>? repositoryFunction;
  String nameSlider;

  SeriesHomeView(
      {required this.nameSlider,
      required this.listPackageCategory,
      required this.repositoryFunction,
      super.key});

  @override
  _SeriesHomeViewState createState() => _SeriesHomeViewState();
}

class _SeriesHomeViewState extends State<SeriesHomeView> {
  late SeriesHomeViewModel _viewModel;
  String bgImage = "";
  int _selectedNavbarItemIndex = 0;
  int _selectedSliderIndex = 0;
  int _selectedFilterIndex = 0;
  late List<dynamic> listOfUnderCategories = [];
  late Map<String, List<EpisodeModel>> mapSerieAndEpisode = {};
  bool _showMenuFilter = false;

  // late final StreamSubscription _subscriptionNavItem;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _showMenuFilter = false;

    _viewModel = SeriesHomeViewModel(widget.repositoryFunction!);
    _viewModel.start();
    _viewModel.SeriesRouteDataStream.listen((moviesScreen) {
      // final list = moviesScreen.;
      setState(() {
        bgImage = moviesScreen.backgroundImage!;
        // listOfUnderCategories = ;
      });
    });

    _viewModel.selectedItemNavbarIndex.listen((index) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        _selectedNavbarItemIndex = index;
      });
    });
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
    _viewModel.getListUnderCategories.listen((list) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        listOfUnderCategories = list;
      });
    });
    _viewModel.getMapSeasonsEpisodes.listen((serieAndEpisodeMap) {
      setState(() {
        // bgImage = _viewModel.listSliders[index].backgroundImage;
        mapSerieAndEpisode = serieAndEpisodeMap;
      });
    });
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
        body: StreamBuilder<RouteScreenModel>(
          stream: _viewModel.SeriesRouteDataStream,
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

                  FilterWidget(
                    marginVertical: MediaQuery.of(context).size.width * .09,
                    marginHorizental: MediaQuery.of(context).size.height * .11,
                    toggleMenu: _toggleMenu,
                    filterBtnNode: FocusNode(),
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
                          top: MediaQuery.of(context).size.height * .06),
                      width: MediaQuery.of(context).size.width * .9,
                      height: MediaQuery.of(context).size.height * .12,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.listPackageCategory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                            onPressed: () {
                              // screenData.indexClicked;
                              final itemClicked =
                                  widget.listPackageCategory[index];

                              screenData.categoryChoosen = itemClicked.name;

                              Future<dynamic> function;

                              function = serieService
                                  .getSeriesByCategory(itemClicked.id);

                              _viewModel.onItemClicked(
                                index,
                                function,
                                widget.nameSlider,
                              );

                              // _selectedItemIndex = index;
                              // print("selected index : $_selectedItemIndex");
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              backgroundColor: _selectedNavbarItemIndex == index
                                  ? ColorManager.selectedNavBarItem
                                  : Colors.transparent,
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

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .3),
                      width: MediaQuery.of(context).size.width * .95,
                      height: MediaQuery.of(context).size.height * .8,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 0.75,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width * .02,
                          mainAxisSpacing:
                              MediaQuery.of(context).size.height * .05,
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
                              Get.to(() => DetailsSerie(
                                    slider: slider,
                                    seriesHomeViewModel: _viewModel,
                                  ));
                              screenData.indexSliderClicked = index;
                            },
                            // onDoubleTap: () =>
                            //     Get.to(() => const MoviesScreenView()),
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
                                        .38,
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
                                                margin: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .04),
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
                            ), /*Container(
                              // margin: const EdgeInsets.symmetric(horizontal: 5.0),

                              // height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.2,

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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8)),
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
                            ),*/
                          );
                        },
                      ),
                    ),
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
                                    width: MediaQuery.of(context).size.width *
                                        .05),
                                const Icon(
                                  Icons.filter_list,
                                  color: Colors.white,
                                  size: FontSize.s40,
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        .02),
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
                                              AppConstants
                                                  .menusFilterKey[index],
                                              style: getRegularStyle(
                                                  color: ColorManager.white,
                                                  fontSize: FontSize.s16),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              AppConstants
                                                  .menusFilterValue[index],
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
                                        MediaQuery.of(context).size.height *
                                            .025,
                                  ),
                                  color: ColorManager.white,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * .15,
                                  child: Center(
                                    child: Text(
                                      "APPLY FILTERS",
                                      style: getBoldStyle(
                                          color:
                                              ColorManager.selectedNavBarItem,
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
              );
            } else if (snapshot.hasError) {
              return const Text('Error loading home data');
            } else {
              // return const Center(child: CircularProgressIndicator());
              return WaitingWidget(title: widget.nameSlider);
            }
          },
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
