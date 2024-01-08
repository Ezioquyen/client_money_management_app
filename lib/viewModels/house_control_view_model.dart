

import 'package:flutter/cupertino.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/repository/group_repository.dart';

import '../models/house.dart';
import '../models/user/user.dart';
import '../views/houseControl/member_group.dart';

class HouseControlViewModel extends ChangeNotifier{
  final _groupRepository = GroupRepository();
  MemberGroup _memberGroup = MemberGroup.member;
  List<User> users = [];
  User user;
   House house;
  List<PaymentGroup> groups = [];
  MemberGroup get memberGroup => _memberGroup;

  HouseControlViewModel(this.users, this.house,this.user);

  set memberGroup(MemberGroup value) {
    _memberGroup = value;
    notifyListeners();
  }
  Future<void> getGroups() async{
    List<dynamic> jsonList;
    jsonList = house.role? await _groupRepository.getGroupByHouseApi(house.id): await _groupRepository.getGroupByUserAndHouseApi(house.id,user.id);
   groups = jsonList.map((jsonObject) => PaymentGroup.fromJson(jsonObject)).toList();

  }
}