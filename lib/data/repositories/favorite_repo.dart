import '../../../domain/models/movies_screen_model.dart';
import '../../../domain/response/channel_response.dart';
import '../../../../data/storage/local_data.dart';
import '../../domain/response/category_response.dart';
import '../../presentation/resources/constants_manager.dart';
import '../env/env.dart';

class FavoriteScreenRepository {
  Future<RouteScreenModel> fetchFavoriteScreenData() async {
    // Here you can call the API to fetch data
    // For this example, we will return hardcoded data
    List<CategoryModel> navBarItems = [
      CategoryModel(id: 0, name: "Live", icon: ""),
      CategoryModel(id: 1, name: "Movies", icon: ""),
      CategoryModel(id: 2, name: "Series", icon: ""),
      CategoryModel(id: 3, name: "Last View", icon: ""),
    ];

    List<ChannelModel> listOfFavoriteChannels = [];
    ResponseChannel responseChannel;
    if (LocalData().checkKey(AppConstants.liveFavorite)) {
      listOfFavoriteChannels = LocalData().getData(AppConstants.liveFavorite);
      // responseChannel = LocalData().getData(AppConstants.liveFavorite);
    }

    //  = await liveServices.getCategoriesMovies();
    // // print("Ennfiiiiiin 2 responseCategories = ${responseCategories.listCategories.first.name.toString()}");
    // var navBarItems = responseCategories.listCategories;

    // ResponseCategory responseUnderCategory = await movieService.getAllMovies();
    // // print("Ennfiiiiiin 3 responseChannels = ${responseChannels.listChannels.first.name.toString()}");
    // var listOfChannels = responseUnderCategory.listUnderCategories;

    return RouteScreenModel(
      navbarItems: navBarItems,
      listOfChannels: listOfFavoriteChannels,
      indexNavbarClicked: 0,
      backgroundImage: "${Environment.assetsPath}bg_movies_screen.jpg",
      // repositoryFunction: null,
    );
  }
}
