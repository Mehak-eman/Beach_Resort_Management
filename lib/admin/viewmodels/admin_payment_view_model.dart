import 'package:flutter/material.dart';
import 'package:beach_resort_management/config/supabase_service.dart';

class AdminPaymentViewModel extends ChangeNotifier {
  final _client = SupabaseService.client;

  // ============================================================
  // VARIABLES
  // ============================================================

  List<Map<String, dynamic>> payments = [];

  bool isLoading = false;
  bool isUpdating = false;

  String? errorMessage;

  // ============================================================
  // LOAD ALL PAYMENTS
  // ============================================================

  Future<void> loadPayments() async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        '========== LOAD ADMIN PAYMENTS ==========',
      );

      final response = await _client
          .from('payments')
          .select('''
            id,
            booking_id,
            user_id,
            amount,
            method,
            payment_status,
            created_at
          ''')
          .order(
            'created_at',
            ascending: false,
          );

      payments =
          List<Map<String, dynamic>>.from(response);

      debugPrint(
        'Total Payments: ${payments.length}',
      );
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Load Admin Payments Error: $e',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  // UPDATE PAYMENT STATUS


  Future<bool> updatePaymentStatus({
    required int paymentId,
    required String status,
  }) async {
    try {
      isUpdating = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        '========== UPDATE PAYMENT ==========',
      );

      debugPrint(
        'Payment ID: $paymentId',
      );

      debugPrint(
        'New Status: $status',
      );

      await _client
          .from('payments')
          .update({
            'payment_status': status,
          })
          .eq(
            'id',
            paymentId,
          );

      
      // UPDATE LOCAL LIST
      

      final index = payments.indexWhere(
        (payment) =>
            payment['id'].toString() ==
            paymentId.toString(),
      );

      if (index != -1) {
        payments[index]['payment_status'] =
            status;
      }

      debugPrint(
        'PAYMENT STATUS UPDATED SUCCESSFULLY',
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        'Update Payment Status Error: $e',
      );

      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

 
  // MARK PAYMENT AS PAID
  

  Future<bool> markAsPaid(
    int paymentId,
  ) async {
    return await updatePaymentStatus(
      paymentId: paymentId,
      status: 'Paid',
    );
  }

  // MARK PAYMENT AS PENDING
 

  Future<bool> markAsPending(
    int paymentId,
  ) async {
    return await updatePaymentStatus(
      paymentId: paymentId,
      status: 'Pending',
    );
  }

 
  // MARK PAYMENT AS FAILED
  

  Future<bool> markAsFailed(
    int paymentId,
  ) async {
    return await updatePaymentStatus(
      paymentId: paymentId,
      status: 'Failed',
    );
  }

  
  // REFRESH PAYMENTS
  

  Future<void> refreshPayments() async {
    await loadPayments();
  }

 
  // CLEAR PAYMENTS


  void clearPayments() {
    payments.clear();
    errorMessage = null;

    notifyListeners();
  }
}