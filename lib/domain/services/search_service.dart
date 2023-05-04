import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchService {
  final String baseUrl = "http://myapi.com/search";

  Future<List<String>> search(String query) async {
    var url = Uri.parse('$baseUrl?query=$query');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);

      List<String> results = body.map((dynamic item) {
        return item.toString();
      }).toList();

      return results;
    } else {
      throw Exception('Failed to search');
    }
  }
}
