import 'package:untitled1/models/record.dart';

import '../models/house.dart';
class UserProvider{
  int id;
  String username = '';
  String email;
  List<House> houses = [];
  List<RecordPayment> records = [];

 UserProvider({required this.id,required this.username,required this.email});

 void setUser(dynamic user){
    id = user.id;
    username = user.username;
    email = user.email;
 }

}