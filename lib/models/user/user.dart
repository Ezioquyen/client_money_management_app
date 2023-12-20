class User{
  int id;
  String username;
  String email;

  User({required this.id, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 1,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }
}