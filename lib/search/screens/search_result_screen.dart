import 'package:beach_resort_management/home/data/featured_resort_card.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:beach_resort_management/search/models/search_filter_model.dart';
import 'package:beach_resort_management/search/presenntation/viewmodels/search_viewmodel.dart';
import 'package:beach_resort_management/search/widgets/filter_bottom_sheet.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() =>
      _SearchResultScreenState();
}

class _SearchResultScreenState
    extends State<SearchResultScreen> {
  final TextEditingController searchController =
      TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  foregroundColor: Colors.black,

  title: TextField(
    controller: searchController,
    autofocus: true,
    decoration: const InputDecoration(
      hintText: "Search resorts...",
      border: InputBorder.none,
      prefixIcon: Icon(Icons.search),
    ),
    onChanged: (value) {
      provider.search(value);
    },
  ),

  actions: [
    IconButton(
      icon: const Icon(Icons.filter_alt_outlined),
      onPressed: () async {
        final filter =
            await showModalBottomSheet<FilterModel>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          builder: (_) => FilterBottomSheet(
            currentFilter: provider.filter,
          ),
        );

        if (filter != null) {
          provider.updateFilter(filter);
          provider.search(searchController.text);
        }
      },
    ),
  ],
),

      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (searchController.text.isEmpty) {
            return const Center(
              child: Text(
                "Search your favorite resort",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          if (provider.resorts.isEmpty) {
            return const Center(
              child: Text(
                "No resorts found",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.resorts.length,
            itemBuilder: (context, index) {
              final resort = provider.resorts[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: GestureDetector(
                  onTap: () {
                    context.push(
                      RouteNames.resortDetails,
                      extra: resort,
                    );
                  },
                  child: FeaturedResortCard(
                    resort: resort,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}