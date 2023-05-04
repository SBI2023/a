import '../storage/local_data.dart';

class Environment {
  //static const String baseUrl = 'https://bcf6-197-14-226-119.eu.ngrok.io/';
  //static const String urlApi = 'http://127.0.0.1:7070/';
  // static const String baseUrl = 'https://infinity-camping.herokuapp.com/';
  static const String baseUrl = 'http://gtv2.tn:6274/';

  //static const String urlApi = 'https://bcf6-197-14-226-119.eu.ngrok.io/api';
  //static const String urlApi = 'http://127.0.0.1:7070/api';
  // static const String urlApi = 'https://infinity-camping.herokuapp.com/api';
  static const String urlApi = 'http://gtv2.tn:6274/api-v3';

  static String code = LocalData().getData("code");
  // static String code = "255473128661";

  static const String assetsPath = "assets/images/";

  // Decrypt Function
  static String encryptDecrypt(String input) {
    String key = "Ax0#fc_W7k@49N+6G8/1pl7";
    String output = "";
    int keylen = key.length;
    for (int i = 0; i < input.length; i++) {
      output +=
          String.fromCharCode(input.codeUnitAt(i) ^ key.codeUnitAt(i % keylen));
    }
    return output;
  }
}
