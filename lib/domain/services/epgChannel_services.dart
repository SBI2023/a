import 'dart:convert';
import '../../data/env/env.dart';
import '../../data/storage/secure_storage.dart';
import '../models/home_model.dart';
import 'package:http/http.dart' as http;

import '../response/epg_channel_response.dart';
import '../response/package_response.dart';

class EpgChannelServices {
  // static String decryptedData = "";

  Future<ResponseEpgChannel> getChannelEpg(String id) async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/live/getChannelEpg.php?channel_id=$id&code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    // print("decryptedData = ${decryptedData.toString()}");

    return ResponseEpgChannel.fromJson(jsonDecode(decryptedData));
  }

}

final epgChannelService = EpgChannelServices();
