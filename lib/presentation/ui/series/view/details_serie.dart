import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../domain/response/serie_response.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../viewmodel/series_home_viewmodel.dart';
import 'list_dropdown_widget.dart';


class DetailsSerie extends StatefulWidget {
  SerieByCategoryInfosModel slider;
  SeriesHomeViewModel seriesHomeViewModel;

  DetailsSerie({
    required this.slider,
    required this.seriesHomeViewModel,
    Key? key,
  }) : super(key: key);

  @override
  State<DetailsSerie> createState() => _DetailsSerieState();
}

class _DetailsSerieState extends State<DetailsSerie>
    with SingleTickerProviderStateMixin {
  // List<String> keysList = [];
  late Map<String, List<EpisodeModel>> mapSerieAndEpisode;
  final FocusNode _rawDropdown = FocusNode();
  late String? rating;

  @override
  void initState() {
    super.initState();
    _rawDropdown.requestFocus();
    mapSerieAndEpisode = {};
    rating = widget.slider.rate.toString();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    widget.seriesHomeViewModel.fetchDetailsData(widget.slider);
    widget.seriesHomeViewModel.getMapSeasonsEpisodes.listen((map) {
      setState(() {
        mapSerieAndEpisode = map;
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .05,
                  // vertical: MediaQuery.of(context).size.width * .05,
                ),
                height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    bottomLeft: Radius.circular(45),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: ColorManager.backgroundSeries,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .25,
                  // vertical: MediaQuery.of(context).size.width * .05,
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  // color:
                  // homeData.indexClicked == index ? null : Colors.yellow,
                  color: ColorManager.black,
                  // borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .12,
                      top: MediaQuery.of(context).size.width * .05,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                // color: ColorManager.red,
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  widget.slider.name ?? "",
                                  style: getBoldStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s22,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                              Container(
                                // color: ColorManager.yellow,
                                margin: const EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  widget.slider.genre ?? "",
                                  style: getLightStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s18,
                                  ),
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .08,
                            // width: MediaQuery.of(context).size.width * 0.3,
                            // color:Colors.yellow,
                            child: Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: widget.slider.rate ?? 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: ColorManager.selectedNavBarItem,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                VerticalDivider(
                                  color: ColorManager.white,
                                  width:
                                      MediaQuery.of(context).size.width * .04,
                                  thickness: 0,
                                ),
                                // SizedBox(
                                //   width: MediaQuery.of(context).size.width * .03,
                                // ),
                                Text(
                                  widget.slider.date?.split('-')[0] ?? "",
                                  style: getSemiBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s18),
                                ),
                                VerticalDivider(
                                  color: ColorManager.white,
                                  width:
                                      MediaQuery.of(context).size.width * .04,
                                  thickness: 0,
                                ),
                                Text(
                                  "${(rating == "null" || rating == "") ? "0.0" : rating}/",
                                  style: getSemiBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s18),
                                ),
                                // IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_outline))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          ),
                          Container(
                            // color: ColorManager.yellow,
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              widget.slider.plot ?? "",
                              // textScaleFactor: 2,
                              style: TextStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s14,
                                height: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .09,
                  vertical: MediaQuery.of(context).size.width * .03,
                ),
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  // color:
                  // homeData.indexClicked == index ? null : Colors.yellow,
                  // borderRadius: const BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                    // colorFilter: const ColorFilter.mode(
                    //   Colors.black87,
                    //   BlendMode.saturation,
                    // ),
                    image: NetworkImage(widget.slider.icon ?? ""),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .75,
                  // vertical: MediaQuery.of(context).size.width * .05,
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: const BoxDecoration(
                  // color: Cp
                  // homeData.indexClicked == index ? null : Colors.yellow,
                  color: Colors.transparent,
                  // borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: mapSerieAndEpisode.isEmpty
                      ? Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(
                            // horizontal: MediaQuery.of(context).size.width * .09,
                            top: MediaQuery.of(context).size.height * .08,
                            right: MediaQuery.of(context).size.width * .1,
                          ),
                          //height: MediaQuery.of(context).size.height,
                          // width: double.infinity,
                          child: CircularProgressIndicator(
                            color: ColorManager.white,
                          ),
                        )
                      : Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(
                            // horizontal: MediaQuery.of(context).size.width * .09,
                            top: MediaQuery.of(context).size.height * .1,
                            // left: 0,
                          ),
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: FocusScope(
                              autofocus: true,
                              node: FocusScopeNode(),
                              child: VerticalDropdownButtonList(
                                mainFocusNode: _rawDropdown,
                                options: mapSerieAndEpisode,
                                seasonsList: mapSerieAndEpisode.keys.toList(),
                                viewModel: widget.seriesHomeViewModel,
                              ),

                          ))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
