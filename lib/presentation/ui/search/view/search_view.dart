/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/models/search_model.dart';
import '../../../../domain/models/dropdown_item.dart';
import '../viewmodel/search_viewmodel.dart';
import '../../../../domain/models/dropdown_item.dart';
import '../../../../data/repositories/search_repo.dart';
import '../viewmodel/old_search_viewmodel.dart';


class SearchScreen extends StatelessWidget {
  final SearchViewModel viewModel = Get.put(SearchViewModel(searchRepository: SearchRepository()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Image.asset(
              'assets/bg_settings_screen.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                // Overlay black background with opacity
                color: Colors.black.withOpacity(0.5),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Search bar
                    Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          // Dropdown button
                          DropdownButton<DropdownItem>(
                            value: viewModel.dropdownItems.firstWhere((item) =>
                                item.label == viewModel.dropdownValue.value),
                            icon: const Icon(Icons.arrow_drop_down),
                            onChanged: (value) =>
                                viewModel.setDropdownValue(value!.label),
                            items: viewModel.dropdownItems
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item.label),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(width: 8.0),
                          // Search field
                          Expanded(
                            child: TextField(
                              controller: viewModel.searchController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                              ),
                            ),
                          ),
                          // Search button
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => viewModel.performSearch(),
                          ),
                        ],
                      ),
                    ),
                    // Search results
                    Obx(() {
                      final searchResult = viewModel.searchResult.value;
                      if (searchResult != null) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: searchResult.results.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(searchResult.results[index]),
                            ),
                          ),
                        );
                      } else {
                        return const Expanded(
                          child: Center(
                            child: Text(
                              'Enter your search query',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/models/search_model.dart';
import '../../../../domain/models/dropdown_item.dart';
import '../viewmodel/search_viewmodel.dart';
import 'package:iptv_sbi_v2/domain/services/search_service.dart';
import '../../../../data/repositories/search_repo.dart';

class SearchScreen extends StatelessWidget {
  final SearchViewModel viewModel = Get.put(
    SearchViewModel(
        searchRepository: SearchRepository(searchService: SearchService())),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Image.asset(
              'assets/bg_settings_screen.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                // Overlay black background with opacity
                color: Colors.black.withOpacity(0.5),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Search bar
                    Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          // Dropdown button
                          DropdownButton<DropdownItem>(
                            value: viewModel.dropdownItems.firstWhere((item) =>
                                item.label == viewModel.dropdownValue.value),
                            icon: const Icon(Icons.arrow_drop_down),
                            onChanged: (value) =>
                                viewModel.setDropdownValue(value!.label),
                            items: viewModel.dropdownItems
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item.label),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(width: 8.0),
                          // Search field
                          Expanded(
                            child: TextField(
                              controller: viewModel.searchController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                              ),
                            ),
                          ),
                          // Search button
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => viewModel.performSearch(),
                          ),
                        ],
                      ),
                    ),
                    // Search results
                    Obx(() {
                      final searchResult = viewModel.searchResult.value;
                      if (searchResult != null) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: searchResult.results.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(searchResult.results[index]),
                            ),
                          ),
                        );
                      } else {
                        return const Expanded(
                          child: Center(
                            child: Text(
                              'Enter your search query',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
