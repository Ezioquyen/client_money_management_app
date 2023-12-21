import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/user/user.dart';

import 'package:untitled1/viewmodels/controller/house_control_view_model.dart';
import 'package:untitled1/viewmodels/controller/main_view_vm.dart';

import 'member_group.dart';

class HouseControlView extends StatelessWidget {
  final MainViewVModel mainViewVModel;

  const HouseControlView({Key? key, required this.mainViewVModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HouseControlViewModel(mainViewVModel.users,mainViewVModel.house,mainViewVModel.user),
      child: Scaffold(
        appBar: AppBar(
          title: Text(mainViewVModel.house.name),
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
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    HouseControlViewModel houseControlViewModel =
        Provider.of<HouseControlViewModel>(context);
    return !isLoaded
        ? const ProgressIndicatorTheme(
            data: ProgressIndicatorThemeData(
              color: Colors.red,
            ),
            child:Center(child: CircularProgressIndicator()))
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: SegmentedButton<MemberGroup>(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.blueAccent),
                    ),
                    segments: const <ButtonSegment<MemberGroup>>[
                      ButtonSegment<MemberGroup>(
                          value: MemberGroup.member,
                          label: Text('Members'),
                          icon: Icon(Icons.person)),
                      ButtonSegment<MemberGroup>(
                          value: MemberGroup.group,
                          label: Text('Groups'),
                          icon: Icon(Icons.group)),
                    ],
                    selected: <MemberGroup>{houseControlViewModel.memberGroup},
                    onSelectionChanged: (Set<MemberGroup> newSelection) {
                      houseControlViewModel.memberGroup = newSelection.first;
                    },
                  ),
                ),
                Consumer<HouseControlViewModel>(
                    builder: (context, myModel, child) {
                  return Container(
                    height: 350,
                    child:
                        houseControlViewModel.memberGroup == MemberGroup.member
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: myModel.users.isNotEmpty
                                    ? myModel.users.length
                                    : 1,
                                itemExtent: 70,
                                itemBuilder: (context, index) {
                                  return userBar(myModel.users[index]);
                                },
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: myModel.groups.isNotEmpty
                                    ? myModel.groups.length
                                    : 1,
                                itemExtent: 70,
                                itemBuilder: (context, index) {
                                  return myModel.groups.isNotEmpty
                                      ? groupBar(myModel.groups[index])
                                      : null;
                                },
                              ),
                  );
                }),
                const TextButton(onPressed: null, child: Text('Add')),
              ],
            ),
          );
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
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent),
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
              margin:  const EdgeInsets.only(left: 20,top: 20),
              child: Text(paymentGroup.name,
                style: const TextStyle(
                  fontSize: 16,
                ),))),
    );
  }
  Future<void> defineState() async {

    await Provider.of<HouseControlViewModel>(context,listen: false).getGroups();
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
