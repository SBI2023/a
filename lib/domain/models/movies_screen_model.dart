import 'package:flutter/material.dart';

import '../response/category_response.dart';
import '../response/channel_response.dart';


class RouteScreenModel {
  List<CategoryModel>? navbarItems;
  String? categoryChoosen;
  List<dynamic>? listOfUnderCategories;
  List<ChannelModel>? listOfChannels;
  // Future<dynamic> repositoryFunction;
  String? backgroundImage;
  int indexNavbarClicked; // New variable
  int indexSliderClicked; // New variable

  RouteScreenModel({
    this.navbarItems,
    this.listOfUnderCategories,
    this.categoryChoosen = "",
    // required this.repositoryFunction,
    this.backgroundImage,
    this.indexNavbarClicked = 0,
    this.indexSliderClicked = 0,
    this.listOfChannels,
  });

  Map<String, dynamic> toJson() => {
    'sliders': navbarItems,
    'backgroundImage': backgroundImage,
  };

  /*factory MoviesScreenModel.fromJson(Map<String, dynamic> json) {
    // var sliderList = json['sliders'] as List;

    return MoviesScreenModel(
      navbarItems: json["name"],
      backgroundImage: json['backgroundImage'],
    );
  }*/
}
