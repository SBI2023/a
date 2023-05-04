import '../../../domain/models/movies_screen_model.dart';
import '../../../domain/response/category_response.dart';
import '../../../domain/response/channel_response.dart';
import '../../../domain/services/livechannel_services.dart';
import '../../env/env.dart';

class LiveTvScreenRepository {
  Future<RouteScreenModel> fetchLiveTvScreenData() async {
    // Here you can call the API to fetch data
    // For this example, we will return hardcoded data

    ResponseCategory responseCategories =
        await liveChannelService.getParentCategoriesChannels();
    print(
        "Ennfiiiiiin 2 responseCategories = ${responseCategories.listCategories.first.name.toString()}");
    var navBarItems = responseCategories.listCategories;

    ResponseCategory responseUnderCategories = await liveChannelService
        .getCategoriesChannelsByParentID(navBarItems.first.id);
    print(
        "Ennfiiiiiin 3 responseUnderCategories = ${responseUnderCategories.listCategories.first.name.toString()}");
    var listOfUnderCategories = responseUnderCategories.listCategories;

    return RouteScreenModel(
      navbarItems: navBarItems,
      listOfUnderCategories: listOfUnderCategories,
      indexNavbarClicked: 0,
      backgroundImage: "${Environment.assetsPath}bg_movies_screen.jpg",
      // repositoryFunction: null,
    );
  }
}
