
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModels/sign_up_view_model.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

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
          title: const Text('ĐĂNG KÝ'),
        ),
        body: ChangeNotifierProvider(
          create: (context) => SignUpViewModel(),
          child: const SignUpPageBodyWidget(),
        ),
      ),
    );
  }
}

class SignUpPageBodyWidget extends StatefulWidget {
  const SignUpPageBodyWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BodyWidgetState();
  }
}

class _BodyWidgetState extends State<SignUpPageBodyWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController rePassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
   SignUpViewModel signUpViewModel = SignUpViewModel();
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
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                          onChanged: (value) => signUpViewModel.updateEmail(value),
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'example@email.com',
                              labelText: 'Email *')),
                      TextFormField(
                          controller: usernameController,
                          onChanged: (value) => signUpViewModel.updateUsername(value),
                          decoration: const InputDecoration(
                              icon: Icon(Icons.supervised_user_circle),
                              hintText: 'username',
                              labelText: 'Tên đăng nhập')),
                      TextFormField(
                          obscureText: true,
                          controller: passController,
                          onChanged: (value) => signUpViewModel.updatePassword(value),
                          decoration: const InputDecoration(
                              hintText: '*****',
                              icon: Icon(Icons.password),
                              labelText: 'Mật khẩu *')),
                      TextFormField(
                          obscureText: true,
                          controller: rePassController,
                          onChanged: (value) => signUpViewModel.updateRepass(value),
                          decoration: const InputDecoration(
                              icon: Icon(Icons.password_rounded),
                              hintText: '*****',
                              labelText: 'Nhập lại mật khẩu *')),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ElevatedButton(
                    onPressed: () async {
                      if(await signUpViewModel.canSignUp()) {
                        rePassController.clear();
                        emailController.clear();
                        passController.clear();
                        usernameController.clear();
                        if (!context.mounted) return;
                        await signUpViewModel.signUp();
                        if (!context.mounted) return;
                        showSimpleSnackBar(context,'Signup Successful');
                      } else {
                        if (!context.mounted) return;
                        showSimpleSnackBar(context, 'Sign up Error');
                      }
                    },
                    child: const Text("ĐĂNG KÝ",style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSimpleSnackBar(BuildContext context,String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
