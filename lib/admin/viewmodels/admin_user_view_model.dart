import 'package:flutter/material.dart';
import 'package:beach_resort_management/config/supabase_service.dart';

class AdminUserViewModel extends ChangeNotifier {
  final _client = SupabaseService.client;

  List<Map<String, dynamic>> users = [];

  bool isLoading = false;
  bool isDeleting = false;

  String? errorMessage;

  // ============================================================
  // LOAD USERS
  // ============================================================

  Future<void> loadUsers() async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        '========== LOAD ADMIN USERS ==========',
      );

      final response = await _client
          .from('profiles')
          .select()
          .order(
            'created_at',
            ascending: false,
          );

      users = List<Map<String, dynamic>>.from(
        response,
      );

      debugPrint(
        'Total Users: ${users.length}',
      );
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Load Users Error: $e',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // DELETE USER PROFILE
 

  Future<bool> deleteUser(
    String userId,
  ) async {
    try {
      isDeleting = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        '========== DELETE USER PROFILE ==========',
      );

      await _client
          .from('profiles')
          .delete()
          .eq(
            'id',
            userId,
          );

      users.removeWhere(
        (user) =>
            user['id'].toString() ==
            userId,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Delete User Error: $e',
      );

      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }

  // REFRESH
 

  Future<void> refreshUsers() async {
    await loadUsers();
  }

  
  // CLEAR USERS
  

  void clearUsers() {
    users.clear();
    errorMessage = null;

    notifyListeners();
  }
}