import 'package:flutter/material.dart';

class MyInfoMain extends StatefulWidget {
  MyInfoMain({Key key}) : super(key: key);

  @override
  _MyInfoMainState createState() => _MyInfoMainState();
}

class _MyInfoMainState extends State<MyInfoMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("내정보"),
      ),
      body: Container(
        child: Text("내정보"),
      ),
    );
  }
}
