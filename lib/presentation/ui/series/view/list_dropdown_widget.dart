import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../domain/response/serie_response.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../video_player/view/videoplayer_view.dart';
import '../viewmodel/series_home_viewmodel.dart';

class VerticalDropdownButtonList extends StatefulWidget {
  Map<String, List<EpisodeModel>> options;
  List<String> seasonsList;
  FocusNode mainFocusNode;
  SeriesHomeViewModel viewModel;

  VerticalDropdownButtonList({
    super.key,
    required this.options,
    required this.seasonsList,
    required this.mainFocusNode,
    required this.viewModel,
  });

  @override
  _VerticalDropdownButtonListState createState() =>
      _VerticalDropdownButtonListState();
}

class _VerticalDropdownButtonListState
    extends State<VerticalDropdownButtonList> {
  int _selectedSeasonIndex = -1;
  int _selectedEpisodeIndex = 0;
  final _scrollSeasonController = ScrollController();
  FocusNode seasonNode = FocusNode();
  FocusNode episodeNode = FocusNode();
  // FocusNode _rawEpisodeFocusNode = FocusNode();
  bool _isSeasonFocused = true;
  bool _isTapped = false;
  // int j = 0;

  @override
  void initState() {
    seasonNode.requestFocus();
    widget.viewModel.selectedSeasonIndex.listen((indexSelected) {
      _selectedSeasonIndex = indexSelected;
    });
    widget.viewModel.selectedEpisodeIndex.listen((indexSelected) {
      _selectedEpisodeIndex = indexSelected;
    });
    super.initState();
  }

  void _toggleMenu() {
    setState(() {
      _isTapped = !_isTapped;
      print("_isTapped = $_isTapped");
    });
  }

  void _scrollListSeasonToSelected() {
    if (_scrollSeasonController.hasClients) {
      _scrollSeasonController.animateTo(
        _selectedSeasonIndex * (MediaQuery.of(context).size.height * .25),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  void _scrollListEpisodeToSelected() {
    if (_scrollSeasonController.hasClients) {
      _scrollSeasonController.animateTo(
        _selectedEpisodeIndex * (MediaQuery.of(context).size.height * .25),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollSeasonController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widget.options.length; i++)
            RawKeyboardListener(
              focusNode: widget.mainFocusNode,
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    print("_isSeason Focus = $_isSeasonFocused");
                    if (_isSeasonFocused) {
                      setState(() {
                        // _isSeasonFocused = false;
                        _selectedSeasonIndex = (_selectedSeasonIndex == 0)
                            ? 0
                            : _selectedSeasonIndex - 1;
                        // i = _selectedSeasonIndex;
                        print("season up down focused");

                      });
                      _scrollListSeasonToSelected();
                    } else {
                      setState(() {
                        // (_selectedSeasonIndex == 0) ?
                        // FocusScope.of(context).requestFocus(episodeNode);

                        // _selectedSeasonIndex = _selectedSeasonIndex - 1;
                        _selectedEpisodeIndex = (_selectedEpisodeIndex == 0)
                            ? 0
                            : _selectedEpisodeIndex - 1;
                        // i = _selectedSeasonIndex;
                        print("episode arrow up focused");
                      });
                      _scrollListEpisodeToSelected();

                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    if (_isSeasonFocused) {
                      setState(() {
                        _selectedSeasonIndex = (_selectedSeasonIndex ==
                                (widget.seasonsList.length - 1))
                            ? _selectedSeasonIndex
                            : _selectedSeasonIndex + 1;
                        // widget.viewModel.onSelectEpisode(_selectedEpisodeIndex);
                        print("season arrow down focused");
                        // i = _selectedSeasonIndex;
                      });
                      _scrollListSeasonToSelected();
                    } else {
                      setState(() {
                        _selectedEpisodeIndex = (_selectedEpisodeIndex ==
                                (widget.options[widget.seasonsList[_selectedSeasonIndex]]!.length -
                                    1))
                            ? _selectedEpisodeIndex
                            : _selectedEpisodeIndex + 1;
                        print("episode arrow down focused");
                      });
                      _scrollListEpisodeToSelected();
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.select) {
                    print("lahdha");
                    if (_isSeasonFocused && i == _selectedSeasonIndex) {
                      // FocusScope.of(context).requestFocus(_rawEpisodeFocusNode);
                      setState(() {
                        seasonNode.unfocus();
                        episodeNode.requestFocus();
                        _isSeasonFocused = false;
                      });
                      _selectedEpisodeIndex = 2;
                      _toggleMenu();
                    } else if(_isTapped){
                      print("select episode ... $_selectedEpisodeIndex");
                      // (_selectedEpisodeIndex == j)
                      Get.to(
                            () => VideoPlayerView(
                            url: widget
                                .options[
                            widget.seasonsList[i]]![_selectedEpisodeIndex]
                                .url!),
                      );
                    }
                  } else {
                    setState(() {
                      // FocusScope.of(context).requestFocus(seasonNode);
                      seasonNode.requestFocus();
                      _isTapped = false;
                      _isSeasonFocused = true;
                      // _selectedSeasonIndex = 0;
                      i = 0;
                      _selectedEpisodeIndex = 0;
                    });
                    // _toggleMenu();
                  }
                }
              },
              child: InkWell(
                focusNode: seasonNode,
                onTap: () {
                  setState(() {
                    _selectedSeasonIndex = i;
                    // (_selectedSeasonIndex == index) ? -1 : index;
                    // _isTapped = !_isTapped;
                  });
                  _toggleMenu();
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: (_selectedSeasonIndex == i)
                            ? ColorManager.selectedNavBarItem
                            : Colors.transparent,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // const SizedBox(width: 15,),
                            Icon(
                              (_selectedSeasonIndex == i && _isTapped)
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_outlined,
                              color: ColorManager.white,
                              size: AppSize.s35,
                              // weight: FontWeight.w100,
                              // opticalSize: 2,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .011,
                            ),
                            Text(
                              "Season ${widget.seasonsList[i]}",
                              // textAlign: TextAlign.left,
                              style: getSemiBoldStyle(
                                color: (_selectedSeasonIndex == i)
                                    ? ColorManager.yellow
                                    : ColorManager.white,
                                fontSize: FontSize.s18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // if (_selectedSeasonIndex == index && _isTapped == true)
                      Visibility(
                        visible: (_selectedSeasonIndex == i && _isTapped == true),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // for (EpisodeModel episode
                              //       in widget.options[widget.seasonsList[i]]!)
                              for (int j = 0;
                              j <
                                  widget.options[widget.seasonsList[i]]!.length;
                              j++)
                                InkWell(
                                  focusNode: episodeNode,
                                  onTap: () => (_selectedEpisodeIndex == j)
                                      ? Get.to(
                                        () => VideoPlayerView(
                                        url: widget
                                            .options[
                                        widget.seasonsList[i]]![j]
                                            .url!),
                                  )
                                      : setState(() {
                                    _selectedEpisodeIndex = j;
                                  }),
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      color: (_selectedEpisodeIndex == j)
                                          ? ColorManager.grey.withOpacity(0.3)
                                          : null,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 1),
                                      padding: EdgeInsets.only(
                                        left:
                                        MediaQuery.of(context).size.width *
                                            .04,
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      // color: ColorManager.red,
                                      child: Text(
                                        "Episode ${_selectedSeasonIndex + 1}.${j + 1}",
                                        style: getRegularStyle(
                                          color: ColorManager.white,
                                          fontSize: FontSize.s16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*ListView.builder(
                controller: _scrollSeasonController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.options.length,
                  itemBuilder: (BuildContext context, int index){
                return
              },),*/
            ),
        ],
      ),
    );
  }
}
