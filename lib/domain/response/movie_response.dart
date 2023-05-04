class ResponseMoviesInfo {
  List<MovieInfosModel> listMoviesInfos;

  ResponseMoviesInfo({required this.listMoviesInfos});

  factory ResponseMoviesInfo.fromJson(List<dynamic> json) {
    return ResponseMoviesInfo(
      listMoviesInfos: List<MovieInfosModel>.from(
          json.map((x) => MovieInfosModel.fromJson(x))),
    );
  }
}

class MovieInfosModel {
  dynamic id;
  String? age;
  String? rate;
  String name;
  String? icon;
  String? url;
  String? date;
  String? genre;
  String? cast;
  String? plot;
  String? director;
  String categoryId;

  MovieInfosModel({
    required this.id,
    this.age,
    this.rate,
    required this.name,
    this.icon,
    this.url,
    this.date,
    this.genre,
    this.cast,
    this.plot,
    this.director,
    required this.categoryId,
  });

  factory MovieInfosModel.fromJson(Map<String, dynamic> json) {
    return MovieInfosModel(
      id: json['id'],
      age: json['age'],
      rate: json['rate'],
      name: json['name'],
      icon: json['icon'],
      url: json['url'],
      date: json['date'],
      genre: json['genre'],
      cast: json['cast'],
      plot: json['plot'],
      director: json['director'],
      categoryId: json['category_id'],
    );
  }
}
