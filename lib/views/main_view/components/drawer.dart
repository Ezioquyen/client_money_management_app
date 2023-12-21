import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/viewmodels/controller/main_view_vm.dart';

import '../../../main.dart';

import '../../../models/house.dart';
import '../../../providers/user_provider.dart';
import 'create_house.dart';
import 'join_house.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    MainViewVModel mainViewVModel = Provider.of<MainViewVModel>(context);
    return Drawer(
      child: Container(
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
            Selector<MainViewVModel,List<House>>(
               selector: (context,myProvider)=>myProvider.houses,
              builder: (BuildContext context, houses,
                  child) {
                return Container(
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
                                  mainViewVModel.house = houses[index];
                                  await mainViewVModel.updateUsers();
                                  if (!context.mounted) return;
                                  await mainViewVModel
                                      .getAllRecordsByUsersAndHouse();
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                                leading: const Icon(Icons.house),
                                title: Text(mainViewVModel.houses[index].name),
                              );
                      },
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text('Join'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return JoinHouse(
                      mainViewVModel: mainViewVModel,
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Create new house'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return CreateHouse(
                      mainViewVModel: mainViewVModel,
                    );
                  },
                );
              },
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: () async {
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
