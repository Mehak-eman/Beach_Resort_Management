import 'package:beach_resort_management/payment/models/payment_model.dart';
import 'package:beach_resort_management/payment/repositories/payment_repository.dart';
import 'package:flutter/material.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentRepository _repository =
      PaymentRepository();

  PaymentModel? payment;

  bool isLoading = false;

  String? errorMessage;

  
  // CREATE PAYMENT
  

  Future<bool> createPayment(
    PaymentModel paymentData,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      final result =
          await _repository.createPayment(
        paymentData,
      );

      payment = result;

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Payment Error: $e",
      );

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }


  // GET PAYMENT
  

  Future<PaymentModel?> getPaymentByBooking(
    int bookingId,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      final result =
          await _repository.getPaymentByBooking(
        bookingId,
      );

      payment = result;

      return result;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Get Payment Error: $e",
      );

      return null;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

 
  // CLEAR PAYMENT
  

  void clearPayment() {
    payment = null;
    errorMessage = null;

    notifyListeners();
  }
}