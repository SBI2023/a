import '../../../domain/models/movies_screen_model.dart';
import '../../../domain/response/category_response.dart';
import '../../../domain/response/serie_response.dart';
import '../../../domain/services/serie_services.dart';
import '../../env/env.dart';

class SeriesScreenRepository {
  Future<RouteScreenModel> fetchSerieScreenData() async {
    // Here you can call the API to fetch data
    // For this example, we will return hardcoded data
    var navBarItems;
    ResponseCategory? responseCategories;
    try {
      responseCategories = await serieService.getCategoriesSeries();
      // print("Ennfiiiiiin 2 responseCategories = ${responseCategories.listCategories.first.name.toString()}");
      navBarItems = responseCategories.listCategories;
    } on Exception catch (e) {
      print(e.toString());
    }

    var listOfChannels;
    ResponseSeriesByCategoryInfo responseSeriesByCategoryInfo;

    try {
      responseSeriesByCategoryInfo =
          await serieService.getSeriesByCategory("4206");
      print(
          "Ennfiiiiiin 3 responseLiveChannels = ${responseSeriesByCategoryInfo.listSeriesInfos.first.name.toString()}");
      listOfChannels = responseSeriesByCategoryInfo.listSeriesInfos;
    } on Exception catch (e) {
      print(e.toString());
    }

    return RouteScreenModel(
      navbarItems: navBarItems,
      // listOfUnderCategories: listOfChannels,
      indexNavbarClicked: 0,
      backgroundImage: "${Environment.assetsPath}bg_series_screen.jpg",
      // repositoryFunction: null,
    );
  }
}
