class User {
  final String image;
  final String id;
  final String name;
  final String email;

  User({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      image: json['image'] ?? '',
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}
