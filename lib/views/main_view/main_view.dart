import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/record.dart';

import 'package:untitled1/views/houseControl/house_control_view.dart';
import 'package:untitled1/views/main_view/components/record_view.dart';
import 'package:untitled1/views/recordManagement/record_management_view.dart';
import '../../models/house.dart';
import '../../providers/user_provider.dart';

import '../../viewModels/main_view_model.dart';
import 'components/drawer.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainViewModel(),
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
    return Scaffold(
      backgroundColor: Colors.black12,
      drawer: const MyDrawer(),
      bottomNavigationBar: Container(
        height: 60,
        child: BottomAppBar(
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
                            builder: (c) => const HouseControlView()));
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
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        onPress: () {
          showModalBottomSheet(
              builder: (BuildContext context) => RecordView(
                    recordPayment: RecordPayment(
                        participantIds: [],
                        houseId: '',
                        paymentGroup: -1,
                        id: 0,
                        money: 0,
                        date: '',
                        information: '',
                        paid: false,
                        payerId: 0),
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
            preferredSize: const Size.fromHeight(90),
            child: getAppBottomView(Provider.of<UserProvider>(context))),
      ),
      body: showRecord(),
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
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_outline_rounded),
          ),
          SizedBox(
            width: 4,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Provider.of<MainViewModel>(context)
                      .usersById[recordPayment.payerId]!
                      .username,
                  style: TextStyle(fontSize: 20, color: Colors.deepPurple[600]),
                ),
                Text(
                  recordPayment.information,
                ),
                Row(
                  children: [
                    Text(
                      recordPayment.date.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
                    ),
                    Text(
                      '| ${NumberFormat('###,###').format(recordPayment.money)}đ',
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget showRecord() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15, top: 8),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
                height: 90,
                child: Selector<MainViewModel, List<dynamic>>(
                    selector: (context, myModel) => myModel.dateList,
                    builder: (context, dateList, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dateList.isEmpty ? 1 : dateList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => dateList.isEmpty
                                  ? null
                                  : Provider.of<MainViewModel>(context,
                                          listen: false)
                                      .updateDate(dateList[index]),
                              child: Column(
                                children: [
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepPurple[200],
                                    ),
                                    child: Center(
                                      child: Text(
                                        dateList.isEmpty
                                            ? Provider.of<MainViewModel>(
                                                    context,
                                                    listen: false)
                                                .selectedDate
                                                .toString()
                                                .split('/')[0]
                                            : dateList[index]
                                                .toString()
                                                .split('/')[0],
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                  Text(dateList.isEmpty
                                      ? Provider.of<MainViewModel>(context,
                                              listen: false)
                                          .selectedDate
                                          .toString()
                                      : dateList[index].toString()),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    })),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 370,
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8),
                          child: Row(
                            children: [
                              Selector<MainViewModel, int>(
                                  selector: (context, myModel) => myModel.paid,
                                  builder: (context, paid, child) {
                                    return Text(
                                        'Chi: ${NumberFormat('###,###').format(paid)} VND');
                                  }),
                              Expanded(child: Container()),
                              Selector<MainViewModel, int>(
                                  selector: (context, myModel) => myModel.debt,
                                  builder: (context, debt, child) {
                                    return Text(
                                        'Tổng chi phí: ${NumberFormat('###,###').format(debt)} VND');
                                  })
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 320,
                          child: Selector<MainViewModel, List<RecordPayment>>(
                              selector: (context, myModel) => myModel.records,
                              builder: (context, records, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        records.length < 6 ? records.length : 5,
                                    itemExtent: 80,
                                    itemBuilder: (context, index) {
                                      return records.isEmpty
                                          ? null
                                          : ListTile(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    builder: (BuildContext
                                                            builderContext) =>
                                                        RecordView(
                                                          recordPayment:
                                                              records[index],
                                                        ),
                                                    context: context);
                                              },
                                              title: record(records[index]));
                                    },
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contextBuilder) =>
                                  ChangeNotifierProvider<MainViewModel>.value(
                                      value: Provider.of<MainViewModel>(context,
                                          listen: false),
                                      child: const RecordManagementView())));
                    },
                    child: const Text('Xem thêm')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> initialModel() async {
    await Provider.of<MainViewModel>(context, listen: false).initial(
        UserProvider.toUser(Provider.of<UserProvider>(context, listen: false)));
  }

  @override
  void initState() {
    super.initState();
    initialModel();
  }
}
