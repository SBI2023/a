import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/base_viewmodel.dart';
import '../../../../data/repositories/home_repo.dart';
import '../../../../domain/models/home_model.dart';
import '../view/custom_popup.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  final HomeRepository _homeRepository = HomeRepository();

  final _homeDataStreamController = BehaviorSubject<HomeModel>();
  final _bgImageDataStreamController = BehaviorSubject<String>();
  late List<SliderModel> listSliders;

  @override
  ValueStream<HomeModel> get homeDataStream => _homeDataStreamController.stream;

  ValueStream<String> get bgImageDataStream =>
      _bgImageDataStreamController.stream;

  final _selectedSliderIndexController = BehaviorSubject<int>();

  Stream<int> get selectedSliderIndex => _selectedSliderIndexController.stream;

  void onSliderClicked(int index) {
    _selectedSliderIndexController.sink.add(index);
  }

  void backgroundChange(String bgImage) {
    final newBgImage = bgImage;
    _bgImageDataStreamController.sink.add(newBgImage);
  }

  Future<bool> onWillPop(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DisplayDialog(preContext: context,);
      },
    );

    return false;
  }

  @override
  Function() get fetchHomeData => _fetchHomeData;

  void _fetchHomeData() async {
    final homeData = await _homeRepository.fetchHomeData();
    _homeDataStreamController.sink.add(homeData);
    listSliders = homeData.sliders;
  }

  @override
  void dispose() {
    _homeDataStreamController.close();
  }

  @override
  void start() {
    _fetchHomeData();
    _homeDataStreamController.stream
        .map((homeModel) => print("homeDataStreamController = $homeModel"));
  }
}

abstract class HomeViewModelInputs {
  late Function() fetchHomeData;
}

abstract class HomeViewModelOutputs {
  ValueStream<HomeModel> get homeDataStream;
}
