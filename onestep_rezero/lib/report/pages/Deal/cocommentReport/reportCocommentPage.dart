import 'package:flutter/material.dart';

class ReportCocommentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '대댓글 신고 테스트',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          child: Text('대댓글 신고'),
        ),
      ),
    );
  }
}
