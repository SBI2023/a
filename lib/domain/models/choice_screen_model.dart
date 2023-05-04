
class BoxModel {
  String boxImage;
  // String title;
  String api;

  BoxModel({
    required this.boxImage,
    // required this.title,
    required this.api,
  });

  Map<String, dynamic> toJson() => {
    'boxImage': boxImage,
    // 'title': title,
    'api': api,
  };

  factory BoxModel.fromJson(Map<String, dynamic> json) {
    return BoxModel(
      boxImage: json['boxImage'],
      // title: json['title'],
      api: json['api'],
    );
  }
}

class ChoiceScreenModel {
  String backgroundImage;
  List<BoxModel> boxs;
  int indexClicked; // New variable

  ChoiceScreenModel({
    required this.backgroundImage,
    required this.boxs,
    this.indexClicked = 0,
  });

  Map<String, dynamic> toJson() => {
    'boxs': boxs.map((slider) => slider.toJson()).toList(),
    'backgroundImage': backgroundImage,
  };

  factory ChoiceScreenModel.fromJson(Map<String, dynamic> json) {
    var sliderList = json['boxs'] as List;
    List<BoxModel> boxs =
    sliderList.map((slider) => BoxModel.fromJson(slider)).toList();

    return ChoiceScreenModel(
      boxs: boxs,
      backgroundImage: json['backgroundImage'],
    );
  }
}
