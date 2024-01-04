
import 'package:untitled1/data/firebase_api.dart';
import 'package:untitled1/repository/user_repository.dart';

import '../models/user/user.dart';

class UserProvider{
  int id;
  String username = '';
  String email;
  String fcmToken='';
  final userRepository = UserRepository();
 UserProvider({required this.id,required this.username,required this.email});

 void setUser(dynamic user){
    id = user.id;
    username = user.username;
    email = user.email;
 }
static User toUser(UserProvider userProvider){
   return User(id: userProvider.id, username: userProvider.username, email: userProvider.email);
}
  Future<void> updateUserDeviceToken() async{
   await userRepository.updateDeviceTokenApi(id, FireBaseApi.fCMToken);
  }
  Future<void> removeUserDeviceToken() async{
   await userRepository.updateDeviceTokenApi(id, null);
  }
}