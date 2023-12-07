import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/models/user_house.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/repository/house_repository.dart';

class MainViewVModel extends ChangeNotifier {
  final _houseApi = HouseRepository();
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

  House get house => _house;


}
