import 'dart:convert';
import '../../data/env/env.dart';
import 'package:http/http.dart' as http;

import '../response/category_response.dart';
import '../response/serie_response.dart';

class SerieServices {
  // static String decryptedData = "";

  Future<ResponseCategory> getCategoriesSeries() async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/serie/getCategoriesSeries.php?code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    print("decryptedData = ${decryptedData.toString()}");

    return ResponseCategory.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseSeriesByCategoryInfo> getSeriesByCategory(dynamic id) async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/serie/getSeriesByCategory.php?id=$id&code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    // print("decryptedData = ${decryptedData.toString()}");

    return ResponseSeriesByCategoryInfo.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseSaisonBySerie> getSaisonsBySerie(String id) async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/serie/getSaisonsBySerie.php?id=$id&code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    print("decryptedData Seasons = ${decryptedData.toString()}");

    return ResponseSaisonBySerie.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseEpisodeBySerieAndSaison> getEpisodesBySerieAndSaison(String id, String season) async {
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/serie/getEpisodesBySerieAndSaison.php?id=$id&saison=$season&code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);
    print("decryptedData - getEpisodesBySerieAndSaison = ${decryptedData.toString()}");
    return ResponseEpisodeBySerieAndSaison.fromJson(jsonDecode(decryptedData));
  }

}

final serieService = SerieServices();
