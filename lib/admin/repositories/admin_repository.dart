import 'package:beach_resort_management/admin/model/admin_model.dart';
import 'package:beach_resort_management/config/supabase_service.dart';


import '../services/admin_service.dart';

class AdminRepository {
  final AdminService _service = AdminService();


  // LOGIN
  Future<AdminModel?> login({
    required String email,
    required String password,
  }) async {
    await _service.login(
      email: email,
      password: password,
    );

    final user =
        SupabaseService.client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final response =
        await _service.getAdmin(user.id);

    if (response == null) {
      await _service.logout();
      return null;
    }

    return AdminModel.fromJson(response);
  }

  // LOGOUT
  

  Future<void> logout() async {
    await _service.logout();
  }
}