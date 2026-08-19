class PaymentModel {
  final int? id;
  final int bookingId;
  final String userId;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime? createdAt;

  const PaymentModel({
    this.id,
    required this.bookingId,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    this.paymentStatus = "Pending",
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "booking_id": bookingId,
      "user_id": userId,
      "amount": amount,
      "method": paymentMethod,
      "payment_status": paymentStatus,
    };
  }

  factory PaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentModel(
      id: json['id'],
      bookingId: json['booking_id'],
      userId: json['user_id'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod:
          json['method'] ?? 'Cash',
      paymentStatus:
          json['payment_status'] ?? 'Pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(
              json['created_at'].toString(),
            )
          : null,
    );
  }
}