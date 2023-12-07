import '../models/house.dart';
class UserProvider{
  int id;
  String username;
  String email;
  late List<House> houses;
  late List<Record> records;


 UserProvider({required this.id,required this.username,required this.email});

  factory UserProvider.fromJson(Map<String, dynamic> json) {
  return UserProvider(
    id: json['id'] ?? 1,
   username: json['username'] ?? 'User',
   email: json['email'] ?? 'example@gmail.com',
  );
 }
 void setUser(dynamic user){
    id = UserProvider.fromJson(user).id;
    username = UserProvider.fromJson(user).username;
    email = UserProvider.fromJson(user).email;
 }
 void setHouses(dynamic houses){
    this.houses = houses;
 }

}