import 'package:beach_resort_management/booking/models/booking_model.dart';
import 'package:beach_resort_management/booking/repositories/booking_repository.dart';
import 'package:flutter/material.dart';

class BookingViewModel extends ChangeNotifier {

  final BookingRepository _repository = BookingRepository();


  List<BookingModel> bookings = [];


  bool isLoading = false;


  String? errorMessage;



  // Upcoming bookings
  List<BookingModel> get upcomingBookings {

    return bookings.where((booking) {

      return booking.bookingStatus == "Pending" ||
          booking.bookingStatus == "Confirmed";

    }).toList();
  }



  // Completed bookings
  List<BookingModel> get completedBookings {

    return bookings.where((booking) {

      return booking.bookingStatus == "Completed";

    }).toList();
  }



  // Cancelled bookings
  List<BookingModel> get cancelledBookings {

    return bookings.where((booking) {

      return booking.bookingStatus == "Cancelled";

    }).toList();
  }





  // Load user bookings

  Future<void> loadBookings(String userId) async {

    try {

      isLoading = true;
      errorMessage = null;

      notifyListeners();



      bookings = await _repository.getBookings(userId);



    } catch (e) {

      errorMessage = e.toString();

    }


    finally {

      isLoading = false;

      notifyListeners();

    }
  }
  // Create new booking

  Future<BookingModel?> createBooking(
    BookingModel booking
) async {

  try {

    isLoading = true;
    notifyListeners();


    final createdBooking =
        await _repository.createBooking(booking);


    bookings.add(createdBooking);


    isLoading = false;
    notifyListeners();


    return createdBooking;


  } catch(e){

    isLoading = false;
    errorMessage = e.toString();
    notifyListeners();

    return null;
  }

}


  // Cancel booking

  Future<void> cancelBooking(
      int bookingId,
      String userId,
      ) async {


    try {


      await _repository.cancelBooking(bookingId);

     await loadBookings(userId);

    } catch(e) {

      errorMessage = e.toString();

      notifyListeners();

    }

  }






  // Clear data on logout

  void clearBookings(){

    bookings.clear();

    notifyListeners();

  }



}