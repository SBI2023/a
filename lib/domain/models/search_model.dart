import 'package:iptv_sbi_v2/domain/models/dropdown_item.dart';

class SearchModel {
  final String searchQuery;
  final DropdownItem dropdownItem;
  final List<String> results;

  SearchModel({
    required this.searchQuery,
    required this.dropdownItem,
    required this.results,
  });

  String get title =>title;

  String get description =>description;

  Map<String, dynamic> toMap() {
    return {
      'searchQuery': searchQuery,
      'dropdownItem': dropdownItem.toMap(),
      'results': results,
    };
  }

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      searchQuery: map['searchQuery'],
      dropdownItem: DropdownItem.fromMap(map['dropdownItem']),
      results: List<String>.from(map['results']),
    );
  }
}
