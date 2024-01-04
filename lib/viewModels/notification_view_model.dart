import 'package:flutter/cupertino.dart';
import 'package:untitled1/models/notification_model.dart';
import 'package:untitled1/repository/notification_repository.dart';

import '../models/user/user.dart';

class NotificationViewModel extends ChangeNotifier {
  late User user;
  List<NotificationModel> notifications = [];
  final notificationRepository = NotificationRepository();
  Future<void> getNotification() async{
    List<dynamic> list =  await notificationRepository.getNotificationByUser(user.id);
    notifications = list
        .map((jsonObject) => NotificationModel.fromMap(jsonObject))
        .toList();
    notifyListeners();
  }
  Future<void> initial() async{
    await getNotification();

  }
  Future<void> readNotification(int id) async{
    await notificationRepository.readNotification(id);
  }
}
