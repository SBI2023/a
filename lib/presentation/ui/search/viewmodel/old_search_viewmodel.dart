import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/domain/models/dropdown_item.dart';

import '../../../../domain/models/search_model.dart';
import '../../../../data/repositories/search_repo.dart';
import '../../../../domain/services/search_service.dart';

class SearchViewModel extends GetxController {
  // Input
  final searchController = TextEditingController();

  // Output
  final dropdownItems = <DropdownItem>[
    DropdownItem(label: 'CHANNEL'),
    DropdownItem(label: 'MOVIE'),
    DropdownItem(label: 'SERIE'),
  ];

  final dropdownValue = 'CHANNEL'.obs;

  final _searchRepository = SearchRepository(searchService: SearchService());

  final searchResults = <String>[].obs;

  // Set the dropdown value
  void setDropdownValue(String value) {
    dropdownValue.value = value;
  }

  Future<void> search(String query) async {
    final results = await _searchRepository.search(query);
    searchResults.clear();
    searchResults.addAll(results);
  }
}
