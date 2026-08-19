import 'package:beach_resort_management/payment/models/payment_model.dart';
import 'package:beach_resort_management/payment/presentation/services/payment_service.dart';


class PaymentRepository {
  final PaymentService _service = PaymentService();


  // CREATE PAYMENT
  

  Future<PaymentModel> createPayment(
    PaymentModel payment,
  ) async {
    final response = await _service.createPayment(
      payment.toJson(),
    );

    return PaymentModel.fromJson(response);
  }

  
  // GET PAYMENT
  

  Future<PaymentModel?> getPaymentByBooking(
    int bookingId,
  ) async {
    final response =
        await _service.getPaymentByBooking(bookingId);

    if (response == null) {
      return null;
    }

    return PaymentModel.fromJson(response);
  }
}