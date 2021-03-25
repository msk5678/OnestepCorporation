import 'package:flutter/material.dart';

class HomeNotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("알림", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          child: Text("알림"),
        ),
      ),
    );
  }
}
