import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/search/models/search_filter_model.dart';
import 'package:beach_resort_management/search/services/search_services.dart';


class SearchRepository {
  final SearchService _service = SearchService();

  Future<List<ResortModel>> searchResorts(
    String keyword,
    FilterModel filter,
  ) {
    return _service.searchResorts(
      keyword,
      filter,
    );
  }
}