class AdminModel {
  final String id;
  final String name;
  final String email;

  const AdminModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AdminModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdminModel(
      id: json['id'] as String,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}