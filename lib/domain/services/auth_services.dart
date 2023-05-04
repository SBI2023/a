import 'dart:convert';
import '../../data/env/env.dart';
import 'package:http/http.dart' as http;

import '../response/auth_response.dart';
import '../response/serie_response.dart';

class AuthServices {
  // static String decryptedData = "";

  Future<ResponseAuth> loginAuthentication(String inputCode, String? macAddress, String? serialNumber, String? modelName) async {
    // final response = await http.get(Uri.parse(url));
    final response = await http.post(
        Uri.parse(
            '${Environment.urlApi}/login/authentification.php?code=$inputCode}&mac=$macAddress&sn=$serialNumber&model=$modelName"'),
        headers: {
          'Accept': 'application/json',
        });

    String decryptedData = Environment.encryptDecrypt(response.body);

    print("decryptedData = ${decryptedData.toString()}");

    return ResponseAuth.fromJson(jsonDecode(decryptedData));
  }

}

final authService = AuthServices();
