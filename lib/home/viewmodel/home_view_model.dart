import 'package:flutter/material.dart';
import 'package:beach_resort_management/config/supabase_service.dart';
import 'package:beach_resort_management/authentication/models/resort_model.dart';

class HomeViewModel extends ChangeNotifier {
  final _client = SupabaseService.client;

  
  // VARIABLES


  List<ResortModel> resorts = [];

  bool isLoading = false;

  String? errorMessage;

  // LOAD ALL RESORTS
 

  Future<void> loadResorts() async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        "========== LOAD HOME RESORTS ==========",
      );

      final response = await _client
          .from('resorts')
          .select('''
            id,
            name,
            description,
            location,
            image_url,
            category,
            rating,
            price_per_night
          ''')
          .order(
            'id',
            ascending: false,
          );

      resorts = response
          .map<ResortModel>(
            (json) => ResortModel.fromJson(
              Map<String, dynamic>.from(json),
            ),
          )
          .toList();

      debugPrint(
        "Total Resorts: ${resorts.length}",
      );
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "HomeViewModel Load Resorts Error: $e",
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

 
  // REFRESH RESORTS
  

  Future<void> refreshResorts() async {
    await loadResorts();
  }

  // CLEAR DATA


  void clearResorts() {
    resorts.clear();
    errorMessage = null;

    notifyListeners();
  }
}