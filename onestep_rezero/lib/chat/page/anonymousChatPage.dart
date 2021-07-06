import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/page/anonymousChatBody.dart';

class AnonymousChattingRoomPage extends StatefulWidget {
  const AnonymousChattingRoomPage({Key key}) : super(key: key);

  @override
  _AnonymousChatPageState createState() => _AnonymousChatPageState();
}

class _AnonymousChatPageState extends State<AnonymousChattingRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        leading: BackButton(
          color: Colors.black,
          // OnestepColors().mainColor,
        ),
        elevation: 0,
        title: Text(
          "콜로세움",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
      body: AnonymousChatBody(),
    );
  }
}
