import 'package:beach_resort_management/booking/models/booking_model.dart';
import 'package:beach_resort_management/booking/services/booking_service.dart';

class BookingRepository {
  final BookingService _service = BookingService();

  Future<BookingModel> createBooking(
    BookingModel booking
) async {

  return await _service.createBooking(booking);

}

  Future<List<BookingModel>> getBookings(String userId) {
    return _service.getBookings(userId);
  }

  Future<void> cancelBooking(int id) {
    return _service.cancelBooking(id);
  }
}