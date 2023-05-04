/*import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:iptv_sbi_v2/domain/models/search_model.dart';
import 'package:iptv_sbi_v2/domain/models/dropdown_item.dart';
import 'package:iptv_sbi_v2/data/repositories/search_repo.dart';

class SearchViewModel with ChangeNotifier {
  final SearchRepository _searchRepository;

  TextEditingController searchController = TextEditingController();

  DropdownItem dropdownValue = DropdownItem(label: 'Option 1');

  SearchViewModel({required SearchRepository searchRepository})
      : _searchRepository = searchRepository;

  Future<SearchModel> search(String query) async {
    final List<String> results = await _searchRepository.search(query);
    return SearchModel(
      searchQuery: query,
      dropdownItem: dropdownValue,
      results: results,
    );
  }

  void performSearch() async {
    final query = searchController.text;
    if (query.isNotEmpty) {
      final searchModel = await search(query);
      // Do something with the search results
    }
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/domain/models/dropdown_item.dart';
import 'package:iptv_sbi_v2/domain/models/search_model.dart';
import 'package:iptv_sbi_v2/data/repositories/search_repo.dart';

class SearchViewModel extends GetxController {
  final SearchRepository searchRepository;

  SearchViewModel({required this.searchRepository});

  final searchResult = Rx<SearchModel?>(null);
  final dropdownValue = RxString('');

  final TextEditingController searchController = TextEditingController();

  final dropdownItems = [
    DropdownItem(label: 'All'),
    DropdownItem(label: 'Movies'),
    DropdownItem(label: 'TV Shows'),
  ];

  void setDropdownValue(String value) {
    dropdownValue.value = value;
  }

  Future<void> performSearch() async {
    final query = searchController.text;
    final category = dropdownValue.value.toLowerCase();
    final results = await searchRepository.search('$category $query');
    final dropdownItem = DropdownItem(label: dropdownValue.value);

    searchResult.value = SearchModel(
        searchQuery: query, dropdownItem: dropdownItem, results: results);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
