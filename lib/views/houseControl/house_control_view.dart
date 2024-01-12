import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/user/user.dart';
import 'package:untitled1/repository/notification_repository.dart';

import 'package:untitled1/viewModels/house_control_view_model.dart';
import 'package:untitled1/views/houseControl/add_member.dart';
import 'package:untitled1/views/houseControl/group_control.dart';

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
      create: (context) =>
          HouseControlViewModel(mainViewModel.house, mainViewModel.user),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: Selector<MainViewModel, House>(
              selector: (context, myModel) => myModel.house,
              builder: (context, house, child) {
                return Text(
                  house.name,
                  style: const TextStyle(color: Colors.white),
                );
              }),
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
    MainViewModel mainViewModel = Provider.of<MainViewModel>(context);
    HouseControlViewModel houseControlViewModel =
        Provider.of<HouseControlViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
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
            const SizedBox(
              height: 20,
            ),
            Consumer<HouseControlViewModel>(builder: (context, myModel, child) {
              return SizedBox(
                height: 400,
                child: houseControlViewModel.memberGroup == MemberGroup.member
                    ? Selector<MainViewModel, List<User>>(
                        selector: (context, myModel) => myModel.users,
                        builder: (context, users, child) {
                          return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: users.length,
                              itemExtent: 70,
                              itemBuilder: (context, index) {
                                return mainViewModel.house.role
                                    ? Slidable(
                                        key: UniqueKey(),
                                        endActionPane: ActionPane(
                                          dismissible: DismissiblePane(
                                            onDismissed: () async {
                                              showWarningDialog(context,
                                                  mainViewModel, users[index]);
                                            },
                                          ),
                                          motion: const DrawerMotion(),
                                          extentRatio: 0.25,
                                          children: [
                                            SlidableAction(
                                              label: 'Delete',
                                              backgroundColor: Colors.red,
                                              icon: Icons.delete,
                                              onPressed: (context) async {
                                                showWarningDialog(
                                                    context,
                                                    mainViewModel,
                                                    users[index]);
                                              },
                                            ),
                                          ],
                                        ),
                                        child: userBar(users[index]),
                                      )
                                    : mainViewModel.user.id == users[index].id
                                        ? Slidable(
                                            key: UniqueKey(),
                                            endActionPane: ActionPane(
                                              motion: const DrawerMotion(),
                                              extentRatio: 0.25,
                                              children: [
                                                SlidableAction(
                                                  label: 'Delete',
                                                  backgroundColor: Colors.red,
                                                  icon: Icons.delete,
                                                  onPressed: (context) async {
                                                    showWarningDialog(
                                                        context,
                                                        mainViewModel,
                                                        users[index]);
                                                  },
                                                ),
                                              ],
                                            ),
                                            child: userBar(users[index]),
                                          )
                                        : userBar(users[index]);
                              });
                        })
                    : Selector<MainViewModel, List<PaymentGroup>>(
                        selector: (context, myModel) => myModel.allHouseGroup,
                        builder: (context, groups, child) {
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: groups.length,
                            itemExtent: 70,
                            itemBuilder: (context, index) {
                              return mainViewModel.house.role
                                  ? Slidable(
                                      key: UniqueKey(),
                                      endActionPane: ActionPane(
                                        motion: const DrawerMotion(),
                                        extentRatio: 0.25,
                                        children: [
                                          SlidableAction(
                                            label: 'Delete',
                                            backgroundColor: Colors.red,
                                            icon: Icons.delete,
                                            onPressed: (context) async {
                                              showWarningGroupDialog(context,
                                                  mainViewModel, groups[index]);
                                            },
                                          ),
                                        ],
                                      ),
                                      child: groupBar(groups[index], context),
                                    )
                                  : groupBar(groups[index], context);
                            },
                          );
                        }),
              );
            }),
            _widgetHandle(houseControlViewModel.house.role,
                houseControlViewModel.memberGroup, context),
          ],
        ),
      ),
    );
  }

  Widget _widgetHandle(
      bool role, MemberGroup memberGroup, BuildContext context) {
    return role
        ? TextButton(
            onPressed: () => showModalBottomSheet(
                context: context,
                builder: (builderContext) => memberGroup == MemberGroup.member
                    ? AddMember()
                    : GroupControl(
                        paymentGroup: PaymentGroup(userIds: []),
                      )),
            child: const Text('Thêm'))
        : Container();
  }

  Widget userBar(User user) {
    return ListTile(
      title: Container(
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
      ),
    );
  }

  Widget groupBar(PaymentGroup paymentGroup, context) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (builderContext) =>
                GroupControl(paymentGroup: paymentGroup));
      },
      title: Container(
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
      ),
    );
  }

  Future<void> getGroup() async {
    Provider.of<MainViewModel>(context, listen: false).getGroupInHouse();
  }

  @override
  void initState() {
    super.initState();
    getGroup();
  }

  void showWarningDialog(
      BuildContext context, MainViewModel mainViewModel, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Bạn có chắc muốn xóa người này ra khỏi nhà chứ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await mainViewModel.removeUser(user.id);
                if (!context.mounted) return;
                if (mainViewModel.user.id == user.id) {
                  Navigator.pop(context);
                }
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('NO'),
            ),
          ],
        );
      },
    );
  }

  void showWarningGroupDialog(
      BuildContext context, MainViewModel mainViewModel, PaymentGroup group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Bạn có chắc muốn xóa nhóm này chứ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await mainViewModel.removeGroup(group.id);
                if(!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('NO'),
            ),
          ],
        );
      },
    );
  }
}

class SettingView extends StatelessWidget {
  final House house;

  SettingView({Key? key, required this.house}) : super(key: key);
  final _notificationRepository = NotificationRepository();

  @override
  Widget build(BuildContext context) {
    MainViewModel mainViewModel =
        Provider.of<MainViewModel>(context, listen: false);
    TextEditingController controller = TextEditingController(text: house.name);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "House name: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                        width: 200,
                        child: TextField(
                            controller: controller,
                            style: const TextStyle(fontSize: 25))),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                      onPressed: () {
                        String old = mainViewModel.house.name;
                        List<int> receiveList = [];
                        for (var element in mainViewModel.users) {
                          receiveList.add(element.id);
                        }
                        receiveList.remove(mainViewModel.user.id);
                        mainViewModel.updateName(controller.text);
                        notify(old, controller.text, receiveList);
                      },
                      icon: Icon(
                        Icons.save,
                        size: 35,
                        color: Colors.deepPurple[400],
                      ))
                ],
              ),
              Row(children: [
                const Text('Code: ', style: TextStyle(fontSize: 20)),
                SelectableText(
                  house.id,
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: house.id));
                    },
                    icon: const Icon(Icons.copy))
              ])
            ],
          ),
        ),
      ),
    );
  }

  void notify(String old, String newName, List<int> uIds) {
    _notificationRepository.createNotification({
      "deepLink": "none",
      "title": "Thay đổi tên nhà trọ $old",
      "name": "JoinHouse",
      "isRead": false,
      "time":
          DateFormat("ss:mm:HH dd/MM/yyyy").format(DateTime.now()).toString(),
      "notificationText": "Thay đổi tên nhà trọ $old thành $newName",
      "userIds": uIds
    });
  }
}
