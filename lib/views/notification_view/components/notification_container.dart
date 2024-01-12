import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/record.dart';
import 'package:untitled1/viewModels/main_view_model.dart';
import 'package:untitled1/viewModels/notification_view_model.dart';
import 'package:untitled1/views/main_view/components/record_view.dart';

import '../../../models/notification_model.dart';

class NotificationContainer extends StatefulWidget {
  final NotificationModel notification;

  const NotificationContainer({Key? key, required this.notification})
      : super(key: key);

  @override
  _NotificationContainerState createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer> {
  @override
  Widget build(BuildContext context) {
    MainViewModel mainViewModel = Provider.of<MainViewModel>(context);
    return Container(
      decoration: BoxDecoration(
        color: widget.notification.isRead
            ? Colors.deepPurple[50]
            : Colors.deepPurple[100],
      ),
      child: ListTile(
        onTap: () async {
          if (!widget.notification.isRead) {
            widget.notification.isRead = true;
            await Provider.of<NotificationViewModel>(context, listen: false)
                .readNotification(widget.notification.id);
            mainViewModel.getUnreadNotify();
            setState(() {});
          }
          if (widget.notification.deepLink != null) {
            List<String>? path = widget.notification.deepLink?.split("/");
            switch (path?[0]) {
              case "record":
                {
                  if (!context.mounted) return;
                  RecordPayment recordPayment = RecordPayment.fromJson(
                      await Provider.of<MainViewModel>(context, listen: false)
                          .getRecordById(path![1]));
                  if (!context.mounted) return;
                  showModalBottomSheet(
                      context: context,
                      builder: (bc) =>
                          RecordView(recordPayment: recordPayment));
                }
              case "recordRemoved":
                {
                  if (!context.mounted) return;
                  RecordPayment recordPayment = RecordPayment.fromJson(
                      await Provider.of<MainViewModel>(context, listen: false)
                          .getRemovedRecordById(path![1]));
                  if (!context.mounted) return;
                  showModalBottomSheet(
                      context: context,
                      builder: (bc) =>
                          RecordView(recordPayment: recordPayment));
                }
            }
          }
        },
        style: ListTileStyle.list,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_outline_rounded),
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 270,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notification.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      widget.notification.notificationText,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.clip,
                      maxLines: 3,
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy").format(widget.notification.time),
                      style: const TextStyle(fontSize: 13),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
