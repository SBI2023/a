class ResponseSeriesByCategoryInfo {
  List<SerieByCategoryInfosModel> listSeriesInfos;

  ResponseSeriesByCategoryInfo({required this.listSeriesInfos});

  factory ResponseSeriesByCategoryInfo.fromJson(List<dynamic> json) {
    return ResponseSeriesByCategoryInfo(
      listSeriesInfos: List<SerieByCategoryInfosModel>.from(
          json.map((x) => SerieByCategoryInfosModel.fromJson(x))),
    );
  }
}

class SerieByCategoryInfosModel {
  dynamic id;
  String? name;
  String? icon;
  String? plot;
  String? cast;
  String? director;
  String? genre;
  String? date;
  String categoryId;
  double? rate;

  SerieByCategoryInfosModel({
    required this.id,
    required this.name,
    this.icon,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.date,
    this.rate,
    required this.categoryId,
  });

  factory SerieByCategoryInfosModel.fromJson(Map<String, dynamic> json) {
    print("SerieByCategoryInfosModel = $json");
    return SerieByCategoryInfosModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      date: json['date'],
      genre: json['genre'],
      cast: json['cast'],
      plot: json['plot'],
      director: json['director'],
      categoryId: json['category_id'],
      rate: json['rate'],
    );
  }
}



  // Saison
 // **************************

class ResponseSaisonBySerie {
  List<SaisonModel> listSaisons;

  ResponseSaisonBySerie({required this.listSaisons});

  factory ResponseSaisonBySerie.fromJson(List<dynamic> json) {
    return ResponseSaisonBySerie(
      listSaisons: List<SaisonModel>.from(
          json.map((x) => SaisonModel.fromJson(x))),
    );
  }
}

class SaisonModel {
  String saison;

  SaisonModel({
    required this.saison,
  });

  factory SaisonModel.fromJson(Map<String, dynamic> json) {
    return SaisonModel(
      saison: json['saison'],
    );
  }
}


// Episode
// ***********************************************

class ResponseEpisodeBySerieAndSaison {
  List<EpisodeModel> listEpisode;

  ResponseEpisodeBySerieAndSaison({required this.listEpisode});

  factory ResponseEpisodeBySerieAndSaison.fromJson(List<dynamic> json) {
    return ResponseEpisodeBySerieAndSaison(
      listEpisode: List<EpisodeModel>.from(
          json.map((x) => EpisodeModel.fromJson(x))),
    );
  }
}

class EpisodeModel {
  dynamic id;
  String name;
  String? icon;
  String? url;
  String episode;

  EpisodeModel({
    required this.id,
    required this.name,
    this.icon,
    this.url,
    required this.episode,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      url: json['url'],
      episode: json['episode'],
    );
  }
}
