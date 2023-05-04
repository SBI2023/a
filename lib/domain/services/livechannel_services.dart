import 'dart:convert';
import '../../data/env/env.dart';
import 'package:http/http.dart' as http;

import '../response/category_response.dart';
import '../response/channel_response.dart';

class LiveChannelServices {
  // static String decryptedData = "";

  Future<ResponseCategory> getCategoriesChannel() async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/live/getCategoriesChannels.php?code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    print("getCategoriesChannels = ${decryptedData.toString()}");

    return ResponseCategory.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseChannel> getAllLiveChannels() async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/live/getLiveChannels.php?code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    // print("decryptedData = ${decryptedData.toString()}");

    return ResponseChannel.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseChannel> getLiveChannelsByCategory(String id) async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/live/getLiveChannelsByParentCategory.php?code=${Environment.code}&id=$id'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    print("getLiveChannelsByParentCategory = ${decryptedData.toString()}");

    return ResponseChannel.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseCategory> getParentCategoriesChannels() async {
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/live/getParentCategoriesChannels.php?code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);
    print("getParentCategoriesChannels = ${decryptedData.toString()}");
    return ResponseCategory.fromJson(jsonDecode(decryptedData));
  }

  Future<ResponseCategory> getCategoriesChannelsByParentID(dynamic id) async {
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/live/getCategoriesChannelsByParentID.php?code=${Environment.code}&id=$id'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    print("getCategoriesChannelsByParentID = ${decryptedData.toString()}");

    return ResponseCategory.fromJson(jsonDecode(decryptedData));
  }
}

final liveChannelService = LiveChannelServices();
