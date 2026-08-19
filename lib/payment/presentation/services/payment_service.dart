import 'package:beach_resort_management/config/supabase_service.dart';

class PaymentService {
  final _client = SupabaseService.client;

  // ============================================================
  // CREATE PAYMENT
  // ============================================================

  Future<Map<String, dynamic>> createPayment(
    Map<String, dynamic> payment,
  ) async {
    try {
      final response = await _client
          .from('payments')
          .insert(payment)
          .select()
          .single();

      return response;
    } catch (e) {
      print("Create Payment Error: $e");
      rethrow;
    }
  }

  // ============================================================
  // GET PAYMENT BY BOOKING
  // ============================================================

  Future<Map<String, dynamic>?> getPaymentByBooking(
    int bookingId,
  ) async {
    try {
      final response = await _client
          .from('payments')
          .select()
          .eq('booking_id', bookingId)
          .maybeSingle();

      return response;
    } catch (e) {
      print("Get Payment Error: $e");
      rethrow;
    }
  }
}