import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/viewmodels/controller/main_view_vm.dart';

import '../../../main.dart';
import '../../../providers/house_provider.dart';
import '../../../providers/record_provider.dart';
import '../../../providers/user_provider.dart';
import 'create_house.dart';
import 'join_house.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
            Container(
              height: Provider.of<UserProvider>(context).houses.isNotEmpty
                  ? Provider.of<UserProvider>(context).houses.length * 50
                  : 50,
              child: Consumer<HouseProvider>(
                builder:
                    (BuildContext context, HouseProvider value, Widget? child) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        Provider.of<UserProvider>(context).houses.isNotEmpty
                            ? Provider.of<UserProvider>(context).houses.length
                            : 1,
                    itemExtent: 50,
                    itemBuilder: (context, index) {
                      return Provider.of<UserProvider>(context).houses.isEmpty
                          ? null
                          : ListTile(
                              onTap: () async{
                                await Provider.of<MainViewVModel>(context,listen: false).updateUsers(Provider.of<UserProvider>(context,listen: false).houses[index].id);

                                if(!context.mounted)return;

                                Provider.of<UserProvider>(context, listen: false).records =
                                    await Provider.of<RecordProvider>(context, listen: false)
                                    .getAllRecordsByUsersAndHouse(
                                        Provider.of<UserProvider>(context,listen: false).houses[index].id,
                                    Provider.of<UserProvider>(context, listen: false).id);

                                if(!context.mounted)return;

                                Provider.of<MainViewVModel>(context,listen: false).house = Provider.of<UserProvider>(context,listen: false).houses[index];
                                Navigator.pop(context);
                                },
                              leading: const Icon(Icons.house),
                              title: Text(Provider.of<UserProvider>(context,listen: false)
                                  .houses[index]
                                  .name),
                            );
                    },
                  );
                },
              ),
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
                    return const JoinHouse();
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
                    return const CreateHouse();
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
