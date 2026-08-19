import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/config/supabase_service.dart';
import 'package:beach_resort_management/search/models/search_filter_model.dart';


class SearchService {
  final _client = SupabaseService.client;

  Future<List<ResortModel>> searchResorts(
    String keyword,
    FilterModel filter,
  ) async {
    var query = _client.from("resorts").select();

    if (keyword.isNotEmpty) {
      query = query.or(
        "name.ilike.%$keyword%,location.ilike.%$keyword%",
      );
    }

    if (filter.location != null &&
        filter.location!.isNotEmpty) {
      query = query.eq(
        "location",
        filter.location!,
      );
    }

    if (filter.maxPrice != null) {
      query = query.lte(
        "price_per_night",
        filter.maxPrice!,
      );
    }

    if (filter.minRating != null) {
      query = query.gte(
        "rating",
        filter.minRating!,
      );
    }

    if (filter.category != null &&
        filter.category!.isNotEmpty) {
      query = query.eq(
        "category",
        filter.category!,
      );
    }

    final response = await query;

    return (response as List)
        .map((e) => ResortModel.fromJson(e))
        .toList();
  }
}