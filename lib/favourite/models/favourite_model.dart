class FavoriteModel {
  final int? id;
  final String userId;
  final int resortId;
  final DateTime? createdAt;

  // Joined resort data
  final String? resortName;
  final String? resortImage;
  final String? resortLocation;

  FavoriteModel({
    this.id,
    required this.userId,
    required this.resortId,
    this.createdAt,
    this.resortName,
    this.resortImage,
    this.resortLocation,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      userId: json['user_id'],
      resortId: json['resort_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      resortName: json['resorts']?['name'],
      resortImage: json['resorts']?['image_url'],
      resortLocation: json['resorts']?['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'resort_id': resortId,
    };
  }
}