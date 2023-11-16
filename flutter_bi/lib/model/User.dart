class User {
  final String image;
  final String id;
  final String name;
  final String email;
  final DateTime date;
  final int v;

  User({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.date,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      image: json['image'] ?? '',
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      date: DateTime.parse(json['date'] ?? ''),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      '_id': id,
      'name': name,
      'email': email,
      'date': date.toIso8601String(),
      '__v': v,
    };
  }
}
