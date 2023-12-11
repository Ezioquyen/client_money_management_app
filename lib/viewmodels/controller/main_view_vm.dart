

import 'package:flutter/cupertino.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/repository/house_repository.dart';


class MainViewVModel extends ChangeNotifier {
  final _houseApi = HouseRepository();
  Map<int,UserProvider> users ={};
  late final UserProvider userProvider;
  House _house = House(
      id: '',
      name: 'My House',
      information: '',
      role: true,
      date: '06/12/2023');
  set house(House value) {
    _house = value;
    notifyListeners();
  }
  Future<void> updateUsers(String id) async{
    users.clear();
    List<dynamic> jsonList = await _houseApi.getUsersByHouseApi(id);
    List<UserProvider>  userList = jsonList.map((jsonObject) => UserProvider.fromJson(jsonObject)).toList();
    for(UserProvider userProvider in userList){
      users[userProvider.id] = userProvider;
    }
  }
  House get house => _house;


}
