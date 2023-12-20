

import 'package:flutter/cupertino.dart';

import '../../views/houseControl/member_group.dart';

class HouseControlViewModel extends ChangeNotifier{
  MemberGroup _memberGroup = MemberGroup.member;

  MemberGroup get memberGroup => _memberGroup;

  set memberGroup(MemberGroup value) {
    _memberGroup = value;
    notifyListeners();
  }
}