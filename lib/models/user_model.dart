class User {
  final String id;
  String? username;
  String? email;
  double? experience;
  int? level;
  String? createdAt;
  int? credits;

  User({required this.id, this.username, this.email, this.experience, this.level,
      this.createdAt, this.credits});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      experience: map['experience'] as double,
      level: map['level'] as int,
      createdAt: map['limit'] ?? '',
      credits: map['credits'] as int,
    );
  }
}