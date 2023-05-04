import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../video_player/view/videoplayer_view.dart';

class DetailsMovie extends StatefulWidget {
  dynamic slider;

  // List<SaisonModel> listOfSeasons;

  DetailsMovie({
    required this.slider,
    // required this.listOfSeasons,
    Key? key,
  }) : super(key: key);

  @override
  State<DetailsMovie> createState() => _DetailsMovieState();
}

class _DetailsMovieState extends State<DetailsMovie> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
                  left: MediaQuery.of(context).size.width * .03,
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
                  left: MediaQuery.of(context).size.width * .2,
                  // vertical: MediaQuery.of(context).size.width * .05,
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                      left: MediaQuery.of(context).size.width * .15,
                      right: MediaQuery.of(context).size.width * .05,
                      top: MediaQuery.of(context).size.width * .01,
                      bottom: MediaQuery.of(context).size.width * .025,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.slider.name,
                                  style: getBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s18),
                                ),
                                Text(
                                  widget.slider.genre!,
                                  style: getLightStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s14),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .1,
                              height: MediaQuery.of(context).size.width * .1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.favorite_outline,
                                      color: ColorManager.white,
                                      size: 35,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.share,
                                      color: ColorManager.white,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * .1,
                        // ),
                        Container(
                          decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(45)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          height: MediaQuery.of(context).size.height * .15,
                          width: MediaQuery.of(context).size.width * 0.5,
                          // color:Colors.yellow,
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: ColorManager.selectedNavBarItem,
                                size: 35,
                              ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width * .03,
                              ),
                              Text(
                                widget.slider.date!,
                                style: getSemiBoldStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s14),
                              ),
                              // IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_outline))
                            ],
                          ),
                        ),

                        Text(
                          widget.slider.cast!,
                          style: getSemiBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            OutlinedButton(
                              style: ButtonStyle(
                                iconColor: MaterialStatePropertyAll(
                                    ColorManager.white),
                                iconSize: const MaterialStatePropertyAll(45),
                                padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 2),
                                ),
                                side: MaterialStatePropertyAll(
                                  BorderSide(
                                      color: ColorManager.white, width: 2.0),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(
                                        MediaQuery.of(context).size.width * .15,
                                        AppSize.s20)),
                              ),
                              onPressed: () {
                                Get.to(() => VideoPlayerView(
                                      url: widget.slider.url,
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.play_arrow,
                                    // color: ColorManager.white,
                                    // size: 50,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .02,
                                  ),
                                  Text(
                                    "PLAY",
                                    style: getSemiBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s17,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .02,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .075,
                            ),
                            OutlinedButton(
                              style: ButtonStyle(
                                iconColor: MaterialStatePropertyAll(
                                    ColorManager.white),
                                iconSize: const MaterialStatePropertyAll(45),
                                padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 0),
                                ),
                                side: MaterialStatePropertyAll(
                                  BorderSide(
                                      color: ColorManager.white, width: 2.0),
                                ),
                                // minimumSize: MaterialStateProperty.all<Size>(
                                //     Size(
                                //         MediaQuery.of(context).size.width * .15,
                                //         AppSize.s20)),
                              ),
                              onPressed: () {
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .02,
                                  ),
                                  Text(
                                    "SUBTITLE",
                                    style: getSemiBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s17,
                                    ),
                                  ),
                                  Container(
                                    height: 49,
                                    width: 2,
                                    color: ColorManager.white,
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .075,
                  vertical: MediaQuery.of(context).size.width * .025,
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
                    image: NetworkImage(widget.slider.icon!),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
