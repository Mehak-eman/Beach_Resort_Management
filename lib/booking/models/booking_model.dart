class BookingModel {
  final int? id;
  final String userId;
  final int resortId;
  final int roomId;

  final DateTime checkIn;
  final DateTime checkOut;

  final int guests;
  final double totalPrice;

  final String bookingStatus;
  final String paymentStatus;

  // Joined data
  final String? resortName;
  final String? resortImage;
  final String? resortLocation;

  final String? roomName;
  final String? roomImage;

  const BookingModel({
    this.id,
    required this.userId,
    required this.resortId,
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    this.bookingStatus = "Pending",
    this.paymentStatus = "Pending",

    this.resortName,
    this.resortImage,
    this.resortLocation,
    this.roomName,
    this.roomImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'resort_id': resortId,
      'room_id': roomId,
      'check_in': checkIn.toIso8601String(),
      'check_out': checkOut.toIso8601String(),
      'guests': guests,
      'total_price': totalPrice,
      'booking_status': bookingStatus,
     
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['user_id'],
      resortId: json['resort_id'],
      roomId: json['room_id'],
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      guests: json['guests'],
      totalPrice: (json['total_price'] as num).toDouble(),
      bookingStatus: json['booking_status'],
      paymentStatus: json['payment_status'] ?? "Pending",

      resortName: json['resorts']?['name'],
      resortImage: json['resorts']?['image_url'],
      resortLocation: json['resorts']?['location'],

      roomName: json['rooms']?['room_type'],
      roomImage: json['rooms']?['image_url'],
    );
  }

  get status => null;

  
}