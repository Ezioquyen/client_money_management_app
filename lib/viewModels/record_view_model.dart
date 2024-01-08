import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/record.dart';
import 'package:untitled1/repository/user_repository.dart';

import 'package:untitled1/views/houseControl/member_group.dart';

import '../models/user/user.dart';
import '../repository/notification_repository.dart';
import 'main_view_model.dart';

class RecordViewModel extends ChangeNotifier {
  final _notificationRepository = NotificationRepository();
  final _userRepository = UserRepository();
  bool payerChecker = false;
  late DateTime dateTime;
  MainViewModel mainViewModel;
  List<User> users = [];
  late RecordPayment recordPayment;
  late Set<int> receiveNotifyList = {};
  late MemberGroup memberGroup;
  PaymentGroup group = PaymentGroup(id: 0, name: '', houseId: '', userIds: []);

  RecordViewModel(this.mainViewModel, RecordPayment value) {
    recordPayment = RecordPayment(
        participantIds: value.participantIds,
        houseId: value.houseId,
        paymentGroup: value.paymentGroup,
        id: value.id,
        money: value.money,
        date: value.date,
        information: value.information,
        paid: value.paid,
        payer: value.payer);
    receiveNotifyList.addAll(recordPayment.participantIds);
    if (recordPayment.paymentGroup == -1) {
      memberGroup = MemberGroup.member;
    } else if (recordPayment.paymentGroup == 0) {
      memberGroup = MemberGroup.house;
      recordPayment.participantIds.clear();
    } else {
      memberGroup = MemberGroup.group;
      recordPayment.participantIds.clear();
      group = mainViewModel.groups
          .where((element) => element.id == recordPayment.paymentGroup)
          .first;
    }
    if (recordPayment.id == '') {
      dateTime = DateTime.now();
      recordPayment.payer = mainViewModel.user;
      recordPayment.houseId = mainViewModel.house.id;
    } else {
      dateTime = DateTime.parse(recordPayment.date);
    }
    payerChecker =  recordPayment.payer.id == mainViewModel.user.id;
  }

  Future<void> updateUsers() async {
    List<dynamic> jsonList = await _userRepository.getUserByDateApi(
        recordPayment.houseId, DateFormat('yyyy-MM-dd').format(dateTime));
    users = jsonList.map((jsonObject) => User.fromJson(jsonObject)).toList();
    users.removeWhere((element) => element.id == recordPayment.payer.id);
    notifyListeners();
  }

  void updateDateTime(var value) {
    dateTime = value;
    updateUsers();
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
    recordPayment.date = DateFormat('yyyy-MM-dd').format(dateTime);
    switch (memberGroup) {
      case MemberGroup.member:
        {
          recordPayment.paymentGroup = -1;
          recordPayment.participantIds.add(recordPayment.payer.id);
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
          recordPayment.participantIds.add(recordPayment.payer.id);
        }
    }
    receiveNotifyList.addAll(recordPayment.participantIds);
    receiveNotifyList.removeWhere((element) => element==recordPayment.payer.id);

    if (recordPayment.id == '') {
      recordPayment.id =
          '${DateFormat("sshhmmddMMyyyy").format(DateTime.now())}${recordPayment.payer.id}';
      await _notificationRepository.createNotification({
        "deepLink": "record/${recordPayment.id}",
        "title": "Ghi chép được tạo từ nhà trọ ${mainViewModel.house.name}",
        "name": "RecordCreated",
        "isRead": false,
        "time":
            DateFormat("ss:mm:HH dd/MM/yyyy").format(DateTime.now()).toString(),
        "notificationText":
            "Bản ghi chép chi tiêu được tạo bởi ${recordPayment.payer.username}",
        "userIds": receiveNotifyList.toList()
      });
    } else {
      await _notificationRepository.createNotification({
        "deepLink": "record/${recordPayment.id}",
        "title": "Ghi chép được sửa từ nhà trọ ${mainViewModel.house.name}",
        "name": "RecordCreated",
        "isRead": false,
        "time":
            DateFormat("ss:mm:HH dd/MM/yyyy").format(DateTime.now()).toString(),
        "notificationText":
            "Bản ghi chép chi tiêu được sửa bởi ${recordPayment.payer.username}",
        "userIds": receiveNotifyList.toList()
      });
    }
    await mainViewModel.saveRecord(recordPayment.toJson(), recordPayment.id);
  }
}
