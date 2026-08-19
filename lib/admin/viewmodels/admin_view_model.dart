import 'package:flutter/material.dart';
import 'package:beach_resort_management/config/supabase_service.dart';

class AdminViewModel extends ChangeNotifier {
  final _client = SupabaseService.client;

  bool isLoading = false;
  String? errorMessage;

  int totalUsers = 0;
  int totalResorts = 0;
  int totalBookings = 0;
  int totalPayments = 0;

  int pendingBookings = 0;
  int pendingPayments = 0;


  // ADMIN LOGIN
  

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        '========== ADMIN LOGIN ==========',
      );

      debugPrint(
        'Email: ${email.trim()}',
      );

      
      // SUPABASE AUTH LOGIN
     

      final response =
          await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = response.user;

      debugPrint(
        'Authenticated User: ${user?.id}',
      );

      if (user == null) {
        errorMessage =
            'Invalid email or password.';
        return false;
      }


      // GET PROFILE
      

      final profile = await _client
          .from('profiles')
          .select(
            'id, full_name, role',
          )
          .eq(
            'id',
            user.id,
          )
          .maybeSingle();

      debugPrint(
        'Admin Profile: $profile',
      );

    
      // PROFILE NOT FOUND
  

      if (profile == null) {
        errorMessage =
            'Admin profile was not found for this user.';
        return false;
      }

 
      // CHECK ROLE
   
      final role = profile['role']
          ?.toString()
          .trim()
          .toLowerCase();

      debugPrint(
        'User Role: $role',
      );

      if (role != 'admin') {
        errorMessage =
            'This account is not an admin.';
        return false;
      }

      debugPrint(
        'ADMIN LOGIN SUCCESS',
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        '========== ADMIN LOGIN ERROR ==========',
      );

      debugPrint(
        e.toString(),
      );

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

 
  // LOAD DASHBOARD
 

  Future<void> loadDashboard() async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      // USERS

      final usersResponse =
          await _client
              .from('profiles')
              .select('id');

      totalUsers =
          usersResponse.length;

      // RESORTS

      final resortsResponse =
          await _client
              .from('resorts')
              .select('id');

      totalResorts =
          resortsResponse.length;

      // BOOKINGS

      final bookingsResponse =
          await _client
              .from('bookings')
              .select(
                'id, status',
              );

      totalBookings =
          bookingsResponse.length;

      pendingBookings =
          bookingsResponse.where(
        (booking) =>
            booking['status']
                ?.toString()
                .toLowerCase() ==
            'pending',
      ).length;

      // PAYMENTS

      final paymentsResponse =
          await _client
              .from('payments')
              .select(
                'id, payment_status',
              );

      totalPayments =
          paymentsResponse.length;

      pendingPayments =
          paymentsResponse.where(
        (payment) =>
            payment['payment_status']
                ?.toString()
                .toLowerCase() ==
            'pending',
      ).length;
    } catch (e) {
      errorMessage =
          e.toString();

      debugPrint(
        'Admin Dashboard Error: $e',
      );
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }


  // REFRESH
  

  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  // CLEAR DATA


  void clearData() {
    totalUsers = 0;
    totalResorts = 0;
    totalBookings = 0;
    totalPayments = 0;

    pendingBookings = 0;
    pendingPayments = 0;

    errorMessage = null;

    notifyListeners();
  }
}