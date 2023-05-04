import 'package:flutter/material.dart';

import '../response/category_response.dart';
import '../response/channel_response.dart';

class ListChannelScreenModel {
  List<ChannelModel>? listOfChannels;
  String? titleScreen;
  // Future<dynamic> repositoryFunction;
  List<String>? backgroundImages;
  int indexClicked; // New variable

  ListChannelScreenModel({
    this.listOfChannels,
    this.titleScreen,
    // required this.repositoryFunction,
    this.backgroundImages,
    this.indexClicked = 0,
  });

  // Map<String, dynamic> toJson() => {
  //   'sliders': navbarItems,
  //   'backgroundImage': backgroundImage,
  // };

  /*factory MoviesScreenModel.fromJson(Map<String, dynamic> json) {
    // var sliderList = json['sliders'] as List;

    return MoviesScreenModel(
      navbarItems: json["name"],
      backgroundImage: json['backgroundImage'],
    );
  }*/
}
