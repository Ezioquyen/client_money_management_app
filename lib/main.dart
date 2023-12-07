import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/providers/house_provider.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/views/login_view.dart';
import 'package:untitled1/views/main_view/main_view.dart';
import 'package:untitled1/views/sign_up_view.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<UserProvider>.value(
        value:
            UserProvider(id: 1, username: 'User', email: 'example@gmail.com'),
      ),
      ChangeNotifierProvider(
        create: (context) => HouseProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Widget view = const HomeView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: Scaffold(backgroundColor: Colors.transparent, body: view),
      ),
    );
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      if (loggedIn) {
        Provider.of<UserProvider>(context, listen: false).username =
            prefs.getString('username')!;
        Provider.of<UserProvider>(context, listen: false).email =
            prefs.getString('email')!;
        Provider.of<UserProvider>(context, listen: false).id =
            int.parse(prefs.getString('id')!);
        view = const MainView();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Welcome'),
      ),
      body: _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text('Login')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpView()));
                },
                child: const Text('SignUp'))
          ],
        ),
      ),
    );
  }
}
