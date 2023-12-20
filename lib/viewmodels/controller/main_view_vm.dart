
import 'package:flutter/cupertino.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/models/record.dart';

import 'package:untitled1/repository/house_repository.dart';

import '../../models/user/user.dart';
import '../../repository/record_repository.dart';


class MainViewVModel extends ChangeNotifier {
  final _recordRepository = RecordRepository();
  final _houseApi = HouseRepository();
  Map<int,User> users ={};
  late List<RecordPayment> records;
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
    List<User>  userList = jsonList.map((jsonObject) => User.fromJson(jsonObject)).toList();
    for(User user in userList){
      users[user.id] = user;
    }
  }
  House get house => _house;

  Future<dynamic> getRecordsByUsersAndGroup(String houseId, int userId, int groupId) async{
    List<dynamic> response = await _recordRepository.getRecordsByUsersAndGroupApi(houseId, userId, groupId);
    records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();

  }
  Future<dynamic> getAllRecordsByPayerAndHouse(String houseId, int payerId) async{
    List<dynamic> response = await _recordRepository.getAllRecordsByPayerAndHouseApi(houseId, payerId);
    records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();

  }
  Future<dynamic> getRecordsByPayerAndGroup(String houseId, int payerId, int groupId) async{
    List<dynamic> response = await _recordRepository.getRecordsByPayerAndGroupApi(houseId, payerId, groupId);
    records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();

  }
  Future<dynamic> getRecordsByPayerOther(String houseId, int payerId) async{
    List<dynamic> response = await _recordRepository.getRecordsByPayerOtherApi(houseId, payerId);
    records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();

  }
  Future<dynamic> getRecordsByUserOther(String houseId, int userId) async{
    List<dynamic> response = await _recordRepository.getRecordsByUserOtherApi(houseId, userId);
     records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();

  }
  Future<dynamic> getRecordsByHouseForAllMember(String houseId) async{
    List<dynamic> response = await _recordRepository.getRecordsByHouseForAllMemberApi(houseId);
     records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();

  }
  Future<dynamic> getRecordsByPayerAndHouse(String houseId, int payerId) async{
    List<dynamic> response = await _recordRepository.getAllRecordsByPayerAndHouseApi(houseId, payerId);
     records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();

  }
  Future<dynamic> createRecord(var data) async{
    List<dynamic> response = await _recordRepository.createRecordApi(data);
    records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();

  }
}
