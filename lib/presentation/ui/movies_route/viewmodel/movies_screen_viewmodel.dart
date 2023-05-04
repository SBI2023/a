import 'package:rxdart/rxdart.dart';

import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/category_response.dart';
import '../../../../domain/services/livechannel_services.dart';
import '../../../../domain/services/movie_services.dart';
import '../../../base/base_viewmodel.dart';


class MoviesScreenViewModel extends BaseViewModel
    with MoviesViewModelInputs, MoviesViewModelOutputs {

  // final MoviesScreenRepository _moviesRouteRepository = MoviesScreenRepository();

  final _selectedItemNavbarController = BehaviorSubject<int>();
  final _selectedSliderController = BehaviorSubject<int>();

  final _listUnderCategoryController = BehaviorSubject<List<dynamic>>();

  final _moviesRouteDataStreamController = BehaviorSubject<RouteScreenModel>();

  late Future<dynamic> _repoFunction;
  String type = "";
  MoviesScreenViewModel(Future<dynamic> repoFunction, String sliderName) {
    _repoFunction = repoFunction;
    type = sliderName;
  }

  @override
  ValueStream<RouteScreenModel> get MoviesRouteDataStream =>
      _moviesRouteDataStreamController.stream;

  late List<CategoryModel> listNavBarItems = [];

  ValueStream<int> get selectedItemNavbarIndex => _selectedItemNavbarController.stream;
  ValueStream<int> get selectedSliderIndex => _selectedSliderController.stream;

  ValueStream<List<dynamic>> get listUnderCategories => _listUnderCategoryController.stream;


  void onItemClickedNavbar(int index, Future<dynamic> getByCategory) async {
    _selectedItemNavbarController.sink.add(index);
    if(type == "Movies") {
      ResponseCategory response = await getByCategory;
      _listUnderCategoryController.sink.add(response.listCategories);
    }else if(type == "Series"){



    }else if (type == "Live TV"){
      ResponseCategory responseCategories = await getByCategory;
      _listUnderCategoryController.sink.add(responseCategories.listCategories);
    }
    // listOfLiveChannels = responseCategories.listChannels;
  }

  @override
  Function() get fetchMoviesRouteData => _fetchMoviesRouteData;

  void _fetchMoviesRouteData() async {
    RouteScreenModel moviesRouteData = await _repoFunction;
    _moviesRouteDataStreamController.sink.add(moviesRouteData);
    listNavBarItems = moviesRouteData.navbarItems!;
    print("moviesRouteData.navbarItems! = ${moviesRouteData.navbarItems!}");
    if(type == "Movies") {
      ResponseCategory response = await movieService.getCategoriesMovies(
          listNavBarItems[0].id);
      _listUnderCategoryController.sink.add(response.listCategories);
    } else if (type == "Live TV"){
      ResponseCategory responseCategories = await liveChannelService
          .getCategoriesChannelsByParentID(
          listNavBarItems[0].id);
      _listUnderCategoryController.sink.add(responseCategories.listCategories);
    } else {
      _listUnderCategoryController.sink.add(moviesRouteData.navbarItems!);
    }
    // listOfLiveChannels = moviesRouteData.listOfChannels!;
  }

  @override
  void start() {
    fetchMoviesRouteData();
  }

  @override
  void dispose() {
    _selectedItemNavbarController.close();
    _moviesRouteDataStreamController.close();
  }

}

abstract class MoviesViewModelInputs {
  late Function() fetchMoviesRouteData;
}

abstract class MoviesViewModelOutputs {
  ValueStream<RouteScreenModel> get MoviesRouteDataStream;
}
