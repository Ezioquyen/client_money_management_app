import 'package:flutter/cupertino.dart';

import '../models/house.dart';
import '../models/user/user.dart';
import '../views/houseControl/member_group.dart';

class HouseControlViewModel extends ChangeNotifier {
  MemberGroup _memberGroup = MemberGroup.member;
  User user;
  House house;

  MemberGroup get memberGroup => _memberGroup;

  HouseControlViewModel(this.house, this.user);

  set memberGroup(MemberGroup value) {
    _memberGroup = value;
    notifyListeners();
  }
}
