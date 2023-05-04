class VideoModel {
  String videoUrl;
  Duration? skipDuration;
  bool isLive;

  VideoModel({
    required this.videoUrl,
    this.skipDuration,
    this.isLive = false,
  });

}
