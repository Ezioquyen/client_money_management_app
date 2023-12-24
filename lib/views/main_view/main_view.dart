import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/record.dart';

import 'package:untitled1/views/houseControl/house_control_view.dart';
import 'package:untitled1/views/main_view/components/create_record.dart';
import '../../models/house.dart';
import '../../providers/user_provider.dart';
import '../../viewModels/controller/main_view_model.dart';
import 'components/drawer.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainViewModel(UserProvider.toUser(
          Provider.of<UserProvider>(context, listen: false))),
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
  @override
  Widget build(BuildContext context) {
    MainViewModel mainViewModel = Provider.of<MainViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.black12,
      drawer: const MyDrawer(),
      floatingActionButton:  SpeedDial(
          icon: Icons.add,
          onPress: () {
            showModalBottomSheet(
                builder: (BuildContext context) => CreateRecord(
                      mainViewModel:
                          mainViewModel,
                    ),
                context: context);
          },
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        centerTitle: true,
        title: Selector<MainViewModel, House>(
            selector: (context, myModel) => myModel.house,
            builder: (context, house, child) {
              return Text(
                house.name,
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.house),
                tooltip: "Your house",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => HouseControlView(
                              mainViewModel: Provider.of<MainViewModel>(context,
                                  listen: false))));
                }),
            const SizedBox(
              width: 200,
            ),
            const IconButton(
                icon: Icon(Icons.stacked_line_chart),
                tooltip: "Static",
                onPressed: null),
          ],
        ),
      ),
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
                    Provider.of<MainViewModel>(context)
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
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
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
            child: Selector<MainViewModel, List<RecordPayment>>(
                selector: (context, myModel) => myModel.records,
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
                                itemCount:
                                    records.isNotEmpty ? records.length : 1,
                                itemExtent: 70,
                                itemBuilder: (context, index) {
                                  return records.isEmpty
                                      ? null
                                      : record(records[index]);
                                },
                              )),
                        ),
                        const TextButton(
                            onPressed: null, child: Text('Xem them')),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<void> initialModel() async {
    await Provider.of<MainViewModel>(context, listen: false).initial();
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    initialModel();
    // });
  }

// @override
// void didChangeDependencies() {
//   initialModel().whenComplete(() => debugPrint("2OKKKKKKKKKKKKKKKKKKKKKKKK"));
//   super.didChangeDependencies();
//
// }
}
