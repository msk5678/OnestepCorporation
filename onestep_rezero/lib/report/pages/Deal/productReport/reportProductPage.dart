import 'package:flutter/material.dart';

import '../../reportUserPage.dart';
import '../reportDealController.dart';

class ReportProductPage extends StatelessWidget {
  final String postUid;
  final String reportedUid;

  ReportProductPage(this.postUid, this.reportedUid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '장터 -> 글 신고 테스트',
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
                reportDealController(
                  context,
                  1,
                  1,
                  postUid,
                  reportedUid,
                );
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
            Divider(),
            Divider(),
            InkWell(
              onTap: () {
                String postUid;
                String reportedUid;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReportUserPage(postUid, reportedUid),
                ));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    MediaQuery.of(context).size.width / 40,
                    0,
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "사용자 신고 하러가기",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        String postUid;
                        String reportedUid;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ReportUserPage(postUid, reportedUid),
                        ));
                      },
                    )
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
