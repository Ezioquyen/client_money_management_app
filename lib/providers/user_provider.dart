
import '../models/user/user.dart';

class UserProvider{
  int id;
  String username = '';
  String email;

 UserProvider({required this.id,required this.username,required this.email});

 void setUser(dynamic user){
    id = user.id;
    username = user.username;
    email = user.email;
 }
static User toUser(UserProvider userProvider){
   return User(id: userProvider.id, username: userProvider.username, email: userProvider.email);
}
}