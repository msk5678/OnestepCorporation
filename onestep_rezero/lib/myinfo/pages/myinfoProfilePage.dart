import 'package:flutter/material.dart';
import 'package:onestep_rezero/myinfo/widgets/userProfileBody.dart';

class MyinfoProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로필 보기',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: UserProfileBody(),
    );
  }
}
