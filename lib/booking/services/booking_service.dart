import 'package:beach_resort_management/booking/models/booking_model.dart';
import 'package:beach_resort_management/config/supabase_service.dart';

class BookingService {
  final _client = SupabaseService.client;

  /// CREATE BOOKING
 Future<BookingModel> createBooking(BookingModel booking) async {
  try {
    print("Booking Data: ${booking.toJson()}");

    final response = await _client
        .from('bookings')
        .insert(booking.toJson())
        .select()
        .single();

    print("Booking Response: $response");

    return BookingModel.fromJson(response);
  } catch (e) {
    print("Booking Error: $e");
    rethrow;
  }
}

  /// GET BOOKINGS
  Future<List<BookingModel>> getBookings(
    String userId,
  ) async {
    try {
      final response = await _client
          .from('bookings')
          .select('''
            *,
            resorts(
              name,
              image_url,
              location
            ),
            rooms(
              room_type,
              image_url
            )
          ''')
          .eq('user_id', userId)
          .order(
            'check_in',
            ascending: false,
          );

      return (response as List)
          .map(
            (e) => BookingModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      print("Load Booking Error:");
      print(e);
      rethrow;
    }
  }

  /// CANCEL BOOKING
  Future<void> cancelBooking(
    int bookingId,
  ) async {
    try {
      await _client
          .from('bookings')
          .update({
            "booking_status": "Cancelled",
          })
          .eq(
            "id",
            bookingId,
          );
    } catch (e) {
      print("Cancel Booking Error:");
      print(e);
      rethrow;
    }
  }
}