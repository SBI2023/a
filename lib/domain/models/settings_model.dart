import 'package:flutter/material.dart';


class SettingsModel {
  List<String> listMenuItems;
  List<String> listMenuInformations;
  List<String> listOfInformations;
  String? backgroundImage;
  int indexClicked; // New variable

  SettingsModel({
    required this.listMenuItems,
    required this.listMenuInformations,
    required this.listOfInformations,
    this.backgroundImage,
    this.indexClicked = 0,
  });

  Map<String, dynamic> toJson() => {
    'listMenuItems': listMenuItems,
    'listMenuInformations': listMenuInformations,
    'listOfInformations': listOfInformations,

    'backgroundImage': backgroundImage,
  };

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    // var sliderList = json['sliders'] as List;

    return SettingsModel(
      listMenuItems: json["listMenuItems"],
      listMenuInformations: json["listMenuInformations"],
      listOfInformations: json["listOfInformations"],
      backgroundImage: json['backgroundImage'],
    );
  }
}
