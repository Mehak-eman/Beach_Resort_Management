import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/search/models/search_filter_model.dart';
import 'package:flutter/material.dart';

import '../../repositories/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _repository =
      SearchRepository();

  bool isLoading = false;
FilterModel filter = const FilterModel();
  String? errorMessage;

  List<ResortModel> resorts = [];



  Future<void> search(String keyword) async {
  try {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    resorts = await _repository.searchResorts(
      keyword,
      filter,
    );

    isLoading = false;
    notifyListeners();
  } catch (e) {
    isLoading = false;
    errorMessage = e.toString();
    notifyListeners();
  }
}

void updateFilter(FilterModel value) {
  filter = value;
}

void clearFilters() {
  filter = const FilterModel();
  notifyListeners();
}

  void clear() {
    resorts.clear();
    notifyListeners();
  }
}