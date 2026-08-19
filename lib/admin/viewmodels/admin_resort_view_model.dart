import 'package:flutter/material.dart';
import 'package:beach_resort_management/config/supabase_service.dart';

class AdminResortViewModel extends ChangeNotifier {
  final _client = SupabaseService.client;

  List<Map<String, dynamic>> resorts = [];

  bool isLoading = false;
  bool isSaving = false;
  bool isDeleting = false;

  String? errorMessage;

  
  // LOAD RESORTS


  Future<void> loadResorts() async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        '========== LOAD ADMIN RESORTS ==========',
      );

      final response = await _client
          .from('resorts')
          .select('''
            id,
            name,
            location,
            image_url,
            category,
            price_per_night,
            rating
          ''')
          .order(
            'id',
            ascending: false,
          );

      resorts = List<Map<String, dynamic>>.from(response);

      debugPrint(
        'Total Resorts: ${resorts.length}',
      );
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Load Resorts Error: $e',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  
  // ADD RESORT
 

  Future<bool> addResort({
    required String name,
    required String location,
    required String imageUrl,
    required String category,
    required double pricePerNight,
    required double rating,
  }) async {
    try {
      isSaving = true;
      errorMessage = null;

      notifyListeners();

      final response = await _client
          .from('resorts')
          .insert({
            'name': name,
            'location': location,
            'image_url': imageUrl,
            'category': category,
            'price_per_night': pricePerNight,
            'rating': rating,
          })
          .select()
          .single();

      resorts.insert(
        0,
        Map<String, dynamic>.from(response),
      );

      debugPrint(
        'Resort added successfully.',
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Add Resort Error: $e',
      );

      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

 
  // UPDATE RESORT
  

  Future<bool> updateResort({
    required int id,
    required String name,
    required String location,
    required String imageUrl,
    required String category,
    required double pricePerNight,
    required double rating,
  }) async {
    try {
      isSaving = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        '========== UPDATE RESORT ==========',
      );

      await _client
          .from('resorts')
          .update({
            'name': name,
            'location': location,
            'image_url': imageUrl,
            'category': category,
            'price_per_night': pricePerNight,
            'rating': rating,
          })
          .eq(
            'id',
            id,
          );

      final index = resorts.indexWhere(
        (resort) =>
            resort['id'].toString() ==
            id.toString(),
      );

      if (index != -1) {
        resorts[index] = {
          ...resorts[index],
          'name': name,
          'location': location,
          'image_url': imageUrl,
          'category': category,
          'price_per_night': pricePerNight,
          'rating': rating,
        };
      }

      debugPrint(
        'Resort updated successfully.',
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Update Resort Error: $e',
      );

      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

 
  // DELETE RESORT
  

  Future<bool> deleteResort(int id) async {
    try {
      isDeleting = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        '========== DELETE RESORT ==========',
      );

      await _client
          .from('resorts')
          .delete()
          .eq(
            'id',
            id,
          );

      resorts.removeWhere(
        (resort) =>
            resort['id'].toString() ==
            id.toString(),
      );

      debugPrint(
        'Resort deleted successfully.',
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Delete Resort Error: $e',
      );

      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }


  // REFRESH


  Future<void> refreshResorts() async {
    await loadResorts();
  }

  // CLEAR


  void clearResorts() {
    resorts.clear();
    errorMessage = null;

    notifyListeners();
  }
}