import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:flutter/material.dart';

import '../../repositories/category_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository _repository =
      CategoryRepository();

  bool isLoading = false;

  List<ResortModel> resorts = [];

  Future<void> loadCategory(
    String category,
  ) async {
    isLoading = true;
    notifyListeners();

    resorts = await _repository.getCategoryResorts(
      category,
    );

    isLoading = false;
    notifyListeners();
  }
}