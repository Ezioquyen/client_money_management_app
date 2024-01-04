import 'package:firebase_messaging/firebase_messaging.dart';

class FireBaseApi{
  static late final String fCMToken;
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async{
     await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
     fCMToken = (await _firebaseMessaging.getToken())!;

  }
}