 class User{
  int id;
  String username;
  String email;

  User({this.id = 0, this.username = '',  this.email = ''});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }
}