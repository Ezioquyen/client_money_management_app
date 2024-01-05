import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/models/payment_group.dart';

import 'package:untitled1/repository/group_repository.dart';

import 'package:untitled1/repository/house_repository.dart';
import 'package:untitled1/viewModels/mixins/record_mixins.dart';

import '../models/user/user.dart';
import '../models/user_house.dart';
import '../repository/notification_repository.dart';

class MainViewModel extends ChangeNotifier with RecordMixin {
  final _notification = NotificationRepository();
  final _houseRepository = HouseRepository();
  final _groupRepository = GroupRepository();
  int unreadNotify = 0;
  List<User> users = [];
  Map<int, User> usersById = {};
  List<House> houses = [];

  Future<void> updateHouse(House value) async {
    usersById.clear();
    house = value;
    records = [];
    await updateUsers();
    await getGroups();
    dateList = await recordRepository.getDateOfRecordsApi(house.id);
    if (dateList.isEmpty) {
      await updateDate("${DateTime.now().month}/${DateTime.now().year}");
    } else {
      await updateDate(dateList[0]);
    }
    notifyListeners();
  }

  Future<void> updateUsers() async {
    List<dynamic> jsonList =
        await _houseRepository.getUsersByHouseApi(house.id);
    users = jsonList.map((jsonObject) => User.fromJson(jsonObject)).toList();
    for (User user in users) {
      usersById[user.id] = user;
    }
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
    await _houseRepository.joinHouse(UserHouse(user.id, id, role), id, user.id);
    await getHouses();
  }

  Future<dynamic> getHouses() async {
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
    print(unreadNotify);
    notifyListeners();
  }

  Future<dynamic> getRecordById(String id) async {
    return recordRepository.getRecordById(id);
  }

  void removeData() {
    unreadNotify = 0;
    users = [];
    usersById = {};
    houses = [];
    paid = 0;
    debt = 0;
    user = User(id: 0, username: 'user', email: 'example@gmail.com');
    selectedDate = "${DateTime.now().month}/${DateTime.now().year}";
    groups = [];
    dateList = [];
    records = [];
    house = House(
        id: '',
        name: 'Loading',
        information: '',
        role: true,
        date: '06/12/2023');
  }
}
