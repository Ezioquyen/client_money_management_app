import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/user/user.dart';

import 'package:untitled1/viewModels/house_control_view_model.dart';

import '../../models/house.dart';
import '../../viewModels/main_view_model.dart';
import 'member_group.dart';

class HouseControlView extends StatelessWidget {
  const HouseControlView({super.key});

  @override
  Widget build(BuildContext context) {
    MainViewModel mainViewModel =
        Provider.of<MainViewModel>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => HouseControlViewModel(
          mainViewModel.users, mainViewModel.house, mainViewModel.user),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: Text(
            mainViewModel.house.name,
            style: const TextStyle(color: Colors.white),
          ),
          actions: mainViewModel.house.role
              ? [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) =>
                                SettingView(house: mainViewModel.house),
                          ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.settings,
                        size: 20,
                      ),
                    ),
                  ),
                ]
              : null,
        ),
        body: const HouseControlBodyWidget(),
      ),
    );
  }
}

class HouseControlBodyWidget extends StatefulWidget {
  const HouseControlBodyWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeControlBodyState();
  }
}

class HomeControlBodyState extends State<HouseControlBodyWidget> {
  @override
  Widget build(BuildContext context) {
    HouseControlViewModel houseControlViewModel =
        Provider.of<HouseControlViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
            child: SegmentedButton<MemberGroup>(
              segments: const <ButtonSegment<MemberGroup>>[
                ButtonSegment<MemberGroup>(
                    value: MemberGroup.member,
                    label: Text('Thành viên'),
                    icon: Icon(Icons.person)),
                ButtonSegment<MemberGroup>(
                    value: MemberGroup.group,
                    label: Text('Nhóm'),
                    icon: Icon(Icons.group)),
              ],
              selected: <MemberGroup>{houseControlViewModel.memberGroup},
              onSelectionChanged: (Set<MemberGroup> newSelection) {
                houseControlViewModel.memberGroup = newSelection.first;
              },
            ),
          ),
          Consumer<HouseControlViewModel>(builder: (context, myModel, child) {
            return SizedBox(
              height: 350,
              child: houseControlViewModel.memberGroup == MemberGroup.member
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: myModel.users.length,
                      itemExtent: 70,
                      itemBuilder: (context, index) {
                        return userBar(myModel.users[index]);
                      },
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount:
                          myModel.groups.isNotEmpty ? myModel.groups.length : 1,
                      itemExtent: 70,
                      itemBuilder: (context, index) {
                        return myModel.groups.isNotEmpty
                            ? groupBar(myModel.groups[index])
                            : null;
                      },
                    ),
            );
          }),
          _widgetHandle(houseControlViewModel.house.role),
        ],
      ),
    );
  }

  Widget _widgetHandle(bool role) {
    return role
        ? const TextButton(onPressed: null, child: Text('Thêm'))
        : Container();
  }

  Widget userBar(User user) {
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
                    user.username,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepPurple[600]),
                  ),
                  Text(
                    user.email,
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

  Widget groupBar(PaymentGroup paymentGroup) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                paymentGroup.name,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ))),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class SettingView extends StatelessWidget {
  final House house;

  const SettingView({Key? key, required this.house}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  const Text('Code: ', style: TextStyle(fontSize: 32)),
                  Text(
                    house.id,
                    style: const TextStyle(fontSize: 32),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
