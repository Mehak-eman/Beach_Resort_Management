
import 'package:beach_resort_management/config/supabase_service.dart';

import '../models/resort_model.dart';

class ResortService {
  final _client = SupabaseService.client;

  Future<List<ResortModel>> getAllResorts() async {
    final response = await _client
        .from('resorts')
        .select()
        .order('rating', ascending: false);

    return response
        .map<ResortModel>((json) => ResortModel.fromJson(json))
        .toList();
  }
}