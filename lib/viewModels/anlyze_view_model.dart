import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/repository/analytics_repository.dart';
import 'package:untitled1/repository/record_repository.dart';

import '../models/user/user.dart';

class AnalyzeViewModel extends ChangeNotifier {
  final _analyticRepository = AnalyticRepository();
  final _recordRepository = RecordRepository();
  late House house;
  late User user;
   String selectedDate = '01/2000';
  List<String> dateList = [];

  List<Map<String, dynamic>> totalFeeByMonth = [];

  List<Map<String, dynamic>> totalPaidByMonth = [];

  List<Map<String, dynamic>> paidForByMonth = [];

  List<Map<String, dynamic>> feeFromByMonth = [];
  List<Map<String, dynamic>> calculated = [];

  Future<void> initialize(House house, User user) async {
    this.house = house;
    this.user = user;
    await getPaidByMonth();
    List<dynamic> dateObjects =
        await _recordRepository.getDateOfRecordsApi(house.id);
    for (dynamic element in dateObjects) {
      dateList.add(element.toString());
    }
    if(dateList.isNotEmpty) {
      selectedDate = dateList[0];
    }else {
      selectedDate = DateFormat("MM/yyyy").format(DateTime.now());
    }
    await getFeeFromByMonth();
    await getPaidForByMonth();
    await getFeeByMonth();
    await calculate();
    notifyListeners();
  }

  Future<void> getPaidByMonth() async {
    List<dynamic> response =
        await _analyticRepository.getTotalPaidByMonth(house.id, user.id);
    totalPaidByMonth =
        response.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> getFeeByMonth() async {
    List<dynamic> response =
        await _analyticRepository.getTotalFeeByMonth(house.id, user.id);
    totalFeeByMonth =
        response.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> getFeeFromByMonth() async {
    List<dynamic> response = await _analyticRepository.getFeeFromByMonth(
        house.id, user.id, selectedDate);
    feeFromByMonth =
        response.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> getPaidForByMonth() async {
    List<dynamic> response = await _analyticRepository.getPaidForByMonth(
        house.id, user.id, selectedDate);
    paidForByMonth =
        response.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> calculate() async {
    List<dynamic> response =
        await _analyticRepository.calculate(house.id, selectedDate);
    calculated =
        response.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> updateDate(date) async {
    selectedDate = date;
    await getPaidForByMonth();
    await getFeeFromByMonth();
    await calculate();
    notifyListeners();
  }
}
