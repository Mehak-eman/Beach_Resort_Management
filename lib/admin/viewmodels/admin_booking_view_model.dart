import 'package:flutter/material.dart';
import 'package:beach_resort_management/config/supabase_service.dart';

class AdminBookingViewModel extends ChangeNotifier {
  final _client = SupabaseService.client;

  List<Map<String, dynamic>> bookings = [];

  bool isLoading = false;
  bool isUpdating = false;

  String? errorMessage;

  // LOAD ALL BOOKINGS


 Future<void> loadBookings() async {
  try {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    debugPrint(
      "========== LOAD ADMIN BOOKINGS ==========",
    );

   
    // GET BOOKINGS
  

    final response = await _client
        .from('bookings')
        .select('''
          id,
          user_id,
          resort_id,
          room_id,
          check_in,
          check_out,
          guests,
          total_price,
          booking_status,
          payment_status,
          status,
          created_at
        ''')
        .order(
          'created_at',
          ascending: false,
        );

    final bookingList =
        List<Map<String, dynamic>>.from(response);

    
    // LOAD USER PROFILE FOR EACH BOOKING
   

    for (final booking in bookingList) {
      final userId =
          booking['user_id']?.toString();

      if (userId == null) {
        continue;
      }

      try {
        final profile = await _client
            .from('profiles')
            .select('''
              id,
              full_name,
              phone,
              profile_image,
              role,
              created_at,
              image_url
            ''')
            .eq('id', userId)
            .maybeSingle();

        booking['profile'] = profile;
      } catch (e) {
        debugPrint(
          "Profile Load Error: $e",
        );

        booking['profile'] = null;
      }
    }

    bookings = bookingList;

    debugPrint(
      "Total Bookings: ${bookings.length}",
    );
  } catch (e) {
    errorMessage = e.toString();

    debugPrint(
      "Load Admin Bookings Error: $e",
    );
  } finally {
    isLoading = false;

    notifyListeners();
  }
}

  
  // UPDATE STATUS
 

  Future<bool> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    try {
      isUpdating = true;
      errorMessage = null;

      notifyListeners();

      final id = int.tryParse(bookingId);

      if (id == null) {
        throw Exception(
          "Invalid booking ID: $bookingId",
        );
      }

      debugPrint(
        "Updating booking $id to $status",
      );

      await _client
          .from('bookings')
          .update({
            'status': status,
          })
          .eq(
            'id',
            id,
          );

      // Update local list
      final index = bookings.indexWhere(
        (booking) =>
            booking['id'].toString() ==
            bookingId,
      );

      if (index != -1) {
        bookings[index]['status'] = status;
      }

      debugPrint(
        "BOOKING STATUS UPDATED",
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Update Booking Status Error: $e",
      );

      return false;
    } finally {
      isUpdating = false;

      notifyListeners();
    }
  }


  // APPROVE BOOKING
  

  Future<bool> approveBooking(
    String bookingId,
  ) async {
    return updateBookingStatus(
      bookingId: bookingId,
      status: 'approved',
    );
  }


  // REJECT BOOKING
  
  Future<bool> rejectBooking(
    String bookingId,
  ) async {
    return updateBookingStatus(
      bookingId: bookingId,
      status: 'rejected',
    );
  }

  
  // COMPLETE BOOKING
 

  Future<bool> completeBooking(
    String bookingId,
  ) async {
    return updateBookingStatus(
      bookingId: bookingId,
      status: 'completed',
    );
  }

 
  // CANCEL BOOKING
 

  Future<bool> cancelBooking(
    String bookingId,
  ) async {
    return updateBookingStatus(
      bookingId: bookingId,
      status: 'cancelled',
    );
  }

  
  // UPDATE BOOKING STATUS COLUMN
 
  
  // If your app uses booking_status instead of status
  // for approval/rejection, use this method instead.
  

  Future<bool> updateBookingStatusField({
    required String bookingId,
    required String bookingStatus,
  }) async {
    try {
      isUpdating = true;
      errorMessage = null;

      notifyListeners();

      final id = int.tryParse(bookingId);

      if (id == null) {
        throw Exception(
          "Invalid booking ID: $bookingId",
        );
      }

      await _client
          .from('bookings')
          .update({
            'booking_status': bookingStatus,
          })
          .eq(
            'id',
            id,
          );

      final index = bookings.indexWhere(
        (booking) =>
            booking['id'].toString() ==
            bookingId,
      );

      if (index != -1) {
        bookings[index]['booking_status'] =
            bookingStatus;
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Update Booking Status Field Error: $e",
      );

      return false;
    } finally {
      isUpdating = false;

      notifyListeners();
    }
  }

 
  // REFRESH
 

  Future<void> refreshBookings() async {
    await loadBookings();
  }

 
  // CLEAR
  

  void clearBookings() {
    bookings.clear();
    errorMessage = null;

    notifyListeners();
  }
}