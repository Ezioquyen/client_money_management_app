import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/user/user.dart';
import 'package:untitled1/repository/group_repository.dart';

import '../../repository/notification_repository.dart';
import '../../viewModels/main_view_model.dart';

class GroupControl extends StatefulWidget {
  const GroupControl({super.key, required this.paymentGroup});

  final PaymentGroup paymentGroup;

  @override
  State<StatefulWidget> createState() {
    return GroupControlState();
  }
}

class GroupControlState extends State<GroupControl> {
  final _groupRepository = GroupRepository();
  final _notificationRepository = NotificationRepository();
  late TextEditingController controller =
      TextEditingController(text: widget.paymentGroup.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.paymentGroup.id != 0 ? "Sửa nhóm" : "Tạo nhóm"),
              Expanded(child: Container()),
              ElevatedButton(
                  onPressed: Provider.of<MainViewModel>(context, listen: false)
                          .house
                          .role
                      ? () async {
                          await createGroup(controller.text, context);
                        }
                      : null,
                  child: const Text('Lưu'))
            ],
          ),
          TextField(
            readOnly:
                !Provider.of<MainViewModel>(context, listen: false).house.role,
            decoration: const InputDecoration(
                icon: Icon(Icons.group), hintText: "Tên nhóm"),
            controller: controller,
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: Provider.of<MainViewModel>(context, listen: false)
                    .users
                    .length,
                itemExtent: 50,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                              Provider.of<MainViewModel>(context, listen: false)
                                  .users[index]
                                  .username),
                        ),
                      ),
                      Expanded(child: Container()),
                      Checkbox(
                          value: widget.paymentGroup.userIds.contains(
                              Provider.of<MainViewModel>(context, listen: false)
                                  .users[index]
                                  .id),
                          onChanged:
                              Provider.of<MainViewModel>(context, listen: false)
                                      .house
                                      .role
                                  ? (value) {
                                      updateParticipant(
                                          value,
                                          Provider.of<MainViewModel>(context,
                                                  listen: false)
                                              .users[index]);
                                    }
                                  : null)
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<void> createGroup(String name, BuildContext context) async {
    MainViewModel mainViewModel =
        Provider.of<MainViewModel>(context, listen: false);

    widget.paymentGroup.houseId = mainViewModel.house.id;
    widget.paymentGroup.name = name;
    if (widget.paymentGroup.id!=0||!(await _groupRepository.checkGroupByHouseApi(
        mainViewModel.house.id, name))) {
      await _groupRepository.createGroupApi(widget.paymentGroup);
      await mainViewModel.getGroupInHouse();
      await mainViewModel.getGroups();
      mainViewModel.notify();
      notify(mainViewModel);
      if (!context.mounted) return;
      Navigator.pop(context);
    } else {
      showWarningDialog(context,"group existed");
    }
  }

  void updateParticipant(var value, User user) {
    if (value == true) {
      widget.paymentGroup.userIds.add(user.id);
    } else {
      widget.paymentGroup.userIds.remove(user.id);
    }
    setState(() {});
  }
  void notify(MainViewModel mainViewModel) {
    widget.paymentGroup.userIds.remove(mainViewModel.user.id);
    _notificationRepository.createNotification({
      "deepLink": "none",
      "title": "Thay đổi trong nhà trọ ${mainViewModel.house.name}",
      "name": "JoinHouse",
      "isRead": false,
      "time":
      DateFormat("ss:mm:HH dd/MM/yyyy").format(DateTime.now()).toString(),
      "notificationText":
      "Bạn được thêm vào nhóm nhà trọ ${widget.paymentGroup.name}",
      "userIds": widget.paymentGroup.userIds
    });
  }
  void showWarningDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
