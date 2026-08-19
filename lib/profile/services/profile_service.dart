import 'package:beach_resort_management/config/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _client = SupabaseService.client;

  // GET PROFILE
 

  Future<Map<String, dynamic>?> getProfile(
    String userId,
  ) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      print("GET PROFILE ERROR: $e");
      rethrow;
    }
  }

  
  // CREATE PROFILE
 

  Future<Map<String, dynamic>> createProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      print("CREATE PROFILE DATA:");
      print(data);

      final response = await _client
          .from('profiles')
          .insert(data)
          .select()
          .single();

      print("PROFILE CREATED:");
      print(response);

      return response;
    } catch (e) {
      print("CREATE PROFILE ERROR: $e");
      rethrow;
    }
  }

  // UPDATE PROFILE


  Future<void> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _client
          .from('profiles')
          .update(data)
          .eq('id', userId);

      print("PROFILE UPDATED");
    } catch (e) {
      print("UPDATE PROFILE ERROR: $e");
      rethrow;
    }
  }

 
  // CHANGE PASSWORD
 

  Future<void> changePassword(
    String newPassword,
  ) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      print("CHANGE PASSWORD ERROR: $e");
      rethrow;
    }
  }
}