import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/repository/house_repository.dart';
import 'package:untitled1/repository/notification_repository.dart';
import 'package:untitled1/repository/user_repository.dart';
import 'package:untitled1/viewModels/main_view_model.dart';

import '../../models/user/user.dart';

class AddMember extends StatelessWidget {
  AddMember({super.key});

  final _notificationRepository = NotificationRepository();
  final _userRepository = UserRepository();
  final _houseRepository = HouseRepository();

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            decoration: const InputDecoration(
                icon: Icon(Icons.email), hintText: "example@email.com"),
            controller: controller,
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              await joinUser(controller.text, context);
            },
            child: const Text('Thêm'))
      ],
    );
  }

  Future<void> joinUser(String email, BuildContext context) async {
    MainViewModel mainViewModel =
        Provider.of<MainViewModel>(context, listen: false);
    if (await _userRepository.checkUserByEmailApi(email)) {
      User user = User.fromJson(await _userRepository.getUserByEmailApi(email));
      if (!await _houseRepository.checkUserHouseApi(
          user.id, mainViewModel.house.id)) {
        await _houseRepository.joinHouse({
          'id': {'houseId': mainViewModel.house.id, 'userId': user.id},
          "house": {"id": mainViewModel.house.id},
          "user": {"id": user.id},
          'userRole': 0,
          'joinDate': DateFormat('yyyy-MM-dd').format(DateTime.now())
        });
        notify(mainViewModel, user.id);
        await mainViewModel.updateUsers();
        mainViewModel.notify();
        if (!context.mounted) return;
        Navigator.pop(context);
      } else {
        if (!await _houseRepository.oldCheck(mainViewModel.house.id, user.id)) {
          await _houseRepository.joinOld(mainViewModel.house.id, user.id);
          await mainViewModel.updateUsers();
          mainViewModel.notify();
          notify(mainViewModel, user.id);
          if (!context.mounted) return;
          Navigator.pop(context);
        } else {
          showWarningDialog(context,"User already joined house");
        }
      }
    } else {
      showWarningDialog(context, 'User is not exist');
    }
  }

  void notify(MainViewModel mainViewModel, id) {
    _notificationRepository.createNotification({
      "deepLink": "none",
      "title": "Bạn được thêm vào nhà trọ ${mainViewModel.house.name}",
      "name": "JoinHouse",
      "isRead": false,
      "time":
          DateFormat("ss:mm:HH dd/MM/yyyy").format(DateTime.now()).toString(),
      "notificationText":
          "Bạn được thêm vào nhà trọ ${mainViewModel.house.name}",
      "userIds": [id]
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
