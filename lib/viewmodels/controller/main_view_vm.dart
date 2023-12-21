
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/models/record.dart';

import 'package:untitled1/repository/house_repository.dart';

import '../../models/user/user.dart';
import '../../models/user_house.dart';
import '../../repository/record_repository.dart';


class MainViewVModel extends ChangeNotifier {
  final _recordRepository = RecordRepository();
  final _houseRepository = HouseRepository();
  late User user;
  List<User> users = [];
  Map<int,User> usersById ={};
   List<RecordPayment> records = [];
  List<House> houses= [];
  House _house = House(
      id: '',
      name: 'My House',
      information: '',
      role: true,
      date: '06/12/2023');
  set house(House value) {
    _house = value;

  }
  Future<void> updateUsers() async{
    usersById.clear();
    List<dynamic> jsonList = await _houseRepository.getUsersByHouseApi(_house.id);
    users = jsonList.map((jsonObject) => User.fromJson(jsonObject)).toList();
    for(User user in users){
      usersById[user.id] = user;
    }
  }
  House get house => _house;
  //house
  Future<bool> isUserHasHouse() async {
    return await _houseRepository.isUserHasHouse(user.id);
  }
  Future<dynamic> joinHouse(bool role, String id) async {
    await _houseRepository.joinHouse(
        UserHouse(user.id, id, role), id,user.id);
    await getHouse();
  }
  Future<dynamic> getHouse() async {
    List<dynamic> jsonList = await _houseRepository.getHouseApi(user.email);
   houses = jsonList.map((jsonObject) => House.fromJson(jsonObject)).toList();
    notifyListeners();
  }
  Future<dynamic> createHouse(String name, String information) async {
    String code = generateRandomCode(7);
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    while (await _houseRepository.isHouseExistApi(code)) {
      code = generateRandomCode(7);
    }
    await _houseRepository.createHouse(House(
        id: code,
        name: name,
        date: date.toString(),
        information: information,
        role: true));
    await joinHouse(true, code);
  }
  String generateRandomCode(int length) {
    final random = Random();
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
//record
  Future<dynamic> getAllRecordsByUsersAndHouse() async{
    List<dynamic> response = await _recordRepository.getAllRecordsByUsersAndHouseApi(_house.id, user.id);
    records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    notifyListeners();
  }
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
