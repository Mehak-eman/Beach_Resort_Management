import 'package:flutter/material.dart';

import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/config/supabase_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  final _client = SupabaseService.client;

 
  // FAVORITE RESORTS
 

  List<ResortModel> favorites = [];

  // Contains only the IDs of favorite resorts.
  // This is used by the favorite heart icon.
  final Set<int> favoriteResortIds = {};

 
  // STATE
 

  bool isLoading = false;
  bool isUpdating = false;

  String? errorMessage;


  // CHECK LOCAL FAVORITE
 

  bool isFavorite(int resortId) {
    return favoriteResortIds.contains(resortId);
  }


  // LOAD FAVORITES
 

  Future<void> loadFavorites(String userId) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        "========== LOAD FAVORITES ==========",
      );

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
          .eq(
            'user_id',
            userId,
          )
          .order(
            'created_at',
            ascending: false,
          );

      final List<dynamic> data = response;

      final List<ResortModel> loadedFavorites = [];

      for (final item in data) {
        final resortData = item['resorts'];

        if (resortData == null) {
          continue;
        }

        final resort =
            ResortModel.fromJson(
          Map<String, dynamic>.from(
            resortData,
          ),
        );

        loadedFavorites.add(resort);
      }

      favorites = loadedFavorites;

      // Update favorite IDs
      favoriteResortIds
        ..clear()
        ..addAll(
          favorites.map(
            (resort) => resort.id,
          ),
        );

      debugPrint(
        "Favorite Resorts: ${favorites.length}",
      );

      debugPrint(
        "Favorite IDs: $favoriteResortIds",
      );
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Load Favorites Error: $e",
      );
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  
  // TOGGLE FAVORITE
  
  Future<bool> toggleFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      isUpdating = true;
      errorMessage = null;

      notifyListeners();

      final alreadyFavorite =
          favoriteResortIds.contains(
        resortId,
      );

     
      // REMOVE FAVORITE
      
      if (alreadyFavorite) {
        debugPrint(
          "Removing favorite: $resortId",
        );

        await _client
            .from('favorites')
            .delete()
            .eq(
              'user_id',
              userId,
            )
            .eq(
              'resort_id',
              resortId,
            );

        // Remove local ID
        favoriteResortIds.remove(
          resortId,
        );

        // Remove from favorite list
        favorites.removeWhere(
          (resort) =>
              resort.id == resortId,
        );

        debugPrint(
          "Favorite removed successfully",
        );
      }

     
      // ADD FAVORITE
     

      else {
        debugPrint(
          "Adding favorite: $resortId",
        );

        await _client
            .from('favorites')
            .insert({
          'user_id': userId,
          'resort_id': resortId,
        });

        // Add local ID
        favoriteResortIds.add(
          resortId,
        );

        debugPrint(
          "Favorite added successfully",
        );
      }

      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Toggle Favorite Error: $e",
      );

      return false;
    } finally {
      isUpdating = false;

      notifyListeners();
    }
  }

  // ADD FAVORITE

  Future<bool> addFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      if (favoriteResortIds.contains(
        resortId,
      )) {
        return true;
      }

      await _client
          .from('favorites')
          .insert({
        'user_id': userId,
        'resort_id': resortId,
      });

      favoriteResortIds.add(
        resortId,
      );

      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Add Favorite Error: $e",
      );

      notifyListeners();

      return false;
    }
  }

  // REMOVE FAVORITE


  Future<bool> removeFavorite({
    required String userId,
    required int resortId,
  }) async {
    try {
      await _client
          .from('favorites')
          .delete()
          .eq(
            'user_id',
            userId,
          )
          .eq(
            'resort_id',
            resortId,
          );

      favoriteResortIds.remove(
        resortId,
      );

      favorites.removeWhere(
        (resort) =>
            resort.id == resortId,
      );

      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Remove Favorite Error: $e",
      );

      notifyListeners();

      return false;
    }
  }

  // REFRESH


  Future<void> refreshFavorites(
    String userId,
  ) async {
    await loadFavorites(
      userId,
    );
  }

  
  // CLEAR
 

  void clearFavorites() {
    favorites.clear();

    favoriteResortIds.clear();

    errorMessage = null;

    notifyListeners();
  }
}