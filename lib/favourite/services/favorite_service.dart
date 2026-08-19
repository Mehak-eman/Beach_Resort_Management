import 'package:beach_resort_management/config/supabase_service.dart';

class FavoriteService {
  final _client = SupabaseService.client;

  // ADD FAVORITE
  
  Future<Map<String, dynamic>> addFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      final response = await _client
          .from('favorites')
          .insert({
            'user_id': userId,
            'resort_id': resortId,
          })
          .select()
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      print("Add Favorite Error: $e");
      rethrow;
    }
  }

  
  // REMOVE FAVORITE


  Future<void> removeFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      await _client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('resort_id', resortId);
    } catch (e) {
      print("Remove Favorite Error: $e");
      rethrow;
    }
  }


  // CHECK FAVORITE
 

  Future<bool> isFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      final response = await _client
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('resort_id', resortId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print("Check Favorite Error: $e");
      rethrow;
    }
  }

  // GET FAVORITE RESORTS


  Future<List<Map<String, dynamic>>> getFavoriteResorts(
    String userId,
  ) async {
    try {
      final response = await _client
          .from('favorites')
          .select('''
            id,
            user_id,
            resort_id,
            created_at,
            resorts(
              id,
              name,
              description,
              image_url,
              location,
              category,
              price_per_night,
              rating
            )
          ''')
          .eq('user_id', userId)
          .order(
            'created_at',
            ascending: false,
          );

      return List<Map<String, dynamic>>.from(
        response,
      );
    } catch (e) {
      print("Get Favorite Resorts Error: $e");
      rethrow;
    }
  }
}