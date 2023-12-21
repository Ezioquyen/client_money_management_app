





import '../../models/user/user.dart';

import '../../repository/login_repository.dart';

class LoginViewModel {
  final _api = LoginRepository();
  late User user;
  String email = 'example@gmail.com';
  String password = '*****';



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
  Future<dynamic> getUser() async{
    user = User.fromJson(await _api.loginApi(email));
  }

}
