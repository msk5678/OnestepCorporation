import 'package:flutter/material.dart';

class BoardMain extends StatefulWidget {
  BoardMain({Key key}) : super(key: key);

  @override
  _BoardMainState createState() => _BoardMainState();
}

class _BoardMainState extends State<BoardMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("게시판"),
      ),
      body: Container(
        child: Text("게시판"),
      ),
    );
  }
}
