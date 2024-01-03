import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/record.dart';

import 'package:untitled1/views/houseControl/member_group.dart';

import '../models/user/user.dart';
import 'main_view_model.dart';

class RecordViewModel extends ChangeNotifier {
  bool payerChecker = false;
  late DateTime dateTime;
  MainViewModel mainViewModel;
  List<User> users = [];
  late RecordPayment recordPayment;
  late MemberGroup memberGroup;
  PaymentGroup group = PaymentGroup(id: 0, name: '', houseId: '', userIds: []);

  RecordViewModel(this.mainViewModel, RecordPayment value) {
   recordPayment = RecordPayment(participantIds: value.participantIds, houseId: value.houseId, paymentGroup: value.paymentGroup, id: value.id, money: value.money, date: value.date, information: value.information, paid: value.paid, payerId: value.payerId);
    if (recordPayment.paymentGroup == -1) {
      memberGroup = MemberGroup.member;
    } else if (recordPayment.paymentGroup == 0) {
      memberGroup = MemberGroup.house;
      recordPayment.participantIds.clear();
    } else {
      memberGroup = MemberGroup.group;
      recordPayment.participantIds.clear();
      group = mainViewModel.groups.where((element) => element.id == recordPayment.paymentGroup).first;
    }
    users = mainViewModel.users;


    if (recordPayment.id == 0) {
      dateTime = DateTime.now();
      recordPayment.payerId = mainViewModel.user.id;
      recordPayment.houseId = mainViewModel.house.id;
    } else {
      dateTime = DateTime.parse(recordPayment.date);
    }
    users.removeWhere((element) => element.id == recordPayment.payerId);
    payerChecker = recordPayment.payerId == mainViewModel.user.id;
  }

  void updateDateTime(var value) {
    dateTime = value;
    notifyListeners();
  }

  void updateMemberGroup(var value) {
    memberGroup = value;
    notifyListeners();
  }

  void updateGroup(var value) {
    group = value;
    recordPayment.participantIds.clear();
    notifyListeners();
  }

  void updateParticipant(var value, var index) {
    if (value == true) {
      recordPayment.participantIds.add(users[index].id);
    } else {
      recordPayment.participantIds.remove(users[index].id);
    }
    notifyListeners();
  }

  Future<void> createRecord() async {
    recordPayment.date = DateFormat('y-M-d').format(dateTime);
    switch (memberGroup) {
      case MemberGroup.member:
        {
          recordPayment.paymentGroup = -1;
        }
      case MemberGroup.group:
        {
          recordPayment.participantIds.clear();
          recordPayment.paymentGroup = group.id;
          for (int id in group.userIds) {
            recordPayment.participantIds.add(id);
          }
        }
      case MemberGroup.house:
        {
          recordPayment.participantIds.clear();
          recordPayment.paymentGroup = 0;
          for (User user in users) {
            recordPayment.participantIds.add(user.id);
          }
        }
    }
    recordPayment.participantIds.add(recordPayment.payerId);
    if(recordPayment.id==0) {
      await mainViewModel.createRecord(recordPayment.toJson());
    } else {
      await mainViewModel.saveRecord(recordPayment.toJson(),recordPayment.id);
    }
  }
}
