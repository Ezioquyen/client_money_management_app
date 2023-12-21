import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/record.dart';

import 'package:untitled1/viewmodels/controller/main_view_vm.dart';
import 'package:untitled1/views/houseControl/house_control_view.dart';
import 'package:untitled1/views/splash_screen.dart';
import '../../providers/user_provider.dart';
import 'components/drawer.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainViewVModel(),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: const MainViewChild(),
      ),
    );
  }
}

class MainViewChild extends StatefulWidget {
  const MainViewChild({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainViewChildState();
  }
}

class MainViewChildState extends State<MainViewChild> {
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return !isLoaded
        ? const SplashScreen()
        : Scaffold(
            backgroundColor: Colors.transparent,
            drawer: const MyDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title:
                  Consumer<MainViewVModel>(builder: (context, myModel, child) {
                return Text(
                  Provider.of<MainViewVModel>(context).house.name,
                  style: const TextStyle(
                      fontSize: 17, color: Colors.white, letterSpacing: 0.53),
                );
              }),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              leading: Builder(
                  builder: (context) => InkWell(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: const Icon(
                          Icons.subject,
                          color: Colors.white,
                        ),
                      )),
              actions: [
                InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.notifications,
                      size: 20,
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(110.0),
                  child: getAppBottomView(Provider.of<UserProvider>(context))),
            ),
            body: showRecord(),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Your house',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Tạo chi tiêu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.stacked_line_chart),
                  label: 'Thống kê',
                ),
              ],
              onTap: (int index) {
                if(index==0){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (c) => HouseControlView(
                  mainViewVModel: Provider.of<MainViewVModel>(context,listen: false),
                ),
                ));
              }
              },
            ),
            floatingActionButton: const FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }



  Widget getAppBottomView(UserProvider user) {
    return Container(
      padding: const EdgeInsets.only(left: 30, bottom: 20),
      child: Row(
        children: [
          getProfileView(),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white),
                ),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'chi: 50000',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getProfileView() {
    return const Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white,
          child: Icon(Icons.person_outline_rounded),
        ),
      ],
    );
  }

  Widget record(RecordPayment recordPayment) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_outline_rounded),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Provider.of<MainViewVModel>(context)
                        .usersById[recordPayment.payerId]!
                        .username,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent),
                  ),
                  Text(
                    '${recordPayment.money} đ - ${recordPayment.information}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showRecord() {
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Set the number of buttons
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Add your button action here
                          print('Button $index pressed');
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Text(
                                  '$index',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Text('$index'),
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
          Expanded(
            child: Selector<MainViewVModel,List<RecordPayment>>(
                selector: (context,myModel)=>myModel.records,
                builder: (context, records, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 350,
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: records.isNotEmpty
                                ? records.length
                                : 1,
                            itemExtent: 70,
                            itemBuilder: (context, index) {
                              return records.isEmpty
                                  ? null
                                  : record(records[index]);
                            },
                          )),
                    ),
                    const TextButton(onPressed: null, child: Text('Xem them')),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Future<void> defineState() async {
    Provider.of<MainViewVModel>(context, listen: false).user =
        UserProvider.toUser(Provider.of<UserProvider>(context, listen: false));
    if (await Provider.of<MainViewVModel>(context, listen: false)
        .isUserHasHouse() ==
        false) {
      if (!context.mounted) return;
      await Provider.of<MainViewVModel>(context, listen: false)
          .createHouse('My house', '');
    }
    if (!context.mounted) return;
    await Provider.of<MainViewVModel>(context, listen: false).getHouse();
    if (!context.mounted) return;
    Provider.of<MainViewVModel>(context, listen: false).house =
        Provider.of<MainViewVModel>(context, listen: false).houses.first;
    Provider.of<MainViewVModel>(context, listen: false).updateUsers();
    await Provider.of<MainViewVModel>(context, listen: false)
        .getAllRecordsByUsersAndHouse();


    isLoaded = true;
    Future.delayed(const Duration(seconds: 5));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    defineState();
  }
}
