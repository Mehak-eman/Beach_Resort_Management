import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/config/supabase_service.dart';


class CategoryService {
  final _client = SupabaseService.client;

  Future<List<ResortModel>> getCategoryResorts(
    String category,
  ) async {
    final response = await _client
        .from('resorts')
        .select()
        .eq('category', category);

    return (response as List)
        .map(
          (e) => ResortModel.fromJson(e),
        )
        .toList();
  }
}