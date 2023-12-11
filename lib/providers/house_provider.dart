import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/models/user_house.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/repository/house_repository.dart';


class HouseProvider extends ChangeNotifier {
  late UserProvider userProvider;
  final houseRepository = HouseRepository();

  Future<bool> checkUserHouse(UserProvider userProvider, String id) async {
    return await houseRepository.checkUserHouseApi(userProvider.email, id);
  }

  Future<bool> isHouseExist(String id) async {
    return await houseRepository.isHouseExistApi(id);
  }

  Future<dynamic> joinHouse(bool role, String id) async {

    await houseRepository.joinHouse(
        UserHouse(userProvider.id, id, role), id, userProvider.id);
    userProvider.houses = await getHouse(userProvider.email);
    notifyListeners();
  }

  Future<bool> isUserHasHouse() async {
    return await houseRepository.isUserHasHouse(userProvider.id);
  }

  Future<dynamic> createHouse(String name, String information) async {
    String code = generateRandomCode(7);
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    while (await houseRepository.isHouseExistApi(code)) {
      code = generateRandomCode(7);
    }
    await houseRepository.createHouse(House(
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
  Future<dynamic> getHouse(String email) async {
    List<dynamic> jsonList = await houseRepository.getHouseApi(email);
    List<House> houses = jsonList.map((jsonObject) => House.fromJson(jsonObject)).toList();
    return houses;
  }
}
