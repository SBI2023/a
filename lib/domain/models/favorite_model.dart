class FavoriteChannelModel {
  final String channelName;
  final String channelLogo;
  final String channelStreamUrl;

  FavoriteChannelModel({
    required this.channelName,
    required this.channelLogo,
    required this.channelStreamUrl,
  });
  Map<String, dynamic> toJson() => {
        'channelName': channelName,
        'channelLogo': channelLogo,
        'channelStreamUrl': channelStreamUrl,
      };
}
