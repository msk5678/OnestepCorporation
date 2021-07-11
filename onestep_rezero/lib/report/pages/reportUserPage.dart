import 'package:flutter/material.dart';

import 'User/reportUserController.dart';

class ReportUserPage extends StatelessWidget {
  final String postUid;
  final String reportedUid;
  ReportUserPage(this.postUid, this.reportedUid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '사용자신고 테스트',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                reportUserController(context, 1, postUid, reportedUid);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    MediaQuery.of(context).size.width / 15,
                    0,
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "신고유형 1",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, MediaQuery.of(context).size.width / 20, 0),
                      child: Icon(Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
