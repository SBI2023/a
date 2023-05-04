import '../../../domain/models/movies_screen_model.dart';
import '../../../domain/response/category_response.dart';
import '../../../domain/response/channel_response.dart';
import '../../env/env.dart';

class MoviesScreenRepository {

  Future<RouteScreenModel> fetchMovieScreenData() async {

    // Here you can call the API to fetch data
    // For this example, we will return hardcoded data

    // ResponseCategory responseCategories = await movieService.getCategoriesMovies();
    // // print("Ennfiiiiiin 2 responseCategories = ${responseCategories.listCategories.first.name.toString()}");
    List<CategoryModel> navBarItems = [];


    // ResponseMoviesInfo responseMoviesInfo = await movieService.getAllMovies();
    // // print("Ennfiiiiiin 3 responseChannels = ${responseChannels.listChannels.first.name.toString()}");
    // var listOfChannels = responseMoviesInfo.listMoviesInfos;


    return RouteScreenModel(
      navbarItems: navBarItems,
      // listOfUnderCategories: listOfChannels,
      indexNavbarClicked: 0,
      backgroundImage: "${Environment.assetsPath}bg_movies_screen.jpg",
      // repositoryFunction: null,
    );
  }

}
