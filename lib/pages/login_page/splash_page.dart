import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main_page/main_page.dart';
import 'login_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  static final _notification = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    init();
    _configureFirebaseMessaging();
    super.initState();
  }


  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
        ));
  }


  void showNotification(
      {int id = 0,
        required String title,
        required String body,
        required String payload}) async {

    _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }


  void _configureFirebaseMessaging() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("from message");
      Map<String, dynamic> data = message.data;
      showNotification(title: data['title'],body: data['message'],payload:data['message'] );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("from event");
      Map<String, dynamic> data = event.data;
      showNotification(title: data['title'],body: data['message'],payload:data['message'] );
    });


  }


  init() async {
    await Future.delayed(Duration(seconds: 0));
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff192028),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white60,
                  ))
            ],
          ),
        ));
  }
}
