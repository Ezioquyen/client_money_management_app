import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/models/payment_group.dart';

import 'package:untitled1/repository/group_repository.dart';

import 'package:untitled1/repository/house_repository.dart';
import 'package:untitled1/repository/user_repository.dart';
import 'package:untitled1/viewModels/mixins/record_mixins.dart';

import '../models/user/user.dart';
import '../repository/notification_repository.dart';

class MainViewModel extends ChangeNotifier with RecordMixin {
  final _notification = NotificationRepository();
  final _houseRepository = HouseRepository();
  final _groupRepository = GroupRepository();
  final _userRepository = UserRepository();
  int unreadNotify = 0;
  List<User> users = [];
  List<House> houses = [];
  List<PaymentGroup> allHouseGroup = [];

  Future<void> updateHouse(House value) async {
    house = value;
    records = [];
    await updateUsers();
    await getGroups();

    await getGroupInHouse();

    dateList = await recordRepository.getDateOfRecordsApi(house.id);
    if (dateList.isEmpty) {
      await updateDate(DateFormat('MM/yyyy').format(DateTime.now()));
    } else {
      await updateDate(dateList[0]);
    }
    notifyListeners();
  }

  Future<void> updateUsers() async {
    List<dynamic> jsonList = await _userRepository.getUserByDateApi(
        house.id, DateFormat('yyyy-MM-dd').format(DateTime.now()));
    users = jsonList.map((jsonObject) => User.fromJson(jsonObject)).toList();
  }

  Future<void> initial(User user) async {
    this.user = user;
    if (!await _houseRepository.isUserHasHouse(user.id)) {
      createHouse('My house', '');
    } else {
      await getHouses();
    }
    await updateHouse(houses.first);
    getUnreadNotify();
    FirebaseMessaging.onMessage.listen((event) async {
      await getUnreadNotify();
    });
  }

  Future<dynamic> joinHouse(bool role, String id) async {
    await _houseRepository.joinHouse({
      'id': {'houseId': id, 'userId': user.id},
      "house": {"id": id},
      "user": {"id": user.id},
      'userRole': role,
      'joinDate': DateFormat('yyyy-MM-dd').format(DateTime.now())
    });
    await getHouses();
    await updateHouse(houses.first);
  }

  Future<dynamic> getHouses() async {
    List<dynamic> jsonList = await _houseRepository.getHouseApi(user.id);
    houses = jsonList.map((jsonObject) => House.fromJson(jsonObject)).toList();
    notifyListeners();
  }

  Future<dynamic> createHouse(String name, String information) async {
    String code = generateRandomCode(7);
    while (await _houseRepository.isHouseExistApi(code)) {
      code = generateRandomCode(7);
    }
    await _houseRepository.createHouse(House(
        id: code,
        name: name,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
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

  Future<void> getGroups() async {
    List<dynamic> jsonList;

    jsonList =
        await _groupRepository.getGroupByUserAndHouseApi(house.id, user.id);
    groups = jsonList
        .map((jsonObject) => PaymentGroup.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<void> updateDate(date) async {
    await super.updateDate(date);
    notifyListeners();
  }

  @override
  Future<dynamic> saveRecord(var data, var id) async {
    await super.saveRecord(data, id);
    dateList = await recordRepository.getDateOfRecordsApi(house.id);
    if (dateList.isEmpty) {
      await updateDate("${DateTime.now().month}/${DateTime.now().year}");
    } else {
      await updateDate(dateList[0]);
    }
  }

  Future<dynamic> getUnreadNotify() async {
    unreadNotify = await _notification.getUnreadNotificationByUser(user.id);
    notifyListeners();
  }

  Future<dynamic> getRecordById(String id) async {
    return recordRepository.getRecordById(id);
  }

  Future<dynamic> getRemovedRecordById(String id) async {
    return recordRepository.getRemovedRecordById(id);
  }

  void removeData() {
    unreadNotify = 0;
    users = [];

    houses = [];
    paid = 0;
    debt = 0;
    user = User(username: 'user', email: 'example@gmail.com');
    selectedDate = "${DateTime.now().month}/${DateTime.now().year}";
    groups = [];
    dateList = [];
    records = [];
    house = House(
      name: 'Loading',
    );
  }

  void notify() {
    notifyListeners();
  }

  Future<dynamic> removeUser(int id) async {
    await _userRepository.leaveHouse(
        house.id, id, DateFormat('yyyy-MM-dd').format(DateTime.now()));
    await updateUsers();
    if(id == user.id) {
      await getHouses();
      await updateHouse(houses.first);
    }else {
      notifyListeners();
    }
  }

  Future<void> getGroupInHouse() async {
    List<dynamic> jsonList;
    jsonList = await _groupRepository.getGroupByHouseApi(house.id);

    allHouseGroup = jsonList
        .map((jsonObject) => PaymentGroup.fromJson(jsonObject))
        .toList();
  }

  Future<void> removeGroup(int id) async {
    await _groupRepository.removeGroupByHouseApi(id);
    await getGroups();
    await getGroupInHouse();
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    await _houseRepository.updateName(house.id, name);
    House newHouse = House();
    newHouse.name = name;
    newHouse.id = house.id;
    newHouse.role = house.role;
    newHouse.information = house.information;
    newHouse.date = house.date;
    getHouses();
    await updateHouse(newHouse);
    notifyListeners();
  }

  Future<void> updateUserInformation(User newUser) async {
    await _userRepository.updateInformationApi(newUser);
    await updateUsers();

    user = newUser;
    await getAllRecordsByUsersAndHouse();
    notifyListeners();
  }
}
