import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/viewModels/main_view_model.dart';

import '../models/user/user.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

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
            child: Text('Personal'),
          ),
        ),
        body: const PersonalPageBodyWidget(),
      ),
    );
  }
}

class PersonalPageBodyWidget extends StatefulWidget {
  const PersonalPageBodyWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BodyWidgetState();
  }
}

class _BodyWidgetState extends State<PersonalPageBodyWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'example@email.com',
                              labelText: 'Email *')),
                      TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.supervised_user_circle),
                              hintText: 'username',
                              labelText: 'Tên đăng nhập')),
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
                        User newUser = User();
                        newUser.id =
                            Provider.of<MainViewModel>(context, listen: false)
                                .user
                                .id;
                        newUser.email = emailController.text;
                        newUser.username = usernameController.text;
                        await Provider.of<MainViewModel>(context, listen: false)
                            .updateUserInformation(newUser);
                        if (!context.mounted) return;
                        Provider.of<UserProvider>(context, listen: false)
                            .email = emailController.text;
                        Provider.of<UserProvider>(context, listen: false)
                            .username = usernameController.text;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Lưu',
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

  @override
  void initState() {
    super.initState();
    emailController.text =
        Provider.of<MainViewModel>(context, listen: false).user.email;
    usernameController.text =
        Provider.of<MainViewModel>(context, listen: false).user.username;
  }
}
