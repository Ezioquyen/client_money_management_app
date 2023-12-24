import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/record.dart';
import 'package:untitled1/viewModels/controller/main_view_model.dart';
import 'package:untitled1/views/houseControl/member_group.dart';


import '../../models/user/user.dart';



class CreateRecordModel extends ChangeNotifier {
    DateTime dateTime = DateTime.now();
    MainViewModel mainViewModel;
     List<User> users =[];
     RecordPayment recordPayment = RecordPayment(participantIds: [], houseId: '', paymentGroup: 0, id: 0, money: 0, date: '', information: '', paid: false, payerId: 0);
    MemberGroup memberGroup = MemberGroup.member;
    PaymentGroup group = PaymentGroup(id: 0, name: '', houseId: '', userIds: []);
    CreateRecordModel(this.mainViewModel){
      users = mainViewModel.users;
      users.removeWhere((element) => element.id==mainViewModel.user.id);
      recordPayment.houseId = mainViewModel.house.id;
      recordPayment.payerId = mainViewModel.user.id;

    }
    void updateDateTime(var value){
      dateTime = value;
      notifyListeners();
    }
    void updateMemberGroup(var value){
      memberGroup = value;
      notifyListeners();
    }
    void updateGroup(var value){
      group = value;
      notifyListeners();
    }
    void updateParticipant(var value, var index){
      if (value == true) {
            recordPayment
            .participantIds
            .add(
            users[index]
            .id);
      } else {
        recordPayment
            .participantIds
            .remove(
         users[index]
                .id);
      }
      notifyListeners();
    }
    Future<void> createRecord()async{
      recordPayment.date= DateFormat('d/M/y').format(dateTime);
      switch(memberGroup){
        case MemberGroup.member:{
          recordPayment.paymentGroup = -1;
        }
        case MemberGroup.group:{
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
      await mainViewModel.createRecord(recordPayment.toJson());
    }

}