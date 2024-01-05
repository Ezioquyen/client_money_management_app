import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../main.dart';

import '../../../models/house.dart';
import '../../../providers/user_provider.dart';

import '../../../viewModels/main_view_model.dart';
import 'create_house.dart';
import 'join_house.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    MainViewModel mainViewModel = Provider.of<MainViewModel>(context);
    return Drawer(
      child: SizedBox(
        height: 500,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person_outline_rounded),
                    ),
                    Text(
                      Provider.of<UserProvider>(context, listen: false)
                          .username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Selector<MainViewModel,List<House>>(
               selector: (context,myProvider) => myProvider.houses,
              builder: (BuildContext context, houses,
                  child) {

                return SizedBox(
                    height: houses.isNotEmpty
                        ? houses.length * 50
                        : 50,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: houses.isNotEmpty
                          ? houses.length
                          : 1,
                      itemExtent: 50,
                      itemBuilder: (context, index) {
                        return houses.isEmpty
                            ? null
                            : ListTile(
                                onTap: () async {
                                  mainViewModel.updateHouse(houses[index]);
                                  Navigator.pop(context);
                                },
                                leading: const Icon(Icons.house),
                                title: Text(mainViewModel.houses[index].name),
                              );
                      },
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('Tham gia nhà ở'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return  JoinHouse(
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Tạo thêm nhà ở'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const CreateHouse(
                    );
                  },
                );
              },
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Đăng xuất'),
                onTap: () async {
                  Provider.of<MainViewModel>(context, listen: false).removeData();
                 await Provider.of<UserProvider>(context, listen: false).removeUserDeviceToken();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn', false);
                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
