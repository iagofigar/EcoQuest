class User {
  final String id;
  String? username;
  String? email;
  double? experience;
  int? level;
  String? createdAt;
  int? credits;

  User(this.id, this.username, this.email, this.experience, this.level,
      this.createdAt, this.credits);
}