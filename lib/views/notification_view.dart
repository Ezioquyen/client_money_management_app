
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/notification_model.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/viewModels/notification_view_model.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: const Text("Thông báo",style: TextStyle(color: Colors.white),),
          actions: const [
            InkWell(
              child: Icon(Icons.mark_chat_read),
            )
          ],
        ),
        body: const NotificationViewBody(),
      ),
    );
  }
}

class NotificationViewBody extends StatelessWidget {
  const NotificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationViewModel notificationViewModel = Provider.of<NotificationViewModel>(context,listen: false);
    notificationViewModel.user = UserProvider.toUser(Provider.of<UserProvider>(context,listen: false));
    notificationViewModel.initial();
    return Container(
      height: MediaQuery.of(context).size.height,
      child:Selector<NotificationViewModel, List<NotificationModel>>(
          selector: (context, myModel) => myModel.notifications,
          builder: (context, notifications, child) {
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (BuildContext context, int index) {
                return notificationBar(notifications[index]);
              },
            );
          }) ,
    );
  }

  Widget notificationBar(NotificationModel notificationModel) {
    return ListTile(
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_outline_rounded),
          ),
          SizedBox(width: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Flexible(
                  child: Text(
                    notificationModel.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
                Flexible(
                  child: Text(notificationModel.notificationText,style: const TextStyle(
                    fontSize: 16
                  ),),
                ),
                Text(DateFormat("d/M/y").format(notificationModel.time),
                  style: const TextStyle(
                    fontSize: 12
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}
