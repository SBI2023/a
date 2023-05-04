// ignore_for_file: non_constant_identifier_names

import 'package:rxdart/rxdart.dart';

import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/category_response.dart';
import '../../../../domain/response/channel_response.dart';
import '../../../base/base_viewmodel.dart';

class FavoriteScreenViewModel extends BaseViewModel
    with FavoriteViewModelInputs, FavoriteViewModelOutputs {
  // final MoviesScreenRepository _moviesRouteRepository = MoviesScreenRepository();

  final _selectedItemIndexController = BehaviorSubject<int>();

  final _listFavoriteChannelsController =
      BehaviorSubject<List<ChannelModel>>();

  final _listNavBarItemsController =
  BehaviorSubject<List<CategoryModel>>();

  final _favoriteRouteDataStreamController =
      BehaviorSubject<RouteScreenModel>();

  late Future<dynamic> _repoFunction;

  FavoriteScreenViewModel(Future<dynamic> repoFunction) {
    _repoFunction = repoFunction;
  }

  @override
  ValueStream<RouteScreenModel> get FavoriteRouteDataStream =>
      _favoriteRouteDataStreamController.stream;

  late List<CategoryModel> listNavBarItems;

  ValueStream<int> get selectedSliderIndex =>
      _selectedItemIndexController.stream;

  ValueStream<List<ChannelModel>> get getlistFavoriteChannels =>
      _listFavoriteChannelsController.stream;

  ValueStream<List<CategoryModel>> get getListNavBarItems =>
      _listNavBarItemsController.stream;

  // void onItemClicked(int index, Future<ResponseCategory> getByCategory) async {
  //   _selectedItemIndexController.sink.add(index);
  //   ResponseCategory responseCategories = await getByCategory;
  //   _listFavoriteChannelsController.sink.add(responseCategories.listCategories);
  //
  //   // listOfLiveChannels = responseCategories.listChannels;
  // }

  @override
  Function() get fetchFavoriteRouteData => _fetchMoviesRouteData;

  void _fetchMoviesRouteData() async {
    final favoriteRouteData = await _repoFunction;
    _favoriteRouteDataStreamController.sink.add(favoriteRouteData);
    _listNavBarItemsController.sink.add(favoriteRouteData.navbarItems!);
    _listFavoriteChannelsController.sink.add(favoriteRouteData.listChannels!);
    // listOfLiveChannels = favoriteRouteData.listOfChannels!;
  }

  @override
  void start() {
    fetchFavoriteRouteData();
  }

  @override
  void dispose() {
    _selectedItemIndexController.close();
    _favoriteRouteDataStreamController.close();
    _listNavBarItemsController.close();
  }
}

abstract class FavoriteViewModelInputs {
  late Function() fetchFavoriteRouteData;
}

abstract class FavoriteViewModelOutputs {
  ValueStream<RouteScreenModel> get FavoriteRouteDataStream;
}
