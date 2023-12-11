import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/providers/house_provider.dart';
import 'package:untitled1/views/main_view/main_view.dart';

import '../providers/user_provider.dart';
import '../viewmodels/controller/login_view_model.dart';

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
            child: Text('Login'),
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
    LoginViewModel loginModelView = LoginViewModel();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            onChanged: (value) => loginModelView.updateEmail(value),
            decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'example@gmail.com',
                labelText: 'Email *'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            onChanged: (value) => loginModelView.updatePassword(value),
            obscureText: true,
            decoration: const InputDecoration(
                icon: Icon(Icons.password), labelText: 'Password *'),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    if (await loginModelView.condition()) {
                      if (!context.mounted) return;
                      Provider.of<UserProvider>(context, listen: false)
                          .setUser(await loginModelView.getUser());
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

                      prefs.setString(
                          'email',
                          Provider.of<UserProvider>(context, listen: false)
                              .email);
                      prefs.setBool('isLoggedIn', true);
                      Provider.of<HouseProvider>(context, listen: false)
                              .userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      if (await Provider.of<HouseProvider>(context,
                                  listen: false)
                              .isUserHasHouse() ==
                          false) {
                        if (!context.mounted) return;
                        await Provider.of<HouseProvider>(context, listen: false)
                            .createHouse('My house', '');
                      } if (!context.mounted) return;
                      if (!context.mounted) return;
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
                  child: const Text('Login')))
        ],
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
