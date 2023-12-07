import 'package:flutter/foundation.dart';
import 'package:untitled1/models/user/user.dart';
import 'package:untitled1/repository/signup_repository.dart';

class SignUpViewModel extends ChangeNotifier {
  String _rePassword = '******';
  bool _isSigningUp = false;
  bool _isMatchPass = false;
  late UserModel userModel;
  final _signupRepository = SignupRepository();
  bool get isSigningUp => _isSigningUp;

  SignUpViewModel(){
   userModel = UserModel(username: 'Quyen Ezio' ,password: 'quyen@example.com',email:'******', id: 1);
  }

  void updateUsername(String value) {
    userModel.username = value;
  }

  void updateEmail(String value) {
    userModel.email = value;
  }
  void updatePassword(String value) {
    userModel.password = value;
    matchPassword();
  }
  void updateRepass(String value){
    _rePassword = value;
    matchPassword();
  }
  void matchPassword(){
    _isMatchPass = _rePassword==userModel.password;
  }
  Future<bool> canSignUp() async{
    return (await _signupRepository.emailCheckAPI(userModel.email)&&_isMatchPass&&!_isSigningUp);
  }

  Future<void> signUp() async {
    try {
      _isSigningUp = true;
      await _signupRepository.signupAPI(userModel.toJson());
      await Future.delayed(const Duration(seconds: 2));
      _rePassword = '*****';
      userModel = UserModel(username: 'Quyen Ezio' ,password: 'quyen@example.com',email:'******', id: 1);
      _isMatchPass = false;
      _isSigningUp = false;
      if (kDebugMode) {
        print('Sign-up successful');
      }
    } catch (error) {
      _isSigningUp = false;
      if (kDebugMode) {
        print('Sign-up failed: $error');
      }
    }
  }


}
