class ResortModel {
  final int id;
  final String name;
  final String description;
  final String location;
  final String imageUrl;
  final double rating;
  final double pricePerNight;

  const ResortModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
  });

  factory ResortModel.fromJson(Map<String, dynamic> json) {
    return ResortModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      pricePerNight: (json['price_per_night'] ?? 0).toDouble(),
    );
  }

  Object? operator [](String other) {}
}