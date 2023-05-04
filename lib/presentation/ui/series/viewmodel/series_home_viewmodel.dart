import 'package:rxdart/rxdart.dart';

import '../../../../domain/models/movies_screen_model.dart';
import '../../../../domain/response/category_response.dart';
import '../../../../domain/response/movie_response.dart';
import '../../../../domain/response/serie_response.dart';
import '../../../../domain/services/serie_services.dart';
import '../../../base/base_viewmodel.dart';
import '../../../resources/constants_manager.dart';

class SeriesHomeViewModel extends BaseViewModel
    with SeriesViewModelInputs, SeriesViewModelOutputs {
  // final MoviesScreenRepository _moviesRouteRepository = MoviesScreenRepository();

  final _selectedItemIndexController = BehaviorSubject<int>();
  final _selectedSliderIndexController = BehaviorSubject<int>();
  final _selectedFilterIndexController = BehaviorSubject<int>();
  final _selectedSeasonIndexController = BehaviorSubject<int>();
  final _selectedEpisodeIndexController = BehaviorSubject<int>();

  final _listUnderCategoryController = BehaviorSubject<List<dynamic>>();
  final _mapSeasonsEpisodesController =
      BehaviorSubject<Map<String, List<EpisodeModel>>>();

  final _seriesRouteDataStreamController = BehaviorSubject<RouteScreenModel>();

  List<SerieByCategoryInfosModel> listInitialOfSeries = [];


  late Future<dynamic> _repoFunction;

  SeriesHomeViewModel(Future<dynamic> repoFunction) {
    _repoFunction = repoFunction;
  }

  @override
  ValueStream<RouteScreenModel> get SeriesRouteDataStream =>
      _seriesRouteDataStreamController.stream;

  late List<CategoryModel> listNavBarItems = [];

  ValueStream<int> get selectedItemNavbarIndex =>
      _selectedItemIndexController.stream;

  ValueStream<int> get selectedSliderIndex =>
      _selectedSliderIndexController.stream;

  ValueStream<int> get selectedFilterIndex =>
      _selectedFilterIndexController.stream;

  ValueStream<int> get selectedSeasonIndex =>
      _selectedFilterIndexController.stream;

  ValueStream<int> get selectedEpisodeIndex =>
      _selectedFilterIndexController.stream;

  ValueStream<List<dynamic>> get getListUnderCategories =>
      _listUnderCategoryController.stream;

  ValueStream<Map<String, List<EpisodeModel>>> get getMapSeasonsEpisodes =>
      _mapSeasonsEpisodesController.stream;

  final _menuFilterChosenValueController = BehaviorSubject<List<String>>();

  List<String> listYearsStreamController = [];
  List<String> listGenresStreamController = [];

  ValueStream<List<String>> get getMenuChosenValue =>
      _menuFilterChosenValueController.stream;

  List<String> get getListYears => listYearsStreamController;

  List<String> get getListGenres => listGenresStreamController;


  void onSelectSeason(int index) {
    _selectedSeasonIndexController.sink.add(index);
  }

  void onSelectEpisode(int index) {
    _selectedEpisodeIndexController.sink.add(index);
  }

  void onSliderClicked(int index) async {
    _selectedSliderIndexController.sink.add(index);
  }

  void onFilterClicked(int index) async {
    _selectedFilterIndexController.sink.add(index);
  }

  void fetchDetailsData(SerieByCategoryInfosModel slider) async {
    Map<String, List<EpisodeModel>> seasonEpisodeMap = {};
    _mapSeasonsEpisodesController.sink.add(seasonEpisodeMap);
    seasonEpisodeMap = await getEpisodeAndSeasonsMap(slider);
    _mapSeasonsEpisodesController.sink.add(seasonEpisodeMap);
  }

  Future<Map<String, List<EpisodeModel>>> getEpisodeAndSeasonsMap(
      SerieByCategoryInfosModel slider) async {
    print(
        "_listUnderCategoryController = ${_listUnderCategoryController.value}");
    ResponseSaisonBySerie responseSaisonBySerie =
        await serieService.getSaisonsBySerie(slider.id);

    final listSeasons = responseSaisonBySerie.listSaisons;
    final Map<String, List<EpisodeModel>> seasonEpisodeMap = {};
    for (int i = 0; i < listSeasons.length; i++) {
      print("listSeasons[i} = ${listSeasons[i].saison}");
      final getListEpisodes = await serieService.getEpisodesBySerieAndSaison(
        slider.id,
        listSeasons[i].saison,
      );
      seasonEpisodeMap[listSeasons[i].saison] = getListEpisodes.listEpisode;
    }
    return seasonEpisodeMap;
  }

  void onItemClicked(
      int index, Future<dynamic> getByCategory, String type) async {
    _selectedItemIndexController.sink.add(index);
    if (type == "Movies") {
      ResponseMoviesInfo responseMoviesInfo = await getByCategory;
      _listUnderCategoryController.sink.add(responseMoviesInfo.listMoviesInfos);
    } else if (type == "Series") {
      ResponseSeriesByCategoryInfo responseSeriesByCategoryInfo =
          await getByCategory;
      _listUnderCategoryController.sink
          .add(responseSeriesByCategoryInfo.listSeriesInfos);
      listInitialOfSeries = responseSeriesByCategoryInfo.listSeriesInfos;
    } else if (type == "Live TV") {
      ResponseCategory responseCategories = await getByCategory;
      _listUnderCategoryController.sink.add(responseCategories.listCategories);
    }
    listYearsStreamController.clear();
    listGenresStreamController.clear();
    getFilterData();
    // listOfLiveChannels = responseCategories.listChannels;
  }

  @override
  Function() get fetchSeriesHomeData => _fetchSeriesHomeData;

  void _fetchSeriesHomeData() async {
    RouteScreenModel moviesRouteData = await _repoFunction;
    _seriesRouteDataStreamController.sink.add(moviesRouteData);
    listNavBarItems = moviesRouteData.navbarItems!;

    print("moviesRouteData.navbarItems! = ${moviesRouteData.navbarItems!}");
    _listUnderCategoryController.sink.add(moviesRouteData.navbarItems!);
    // listOfLiveChannels = moviesRouteData.listOfChannels!;
  }

  Function() get getFilterData => _getAllYearsFromMovies;

  void _getAllYearsFromMovies() async {
    _listUnderCategoryController.stream.listen((moviesList) {
      // Extract all years from the movies list
      Set<String> yearsSet = moviesList
          .map((movie) => movie.date.toString().split('-')[0])
          .toSet();
      // Convert the set of years to a list of strings
      List<String> yearsList = ["All"];
      yearsList.addAll(yearsSet.map((year) => year).toList());
      yearsList = yearsList.where((s) => s.isNotEmpty).toList();

      // Sort the list of years in descending order
      yearsList.sort((a, b) => b.compareTo(a));
      print("_yearsList = $yearsList");

      List<String> allGenres = ["All"];
      final List<String> genresSet = getListUnderCategories.value
          .fold<List<String>>([], (previousValue, element) {
        // element.genre?.split(",")
        allGenres.addAll(element.genre?.split(",") as Iterable<String>);
        allGenres =
            allGenres.map((genre) => genre.trimLeft()).toSet().toList();
        allGenres = allGenres.where((s) => s.isNotEmpty).toList();
        return allGenres;
      })
          .toSet()
          .toList();

      print("genresSet = $genresSet");


      listYearsStreamController.addAll(yearsList);
      listGenresStreamController.addAll(genresSet);
    });
  }

  void onApplyFilter(List<String> menu) {
    bool _thereIsFilter = false;
    List<SerieByCategoryInfosModel> filteredMovies = [];
    String selectedYear = "", selectedGenre = "", selectedOrderAlphabet = "";
    for (int i = 0; i < AppConstants.menusFilterValue.length; i++) {
      if (menu[i] != AppConstants.menusFilterValue[i]) {
        _thereIsFilter = true;
        // List<MovieInfosModel> filteredMovies = [];
        if (i == 0) {
          selectedYear = menu[i];
          // filteredMovies =
          //     listInitialOfMovies.where((serie) => serie.date.toString().split('-')[0].trimLeft() == menu[i]).toList();
        } else if (i == 1) {
          selectedGenre = menu[i];
          // filteredMovies =
          //     listInitialOfMovies.where((serie) => serie.genre?.contains(menu[i])??false ).toList();
        } else if (i == 3) {
          selectedOrderAlphabet = menu[i];
        }

        // _listMoviesStreamController.add(filteredMovies);
        // print("filteredMovies = $filteredMovies");
      }
    }
    for (var serie in listInitialOfSeries) {
      // Check if the serie's year matches the selected year
      if (selectedYear.isNotEmpty &&
          selectedYear != serie.date.toString().split('-')[0].trimLeft()) {
        continue;
      }

      // Check if the serie's genres contain the selected genre
      if (selectedGenre.isNotEmpty &&
          serie.genre?.contains(selectedGenre) == true) {
        continue;
      }

      // If the serie matches both filters, add it to the filteredMovies list
      filteredMovies.add(serie);
    }

    if(selectedOrderAlphabet.isNotEmpty){
      if (selectedOrderAlphabet == AppConstants.menusOrderValue[1]){
        filteredMovies.sort((a,b) => b.name!.compareTo(a.name!));
      } else {
        filteredMovies.sort((a,b) => a.name!.compareTo(b.name!));
      }
    }

    _listUnderCategoryController.add(filteredMovies);
    print("filteredMovies from view model function = $filteredMovies");

    if (!_thereIsFilter) {
      _listUnderCategoryController.sink.add(listInitialOfSeries);
    }
    // if(men)
    // _menuFilterChosenValueController.sink.add(newMenu);
  }

  @override
  void start() {
    fetchSeriesHomeData();
    getFilterData();
  }

  @override
  void dispose() {
    _selectedItemIndexController.close();
    _selectedSliderIndexController.close();
    _selectedFilterIndexController.close();
    _seriesRouteDataStreamController.close();
  }
}

abstract class SeriesViewModelInputs {
  late Function() fetchSeriesHomeData;
}

abstract class SeriesViewModelOutputs {
  ValueStream<RouteScreenModel> get SeriesRouteDataStream;
}
