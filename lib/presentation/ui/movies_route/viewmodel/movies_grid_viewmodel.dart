// ignore_for_file: non_constant_identifier_names

import 'package:rxdart/rxdart.dart';

import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/movie_response.dart';
import '../../../base/base_viewmodel.dart';


class MoviesGridViewModel extends BaseViewModel
    with SeriesViewModelInputs, SeriesViewModelOutputs {

  // final MoviesScreenRepository _moviesRouteRepository = MoviesScreenRepository();

  final _selectedSliderIndexController = BehaviorSubject<int>();
  final _selectedFilterIndexController = BehaviorSubject<int>();

  final _moviesGridViewController = BehaviorSubject<RouteScreenModel>();
  // final _listOfSeasonsController = BehaviorSubject<List<SaisonModel>>();

  final _ListMoviesStreamController = BehaviorSubject<List<MovieInfosModel>>();

  late Future<dynamic> _repoFunction;

  MoviesGridViewModel(Future<dynamic> repoFunction) {
    _repoFunction = repoFunction;
  }

  @override
  ValueStream<RouteScreenModel> get MoviesGridViewDataStream =>
      _moviesGridViewController.stream;

  ValueStream<int> get selectedSliderIndex => _selectedSliderIndexController.stream;

  ValueStream<List<MovieInfosModel>> get getListMovies => _ListMoviesStreamController.stream;

  ValueStream<int> get selectedFilterIndex =>
      _selectedFilterIndexController.stream;

  void onSliderClicked(int index) async{
    _selectedSliderIndexController.sink.add(index);
    // ResponseMoviesInfo responseMoviesInfo = await mo.getSaisonsBySerie(_moviesGridViewController.value[index].categoryId);
    // print("seson by serie = ${responseSaisonBySerie.listSaisons}");
  }

  void onFilterClicked(int index) async {
    _selectedFilterIndexController.sink.add(index);
  }

  @override
  Function() get fetchMoviesGridViewData => _fetchMoviesGridViewData;

  void _fetchMoviesGridViewData() async {
    ResponseMoviesInfo responseMoviesInfo = await _repoFunction;
    _ListMoviesStreamController.sink.add(responseMoviesInfo.listMoviesInfos);
    RouteScreenModel moviesRouteData = RouteScreenModel(listOfUnderCategories: responseMoviesInfo.listMoviesInfos);
    // print("moviesRouteData.navbarItems! = ${moviesRouteData.navbarItems!}");
    _moviesGridViewController.sink.add(moviesRouteData);
  }

  @override
  void start() {
    fetchMoviesGridViewData();
  }

  @override
  void dispose() {
   _selectedSliderIndexController.close();
    _ListMoviesStreamController.close();
  }

}

abstract class SeriesViewModelInputs {
  late Function() fetchMoviesGridViewData;
}

abstract class SeriesViewModelOutputs {
  ValueStream<RouteScreenModel> get MoviesGridViewDataStream;
}
