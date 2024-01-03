import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/views/main_view/main_view.dart';

import '../providers/user_provider.dart';
import '../viewModels/login_view_model.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Center(
            child: Text('ĐĂNG NHẬP'),
          ),
        ),
        body: const LoginPageBodyWidget(),
      ),
    );
  }
}

class LoginPageBodyWidget extends StatefulWidget {
  const LoginPageBodyWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BodyWidgetState();
  }
}

class _BodyWidgetState extends State<LoginPageBodyWidget> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    LoginViewModel loginViewModel = LoginViewModel();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) => loginViewModel.updateEmail(value),
                        decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'example@gmail.com',
                            labelText: 'Email *'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onChanged: (value) =>
                            loginViewModel.updatePassword(value),
                        obscureText: true,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.password),
                            labelText: 'Mật khẩu *'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (await loginViewModel.condition()) {
                          if (!context.mounted) return;
                          await loginViewModel.getUser();
                          userProvider.setUser(loginViewModel.user);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (!context.mounted) return;
                          prefs.setString(
                              'username',
                              Provider.of<UserProvider>(context, listen: false)
                                  .username);

                          prefs.setString(
                              'id',
                              Provider.of<UserProvider>(context, listen: false)
                                  .id
                                  .toString());
                          prefs.setString('email', userProvider.email);
                          prefs.setBool('isLoggedIn', true);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainView()),
                            (route) => false,
                          );
                        } else {
                          if (!context.mounted) return;
                          showSimpleSnackBar(context);
                        }
                      },
                      child: const Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void showSimpleSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Wrong password'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
