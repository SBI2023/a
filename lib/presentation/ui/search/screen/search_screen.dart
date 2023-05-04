/*/import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/domain/models/search_model.dart';
import 'package:iptv_sbi_v2/presentation/ui/search/view/old_search_view.dart';
import '../viewmodel/old_search_viewmodel.dart';

import '../../../../domain/models/dropdown_item.dart';
import 'package:iptv_sbi_v2/data/repositories/search_repo.dart';

class SearchScreen extends StatelessWidget {
  final SearchViewModel viewModel = SearchViewModel();

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
                              onChanged: (query) => viewModel.search(query),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search text
                    Expanded(
                      child: Obx(() {
                        if (viewModel.searchResults.isEmpty) {
                          return Center(
                            child: Text(
                              viewModel.searchController.text.isNotEmpty
                                  ? 'No results found'
                                  : 'Enter your search query',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: viewModel.searchResults.length,
                            itemBuilder: (context, index) {
                              final SearchModel result =
                                  viewModel.searchResults[index];
                              return ListTile(
                                title: Text(result.title),
                                subtitle: Text(result.description),
                                onTap: () => print('Selected item $index'),
                              );
                            },
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/domain/models/search_model.dart';
import '../viewmodel/old_search_viewmodel.dart';
import '../../../../domain/models/dropdown_item.dart';

class SearchScreen extends StatelessWidget {
  final SearchViewModel viewModel = Get.put(SearchViewModel());

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
                          Obx(() => DropdownButton<DropdownItem>(
                                value: viewModel.dropdownItems.firstWhere(
                                    (item) =>
                                        item.label ==
                                        viewModel.dropdownValue.value),
                                icon: const Icon(Icons.arrow_drop_down),
                                onChanged: (value) => viewModel
                                    .setDropdownValue(value!.label),
                                items: viewModel.dropdownItems
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(item.label),
                                        ))
                                    .toList(),
                              )),
                          const SizedBox(width: 8.0),
                          // Search field
                          Expanded(
                            child: TextField(
                              controller: viewModel.searchController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                              ),
                              onChanged: (query) => viewModel.search(query),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search text
                    Expanded(
                      child: Obx(() {
                        if (viewModel.searchResults.isEmpty) {
                          return Center(
                            child: Text(
                              viewModel.searchController.text.isNotEmpty
                                  ? 'No results found'
                                  : 'Enter your search query',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: viewModel.searchResults.length,
                            itemBuilder: (context, index) {
                              final SearchModel result =
                                  viewModel.searchResults[index];
                              return ListTile(
                                title: Text(result.title),
                                subtitle: Text(result.description),
                                onTap: () => print('Selected item $index'),
                              );
                            },
                          );
                        }
                      }),
                    ),
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
