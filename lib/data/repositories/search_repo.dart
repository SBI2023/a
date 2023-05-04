// import 'package:flutter/material.dart';
// import 'package:iptv_sbi_v2/domain/models/search_model.dart';
// import 'package:iptv_sbi_v2/domain/services/search_service.dart';
// import 'package:iptv_sbi_v2/domain/models/dropdown_item.dart';

// class SearchRepository {
//   final SearchService _searchService;

//   SearchRepository({required SearchService searchService})
//       : _searchService = searchService;

//   Future<List<SearchModel>> search(String query) async {
//     final List<String> searchResults = await _searchService.search(query);

//     final List<SearchModel> results =
//         searchResults.map((result) => SearchModel(
//               searchQuery: query,
//               dropdownItem: DropdownItem(label: result),
//             )).toList();

//     return results;
//   }
// }
//
//import 'package:flutter/material.dart';
/*import 'package:iptv_sbi_v2/domain/models/search_model.dart';
import 'package:iptv_sbi_v2/domain/services/search_service.dart';
import 'package:iptv_sbi_v2/domain/models/dropdown_item.dart';

class SearchRepository {
  final SearchService _searchService;

  SearchRepository({required SearchService searchService})
      : _searchService = searchService;

  Future<List<String>> search(String query) async {
    return await _searchService.search(query);
  }
}
*/
import 'package:iptv_sbi_v2/domain/services/search_service.dart';

class SearchRepository {
  final SearchService searchService;

  SearchRepository({required this.searchService});

  Future<List<String>> search(String
   query) async {
    return searchService.search(query);
  }
}

