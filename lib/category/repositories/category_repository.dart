

import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/category/data/services/category_service.dart';

class CategoryRepository {
  final CategoryService _service = CategoryService();

  Future<List<ResortModel>> getCategoryResorts(
    String category,
  ) {
    return _service.getCategoryResorts(category);
  }
}