class ResponseEpgChannel {
  List<EpgChannelModel> listChannels;

  ResponseEpgChannel({required this.listChannels});

  factory ResponseEpgChannel.fromJson(List<dynamic> json) {
    return ResponseEpgChannel(
      listChannels: List<EpgChannelModel>.from(
          json.map((x) => EpgChannelModel.fromJson(x))),
    );
  }
}

class EpgChannelModel {
  dynamic current;
  String? startCurrent;
  String? endCurrent;
  String? descCurrent;
  String? next;
  String? startNext;
  String? endNext;
  String? descNext;

  EpgChannelModel({
    required this.current,
    this.startCurrent,
    this.endCurrent,
    this.descCurrent,
    this.next,
    this.startNext,
    this.endNext,
    this.descNext,
  });

  factory EpgChannelModel.fromJson(Map<String, dynamic> json) {
    return EpgChannelModel(
      current: json['current'],
      startCurrent: json['start_current'],
      endCurrent: json['end_current'],
      descCurrent: json['desc_current'],
      next: json['category_id'],
      startNext: json['start_next'],
      endNext: json['end_next'],
      descNext: json['desc_next'],
    );
  }
}
