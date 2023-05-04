import 'dart:convert';

import '../../data/env/env.dart';

import 'package:http/http.dart' as http;

import '../response/package_response.dart';


class PackageServices {
  static String decryptedData = "";

  Future<ResponsePackage> getPackages() async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.get(
        Uri.parse(
            '${Environment.urlApi}/getPackages.php?code=${Environment.code}'),
        headers: {
          'Accept': 'application/json',
        });
    decryptedData = Environment.encryptDecrypt(response.body);

    return ResponsePackage.fromJson(jsonDecode(decryptedData));
  }
}

final packageService = PackageServices();