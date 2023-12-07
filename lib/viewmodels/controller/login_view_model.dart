import 'dart:math';

import 'package:untitled1/models/house.dart';
import 'package:untitled1/models/user/user.dart';
import 'package:untitled1/repository/house_repository.dart';
import '../../repository/login_repository.dart';

class LoginViewModel {
  final _api = LoginRepository();
  String email = 'example@gmail.com';
  String password = '*****';

  LoginViewModel();

  void updateEmail(String value) {
    email = value;
  }

  void updatePassword(String value) {
    password = value;
  }

  Future<bool> condition() async {
    return (await _api.emailCheckApi(email) &&
        await _api.passwordCheckApi(email, password));
  }
  Future<dynamic> getUser()async{
    return _api.loginApi(email);
  }

}
