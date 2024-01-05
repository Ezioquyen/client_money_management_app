

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:untitled1/models/notification_model.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/viewModels/notification_view_model.dart';
import 'package:untitled1/views/notification_view/components/notification_container.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationViewModel(),
      child: const NotificationViewBody(),
    );
  }
}

class NotificationViewBody extends StatelessWidget {
  const NotificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationViewModel notificationViewModel =
        Provider.of<NotificationViewModel>(context, listen: false);
    notificationViewModel.user =
        UserProvider.toUser(Provider.of<UserProvider>(context, listen: false));
    notificationViewModel.initial();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: const Text(
          "Thông báo",
          style: TextStyle(color: Colors.white),
        ),
        actions:  [
          InkWell(
            child: const Icon(Icons.mark_chat_read),
            onTap: () async{
              await notificationViewModel.readAllNotification();
            },
          )
        ],
      ),
      body:  SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Selector<NotificationViewModel, List<NotificationModel>>(
            selector: (context, myModel) => myModel.notifications,
            builder: (context, notifications, child) {
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return NotificationContainer(notification: notifications[index]);
                },
              );
            }),
      ),
    );
  }


}
