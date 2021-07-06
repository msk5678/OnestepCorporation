import 'package:flutter/material.dart';
import 'package:onestep_rezero/home/widgets/notificationBody.dart';

class HomeNotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("채팅", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: NotificationBody(),
    );
  }
}
