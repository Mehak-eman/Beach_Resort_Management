import 'package:beach_resort_management/config/supabase_service.dart';

class AdminService {
  final _client = SupabaseService.client;

 
  // LOGIN
 

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }


  // GET ADMIN
 

  Future<Map<String, dynamic>?> getAdmin(
    String userId,
  ) async {
    final response = await _client
        .from('admin_users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

 
  // LOGOUT


  Future<void> logout() async {
    await _client.auth.signOut();
  }
}