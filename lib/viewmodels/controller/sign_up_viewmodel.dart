import 'package:flutter/foundation.dart';
import 'package:untitled1/repository/signup_repository.dart';

class SignUpViewModel extends ChangeNotifier {
  String username = 'Quyen Ezio';
  String password = 'DemoPassword';
  String email = 'quyen@example.com';
  String _rePassword = '******';
  bool _isSigningUp = false;
  bool _isMatchPass = false;

  final _signupRepository = SignupRepository();
  bool get isSigningUp => _isSigningUp;
  void updateUsername(String value) {
  username = value;
  }

  void updateEmail(String value) {
    email = value;
  }
  void updatePassword(String value) {
    password = value;
    matchPassword();
  }
  void updateRepass(String value){
    _rePassword = value;
    matchPassword();
  }
  void matchPassword(){
    _isMatchPass = _rePassword== password;
  }
  Future<bool> canSignUp() async{
    return (await _signupRepository.emailCheckAPI(email)&&_isMatchPass&&!_isSigningUp);
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
  Future<void> signUp() async {
    try {
      _isSigningUp = true;
      await _signupRepository.signupAPI(toJson());
      await Future.delayed(const Duration(seconds: 2));
      _rePassword = '*****';
       username = 'Quyen Ezio' ;
      password = 'demoPassword';
      email = 'quyen@example.com';
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
