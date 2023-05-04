import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/models/home_model.dart';
import '../../domain/response/channel_response.dart';
import '../../domain/response/package_response.dart';
import '../../domain/services/movie_services.dart';
import '../../domain/services/package_services.dart';
import '../env/env.dart';
import 'api_sliders/livetv_route_repo.dart';
import 'api_sliders/movies_route_repo.dart';
import 'api_sliders/series_route_repo.dart';

class HomeRepository {
  Future<HomeModel> fetchHomeData() async {
    // Here you can call the API to fetch data
    // For this example, we will return hardcoded data

    ResponsePackage responsePackage = await packageService.getPackages();

    print("Ennfiiiiiin = ${responsePackage.packages.first.live.toString()}");

    // ResponseChannel responseChannel = await movieService.getAllLiveMovies();

    // print("Ennfiiiiiin 2 = ${responseChannel.listChannels.first.name.toString()}");

    List<String> listBackgroundSliders = [
      "${Environment.assetsPath}islamic_bg.jpg",

      "${Environment.assetsPath}series_bg.webp",

      "${Environment.assetsPath}islamic_bg.jpg",
      "${Environment.assetsPath}islamic_bg.jpg",

      // "${Environment.assetsPath}diwansport_bg.jpg",
      "${Environment.assetsPath}livetv_bg.jfif",
      "${Environment.assetsPath}alphasport_bg.jpg",
      "${Environment.assetsPath}movies_bg.webp",
      "${Environment.assetsPath}kids_bg.jpg",
      "${Environment.assetsPath}documentary_bg.jpg",
      "${Environment.assetsPath}alphasport_replay_bg.jpg",

      "${Environment.assetsPath}anime_bg.webp",
      "${Environment.assetsPath}islamic_bg.jpg",
      "${Environment.assetsPath}music_bg.jpg",
      "${Environment.assetsPath}radio_bg.jpg",
    ];
    List<SliderModel> sliders = [];
    var repoFunction;

    for (int i = 0; i < responsePackage.packages.length; i++) {
      switch (responsePackage.packages[i].name) {
        case 'Live TV':
          repoFunction = LiveTvScreenRepository().fetchLiveTvScreenData();
          break;
        case 'Movies':
          repoFunction = MoviesScreenRepository().fetchMovieScreenData();
          break;
        case 'Series':
          repoFunction = SeriesScreenRepository().fetchSerieScreenData();
          break;
        default:
          print('Unknown Function.');
      }
      String icon = responsePackage.packages[i].icon.split(',')[0];
      String bgIcon = responsePackage.packages[i].icon.split(',')[1];
      sliders.add(SliderModel(
        backgroundImage: bgIcon,
        // backgroundImage: listBackgroundSliders[i],
        // sliderImage: "https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/324339561_739517734049065_4323188824913695293_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=174925&_nc_ohc=l27Y-ZJ6RXwAX9xkxIM&tn=gBBITPahf-SLMFkR&_nc_ht=scontent.ftun15-1.fna&oh=00_AfBo8yHUpn_K-SCY2MZ1mi6nB5b5f9rJYVRHrdwsSt0DrA&oe=63FD2F39",
        // sliderImage: "${Environment.assetsPath}diwansport_slider.jpg",

        sliderImage: icon,
        lives: responsePackage.packages[i].live,
        movies: responsePackage.packages[i].movies,
        series: responsePackage.packages[i].series,

        title: responsePackage.packages[i].name,
        fetchScreenRepo: repoFunction,
      ));
    }

    /*var sliders = [
      SliderModel(
        // backgroundImage: "https://www.ftf.org.tn/fr/wp-content/uploads/2022/04/Consultations-FTF-11-720x340.jpg",
        backgroundImage: "${Environment.assetsPath}diwansport_bg.jpg",
        // sliderImage: "https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/324339561_739517734049065_4323188824913695293_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=174925&_nc_ohc=l27Y-ZJ6RXwAX9xkxIM&tn=gBBITPahf-SLMFkR&_nc_ht=scontent.ftun15-1.fna&oh=00_AfBo8yHUpn_K-SCY2MZ1mi6nB5b5f9rJYVRHrdwsSt0DrA&oe=63FD2F39",
        // sliderImage: "${Environment.assetsPath}diwansport_slider.jpg",

        sliderImage: responsePackage.packages[0].icon,
        lives: responsePackage.packages[0].live,
        movies: responsePackage.packages[0].movies,
        series: responsePackage.packages[0].series,

        title: 'Diwan Sport',
        // repoFunction: 'https://example.com/api/slider1',
      ),
      SliderModel(
        // backgroundImage: 'https://www.completesports.com/wp-content/uploads/2021/08/premier-league-return_5000805.jpg',
        // sliderImage: 'https://cdn.dribbble.com/users/27903/screenshots/4876574/media/f355faa47b4f4582856dbd8e2be17632.png?compress=1&resize=400x300',
        backgroundImage: "${Environment.assetsPath}alphasport_replay_bg.jpg",
        sliderImage: "${Environment.assetsPath}alphasport_replay_slider.webp",

        lives: responsePackage.packages[0].live,
        movies: responsePackage.packages[0].movies,
        series: responsePackage.packages[0].series,

        title: 'Alpha Sport Replay',
        // repoFunction: 'https://example.com/api/slider3',
      ),
      SliderModel(
        // backgroundImage: 'https://qph.cf2.quoracdn.net/main-qimg-f2d74b27aee3800ea313f330eb729a1a-lq',
        // sliderImage: 'https://play-lh.googleusercontent.com/DvAlertcQRgXUl6D8ePkCzzKmYyqF4KBchOy-BLUE1juCqIq5H9tQLoQ5twB72KpTw=w2560-h1440-rw',
        backgroundImage: "${Environment.assetsPath}livetv_bg.jfif",
        sliderImage: "${Environment.assetsPath}livetv_slider.webp",

        lives: responsePackage.packages[0].live,
        movies: responsePackage.packages[0].movies,
        series: responsePackage.packages[0].series,

        title: responsePackage.packages[0].name, // live TV
        fetchScreenRepo: LiveTvScreenRepository().fetchLiveTvScreenData(),
      ),
      SliderModel(
        backgroundImage: "${Environment.assetsPath}alphasport_bg.jpg",
        sliderImage: "${Environment.assetsPath}alphasport_slider.webp",

        lives: responsePackage.packages[2].live,
        movies: responsePackage.packages[2].movies,
        series: responsePackage.packages[2].series,

        title: responsePackage.packages[2].name, // alpha sport
        // repoFunction: 'https://example.com/api/slider3',
      ),
      SliderModel(
        // backgroundImage: 'https://www.cnet.com/a/img/resize/bc48bbd2f4dbb7f5799eb4bc28bdcf6f19f6f408/hub/2022/05/10/708507de-bb07-4c16-9a94-bbf206a59fd5/avatar.jpg?auto=webp&fit=crop&height=675&width=1200',
        // sliderImage: 'https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/306001931_546296760832732_5673322044449745014_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=5F5U0YxM5moAX_xfkOb&_nc_ht=scontent.ftun15-1.fna&oh=00_AfDMCcur305l6IcF7QUQp_lzBbbH6TG4Xw7F8oAVr2wuUQ&oe=63FE5010',
        backgroundImage: "${Environment.assetsPath}movies_bg.webp",
        sliderImage: "${Environment.assetsPath}movies_slider.jpg",

        lives: responsePackage.packages[3].live,
        movies: responsePackage.packages[3].movies,
        series: responsePackage.packages[3].series,

        title: responsePackage.packages[3].name, // movies
        fetchScreenRepo: MoviesScreenRepository().fetchMovieScreenData(),
      ),
      SliderModel(
        // backgroundImage: 'https://vmndims.binge.com.au/api/v2/img/5e6eead9e4b09c405c046be1-1656041774307?location=hero&imwidth=2560',
        // not equivalent
        // sliderImage: 'https://scontent.ftun15-1.fna.fbcdn.net/v/t39.30808-6/302188539_471029368367444_5963913160392460484_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=e3f864&_nc_ohc=3RRrQB6KXwIAX-E3Dcx&tn=gBBITPahf-SLMFkR&_nc_ht=scontent.ftun15-1.fna&oh=00_AfBaqcLGLd2DM-wl7qmqP5eSk2SHcQHSvMO6sjUqTCJOxg&oe=63FD3F9C',
        backgroundImage: "${Environment.assetsPath}series_bg.webp",
        sliderImage: "${Environment.assetsPath}series_slider.jpg",

        lives: responsePackage.packages[4].live,
        movies: responsePackage.packages[4].movies,
        series: responsePackage.packages[4].series,

        title: responsePackage.packages[4].name, // series
        fetchScreenRepo: SeriesScreenRepository().fetchSerieScreenData(),
      ),
      SliderModel(
        backgroundImage: "${Environment.assetsPath}documentary_bg.jpg",
        sliderImage: "${Environment.assetsPath}documentary_slider.jpg",

        lives: responsePackage.packages[5].live,
        movies: responsePackage.packages[5].movies,
        series: responsePackage.packages[5].series,

        title: responsePackage.packages[5].name, // documentary
        // repoFunction: 'https://example.com/api/slider3',
      ),
      SliderModel(
        // backgroundImage: 'https://png.pngtree.com/background/20210710/original/pngtree-cartoon-school-kids-going-to-school-background-picture-image_1040109.jpg',
        // sliderImage: 'https://i.pinimg.com/750x/76/e3/27/76e327f1ed4d00509f281be7ab72416d.jpg',
        backgroundImage: "${Environment.assetsPath}kids_bg.jpg",
        sliderImage: "${Environment.assetsPath}kids_slider.jpg",

        lives: responsePackage.packages[6].live,
        movies: responsePackage.packages[6].movies,
        series: responsePackage.packages[6].series,

        title: responsePackage.packages[6].name, // kids
        // repoFunction: 'https://example.com/api/slider3',
      ),
      SliderModel(
        // backgroundImage: 'https://p.potaufeu.asahi.com/84f7-p/picture/20759616/cee705972b1bd3bebf81af9c446225b5.jpg',
        // sliderImage: 'https://i.pinimg.com/564x/2f/f5/e4/2ff5e48a2f692402e00abcfa7e2bdf6a.jpg',
        backgroundImage: "${Environment.assetsPath}anime_bg.webp",
        sliderImage: "${Environment.assetsPath}anime_slider.jpg",

        lives: responsePackage.packages[7].live,
        movies: responsePackage.packages[7].movies,
        series: responsePackage.packages[7].series,

        title: responsePackage.packages[7].name, // anime
        // repoFunction: 'https://example.com/api/slider3',
      ),
      SliderModel(
        // backgroundImage: 'https://i.pinimg.com/564x/53/96/2e/53962e6e7d543226a84102f1ea1ba016.jpg',
        // sliderImage: 'https://i.pinimg.com/564x/ce/5a/25/ce5a25bc0b6d4584826b0259da9d92d9.jpg',
        backgroundImage: "${Environment.assetsPath}islamic_bg.jpg",
        sliderImage: "${Environment.assetsPath}islamic_slider.jpg",

        lives: responsePackage.packages[8].live,
        movies: responsePackage.packages[8].movies,
        series: responsePackage.packages[8].series,

        title: responsePackage.packages[8].name, // islamic
        // repoFunction: 'https://example.com/api/slider3',
      ),
      SliderModel(
        // backgroundImage: 'https://i.pinimg.com/564x/10/86/af/1086afa660b2959984f738a5386b3f8f.jpg',
        // sliderImage: 'https://i.pinimg.com/564x/2f/48/6b/2f486b3ad22744c7e6b8aaca45ef97c2.jpg',
        backgroundImage: "${Environment.assetsPath}music_bg.jpg",
        sliderImage: "${Environment.assetsPath}music_slider.jpg",

        lives: responsePackage.packages[9].live,
        movies: responsePackage.packages[9].movies,
        series: responsePackage.packages[9].series,

        title: responsePackage.packages[9].name, // music
        // repoFunction: 'https://example.com/api/slider3',
      ),
      SliderModel(
        // backgroundImage: 'https://i.pinimg.com/564x/87/ed/86/87ed8661d3b3e5998a28ef367eb840ec.jpg',
        // sliderImage: 'https://i.pinimg.com/564x/58/14/c8/5814c8865d70f908ef63aead6ccb0a34.jpg',
        backgroundImage: "${Environment.assetsPath}radio_bg.jpg",
        sliderImage: "${Environment.assetsPath}radio_slider.jpg",

        lives: responsePackage.packages[10].live,
        movies: responsePackage.packages[10].movies,
        series: responsePackage.packages[10].series,

        title: responsePackage.packages[10].name,  // radio
        // repoFunction: 'https://example.com/api/slider3',
      ),

    ];*/

    return HomeModel(
      sliders: sliders,
      /*titleWidget: Container(
        height: 50,
        color: Colors.blue,
        child: const Center(
          child: Text(
            'Home Page',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),*/
    );
  }
}
