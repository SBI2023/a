import 'dart:convert';
import '../../data/env/env.dart';
import 'package:http/http.dart' as http;
import '../response/category_response.dart';
import '../response/movie_response.dart';


class MovieServices {
  // static String decryptedData = "";

  Future<ResponseCategory> getCategoriesMovies(dynamic id) async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/movie/getCategoriesMovies.php?code=${Environment.code}&id=$id'),
        headers: {
          'Accept': 'application/json',
        });

    print("response body = ${response.body.toString()}");

    String decryptedData = Environment.encryptDecrypt(response.body);
    print("response body movies Categories decrypted = ${decryptedData.toString()}");

    // print("decryptedData = ${decryptedData.toString()}");

    return ResponseCategory.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseMoviesInfo> getAllMovies() async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/movie/getMovies.php?code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    print("movies data response body from movie services = ${response.body.toString()}");


    String decryptedData = Environment.encryptDecrypt(response.body);

    print("movies data decrypted from movie services = ${decryptedData.toString()}");

    return ResponseMoviesInfo.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseMoviesInfo> getMoviesByCategory(dynamic id) async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/movie/getMoviesByCategory.php?code=${Environment.code}&id=$id'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    print("decryptedData getMoviesByCategory = ${decryptedData.toString()}");

    return ResponseMoviesInfo.fromJson(jsonDecode(decryptedData));
  }

}

final movieService = MovieServices();
