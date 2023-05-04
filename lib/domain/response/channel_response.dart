class ResponseChannel {
  List<ChannelModel> listChannels;

  ResponseChannel({required this.listChannels});

  factory ResponseChannel.fromJson(List<dynamic> json) {
    return ResponseChannel(
      listChannels:
          List<ChannelModel>.from(json.map((x) => ChannelModel.fromJson(x))),
    );
  }
}

class ChannelModel {
  dynamic id;
  String name;
  String icon;
  String url;
  String categoryId;
  bool isFavorite;

  ChannelModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.url,
    required this.categoryId,
    this.isFavorite = false,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    print("getChannels.fromJson traaahhh    = $json");

    return ChannelModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      url: json['url'],
      categoryId: json['category_id'],
      isFavorite: false,
    );
  }

  toJson() {}
}
