// ignore_for_file: non_constant_identifier_names
import 'package:rxdart/rxdart.dart';

import '../../../../data/repositories/api_sliders/list_channels_repo.dart';
import '../../../../domain/models/list_channel_screen_model.dart';
import '../../../../domain/response/channel_response.dart';
import '../../../base/base_viewmodel.dart';

class ListChannelViewModel extends BaseViewModel
    with ListChannelsViewModelInputs, ListChannelsViewModelOutputs {
  // final MoviesScreenRepository _moviesRouteRepository = MoviesScreenRepository();

  final _selectedItemIndexController = BehaviorSubject<int>();

  final _backButtonCountController = BehaviorSubject<int>();

  final _listMenuChannelsController = BehaviorSubject<List<ChannelModel>>();

  final _MapChannelAndCategoriesController =
      BehaviorSubject<Map<int, dynamic>>();

  final _ListChannelsDataStreamController =
      BehaviorSubject<ListChannelScreenModel>();

  late String _idSlider;

  ListChannelViewModel(String idSlider) {
    _idSlider = idSlider;
    // _backButtonCount = backButtonCount;
  }

  @override
  ValueStream<ListChannelScreenModel> get listChannelsDataStream =>
      _ListChannelsDataStreamController.stream;

  late List<ChannelModel> listChannelsItems;

  ValueStream<int> get selectedChannelIndex =>
      _selectedItemIndexController.stream;

  ValueStream<int> get backButtonCount => _backButtonCountController.stream;

  ValueStream<Map<int, dynamic>> get mapMenusData =>
      _MapChannelAndCategoriesController.stream;

  void addToMapMenus(Map<int, dynamic> map) {
    _MapChannelAndCategoriesController.sink.add(map);
  }

  void onItemClicked(int index) {
    _selectedItemIndexController.sink.add(index);
    /*if(index == _selectedItemIndexController.value){
      _showMenuController.sink.add(false);
    }*/
  }

  ValueStream<List<ChannelModel>> get listChannels =>
      _listMenuChannelsController.stream;

  void onChangeList(List<ChannelModel> list) {
    _listMenuChannelsController.sink.add(list);
  }

  void onBackButtonClicked(int backButtonCount) {
    _backButtonCountController.sink.add(backButtonCount++);
  }

  // @override
  // void onVideoTap(bool isShow) {
  //   _showMenuController.sink.add(isShow);
  // }

  @override
  Function() get fetchMenuChannelsData => _fetchMoviesRouteData;

  void _fetchMoviesRouteData() async {
    final menuChannelScreenData = await ListChannelScreenRepository()
        .fetchListChannelScreenData(_idSlider);
    _ListChannelsDataStreamController.sink.add(menuChannelScreenData);
    listChannelsItems = menuChannelScreenData.listOfChannels!;
    _listMenuChannelsController.sink.add(listChannelsItems);
    // listOfLiveChannels = menuChannelScreenData.listOfChannels!;
  }

  @override
  void start() {
    // _backButtonCount = 0;
    fetchMenuChannelsData();
  }

  @override
  void dispose() {
    _selectedItemIndexController.close();
    _ListChannelsDataStreamController.close();
  }
}

abstract class ListChannelsViewModelInputs {
  // void onVideoTap(bool isShow);

  late Function() fetchMenuChannelsData;
}

abstract class ListChannelsViewModelOutputs {
  ValueStream<ListChannelScreenModel> get listChannelsDataStream;
}
