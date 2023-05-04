import 'package:flutter/material.dart';

import '../response/category_response.dart';
import '../response/package_response.dart';

class SliderModel {
  String backgroundImage;
  String sliderImage;
  String title;
  Future<dynamic>? fetchScreenRepo;
  List<CategoryModel> lives;
  List<CategoryModel> movies;
  List<CategoryModel> series;

  SliderModel({
    required this.backgroundImage,
    required this.sliderImage,
    required this.lives,
    required this.movies,
    required this.series,
    required this.title,
    this.fetchScreenRepo,
  });

  Map<String, dynamic> toJson() => {
        'backgroundImage': backgroundImage,
        'sliderImage': sliderImage,
        'title': title,
        'repoFunction': fetchScreenRepo,
      };

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      backgroundImage: json['backgroundImage'],
      sliderImage: json['sliderImage'],
      lives: [],
      movies: [],
      series: [],

      title: json['title'],
      // fetchScreenRepo: json['api'],
    );
  }
}

class HomeModel {
  List<SliderModel> sliders;
  // Widget titleWidget;
  int indexClicked; // New variable

  HomeModel({
    required this.sliders,
    // required this.titleWidget,
    this.indexClicked = 0,
  });

  Map<String, dynamic> toJson() => {
        'sliders': sliders.map((slider) => slider.toJson()).toList(),
        'titleWidget': '',
      };

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var sliderList = json['sliders'] as List;
    List<SliderModel> sliders =
        sliderList.map((slider) => SliderModel.fromJson(slider)).toList();

    return HomeModel(
      sliders: sliders,
      // titleWidget: Container(),
    );
  }
}
