import 'package:firebase_messaging/firebase_messaging.dart';

class FireBaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fCMToken = await _firebaseMessaging.getToken();
    print(fCMToken);
  }
}