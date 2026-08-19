import 'package:beach_resort_management/favourite/services/favorite_service.dart';

class FavoriteRepository {
  final FavoriteService _service = FavoriteService();

  // ADD FAVORITE


  Future<Map<String, dynamic>> addFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      return await _service.addFavorite(
        userId: userId,
        resortId: resortId,
      );
    } catch (e) {
      print("FavoriteRepository Add Error: $e");
      rethrow;
    }
  }

 
  // REMOVE FAVORITE


  Future<void> removeFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      await _service.removeFavorite(
        userId: userId,
        resortId: resortId,
      );
    } catch (e) {
      print("FavoriteRepository Remove Error: $e");
      rethrow;
    }
  }


  // CHECK IF FAVORITE
  

  Future<bool> isFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      return await _service.isFavorite(
        userId: userId,
        resortId: resortId,
      );
    } catch (e) {
      print("FavoriteRepository Check Error: $e");
      rethrow;
    }
  }

 
  // GET FAVORITE RESORTS
 

  Future<List<Map<String, dynamic>>> getFavoriteResorts(
    String userId,
  ) async {
    try {
      return await _service.getFavoriteResorts(
        userId,
      );
    } catch (e) {
      print("FavoriteRepository Get Error: $e");
      rethrow;
    }
  }
}