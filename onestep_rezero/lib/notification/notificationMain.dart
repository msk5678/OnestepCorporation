import 'package:flutter/material.dart';

class NotificationMain extends StatefulWidget {
  NotificationMain({Key key}) : super(key: key);

  @override
  _NotificationMainState createState() => _NotificationMainState();
}

class _NotificationMainState extends State<NotificationMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("알림"),
      ),
      body: Container(
        child: Text("알림"),
      ),
    );
  }
}
