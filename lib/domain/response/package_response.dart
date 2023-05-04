import 'dart:convert';

import 'category_response.dart';

class ResponsePackage {
  List<PackageModel> packages;

  ResponsePackage({required this.packages});

  factory ResponsePackage.fromJson(List<dynamic> json) {

    return ResponsePackage(
      packages: List<PackageModel>.from(json.map((x) => PackageModel.fromJson(x))),
    );
  }

}

class PackageModel {
  String name;
  String icon;
  List<CategoryModel> live;
  List<CategoryModel> movies;
  List<CategoryModel> series;

  PackageModel({
    required this.name,
    required this.icon,
    required this.live,
    required this.movies,
    required this.series,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    print("PackageModel.fromJson heeyyy    = $json");
    return PackageModel(
      name: json['name'],
      icon: json['icon'],
      live: List<CategoryModel>.from(
        json['live'].map((live) => CategoryModel.fromJson(live)),
      ),
      movies: List<CategoryModel>.from(
        json['movies'].map((movie) => CategoryModel.fromJson(movie)),
      ),
      series: List<CategoryModel>.from(
        json['series'].map((series) => CategoryModel.fromJson(series)),
      ),
    );
  }
}


