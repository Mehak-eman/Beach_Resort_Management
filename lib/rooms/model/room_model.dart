class RoomModel {
  final int id;
  final int resortId;
  final String roomName;
  final String roomType;
  final String description;
  final String imageUrl;
  final double pricePerNight;
  final int maxGuests;
  final int totalRooms;
  final int availableRooms;

  const RoomModel({
    required this.id,
    required this.resortId,
    required this.roomName,
    required this.roomType,
    required this.description,
    required this.imageUrl,
    required this.pricePerNight,
    required this.maxGuests,
    required this.totalRooms,
    required this.availableRooms,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as int,
     resortId: json['resort_id'] ?? 0,
      roomName: json['room_name'] ?? '',
      roomType: json['room_type'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      pricePerNight: (json['price_per_night'] ?? 0).toDouble(),
      maxGuests: json['max_guests'] ?? 0,
     totalRooms: json['total_rooms'] ?? 0,
      availableRooms: json['available_rooms'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resort_id': resortId,
      'room_name': roomName,
      'room_type': roomType,
      'description': description,
      'image_url': imageUrl,
      'price_per_night': pricePerNight,
      'max_guests': maxGuests,
      'total_rooms': totalRooms,
      'available_rooms': availableRooms,
    };
  }
}