import 'package:flutter/material.dart';
import 'package:untitled1/models/payment_group.dart';

import 'package:untitled1/viewModels/mixins/record_mixins.dart';
import 'package:untitled1/views/recordManagement/record_filter.dart';

import '../../models/record.dart';
import 'main_view_model.dart';



class RecordManagementViewModel extends ChangeNotifier with RecordMixin{
  late MainViewModel mainViewModel;
  PaymentGroup selectedGroup = PaymentGroup();
  bool payerChecker = false;
  RecordFilter recordFilter = RecordFilter.all;
  Future<void> initialModel(MainViewModel mainViewModel) async{
    this.mainViewModel = mainViewModel;
    user = mainViewModel.user;
    selectedDate = mainViewModel.selectedDate;
    dateList = mainViewModel.dateList;
    records = mainViewModel.records;
    house = mainViewModel.house;
    groups = mainViewModel.groups;
    if(groups.isNotEmpty) selectedGroup = groups[0];
  }

  void updateRecordFilter(RecordFilter newValue) async {
    recordFilter = newValue;
    await updateRecords();

  }

  void updateGroup(PaymentGroup group) async {
    selectedGroup = group;
    await updateRecords();

  }

  void updatePayerChecker(var value) async {
    payerChecker = value;
    await updateRecords();

  }
  Future<void> updateRecords() async{
    if(payerChecker){
      await updateRecordByPayer();
    } else {
      await updateRecordWithoutPayer();
    }
    notifyListeners();
  }
  Future<void> updateRecordByPayer() async {
    switch (recordFilter) {
      case RecordFilter.house:
        await getRecordsByPayerAndHouse();
      case RecordFilter.other:
       await getRecordsByPayerOther();
      case RecordFilter.all:
      await getAllRecordsByPayerAndHouse();
      case RecordFilter.group:
      await getRecordsByPayerAndGroup();
    }
  }
  Future<void> updateRecordWithoutPayer() async{
    switch (recordFilter) {
      case RecordFilter.house:
        await getRecordsByHouseForAllMember();
      case RecordFilter.other:
        await getRecordsByUserOther();
      case RecordFilter.all:
        await getAllRecordsByUsersAndHouse();
      case RecordFilter.group:
        await getRecordsByUsersAndGroup();
    }
  }
  Future<dynamic> getRecordsByPayerAndGroup() async {
    List<dynamic> response =
    await recordRepository.getRecordsByPayerAndGroupApi(
        house.id,
        user.id,
        selectedGroup.id,
        selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    records = response
        .map((jsonObject) => RecordPayment.fromJson(jsonObject))
        .toList();
  }

  Future<dynamic> getRecordsByPayerOther() async {
    List<dynamic> response = await recordRepository.getRecordsByPayerOtherApi(
        house.id,
        user.id,
        selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    records = response
        .map((jsonObject) => RecordPayment.fromJson(jsonObject))
        .toList();
  }

  Future<dynamic> getRecordsByUserOther() async {
    List<dynamic> response = await recordRepository.getRecordsByUserOtherApi(
        house.id,
        user.id,
        selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    records = response
        .map((jsonObject) => RecordPayment.fromJson(jsonObject))
        .toList();
  }

  Future<dynamic> getRecordsByHouseForAllMember() async {
    List<dynamic> response =
    await recordRepository.getRecordsByHouseForAllMemberApi(
        house.id,
        selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    records = response
        .map((jsonObject) => RecordPayment.fromJson(jsonObject))
        .toList();
  }

  Future<dynamic> getRecordsByPayerAndHouse() async {
    List<dynamic> response =
    await recordRepository.getRecordsByPayerAndHouseApi(
        house.id,
        user.id,
        selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    records = response
        .map((jsonObject) => RecordPayment.fromJson(jsonObject))
        .toList();
  }
  Future<dynamic> getAllRecordsByPayerAndHouse(
      ) async {
    List<dynamic> response =
    await recordRepository.getAllRecordsByPayerAndHouseApi(
        house.id,
        user.id,
        selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    records = response
        .map((jsonObject) => RecordPayment.fromJson(jsonObject))
        .toList();
  }
  Future<dynamic> getRecordsByUsersAndGroup() async {
    List<dynamic> response =
    await recordRepository.getRecordsByUsersAndGroupApi(
        house.id,
        user.id,
        selectedGroup.id,
        selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    records = response
        .map((jsonObject) => RecordPayment.fromJson(jsonObject))
        .toList();
  }
  @override

  Future<void> updateDate(date) async {
    selectedDate = date;
    updateRecords();
    notifyListeners();
  }
}