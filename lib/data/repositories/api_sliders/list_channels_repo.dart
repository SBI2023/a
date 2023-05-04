import '../../../domain/models/list_channel_screen_model.dart';
import '../../../domain/models/movies_screen_model.dart';
import '../../../domain/response/channel_response.dart';
import '../../../domain/services/livechannel_services.dart';
import '../../env/env.dart';

class ListChannelScreenRepository {
  List<String> listOfBackgrounds = [
    // "alphasport_replay_bg.jpg",
    "assets/images/background_choice_screen.jpg",
    "assets/images/diwansport_bg.jpg",
    "assets/images/livetv_bg.jfif",
    "assets/images/alphasport_bg.jpg",
    "assets/images/movies_bg.webp",
  ];

  Future<ListChannelScreenModel> fetchListChannelScreenData(String id) async {
    // Here you can call the API to fetch data
    // For this example, we will return hardcoded data

    ResponseChannel responseChannels =
        await liveChannelService.getLiveChannelsByCategory(id);
    print(
        "Ennfiiiiiin 2 responseCategories = ${responseChannels.listChannels.first.name.toString()}");
    var menuOfChannels = responseChannels.listChannels;

    return ListChannelScreenModel(
      // titleScreen: navBarItems,
      listOfChannels: menuOfChannels,
      indexClicked: -1,
      backgroundImages: listOfBackgrounds,
      // repositoryFunction: null,
    );
  }
}
