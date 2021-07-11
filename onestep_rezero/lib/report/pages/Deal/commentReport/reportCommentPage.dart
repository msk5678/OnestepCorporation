import 'package:flutter/material.dart';

import '../reportDealController.dart';

class ReportComentPage extends StatelessWidget {
  final String boardUid;
  final String postUid;
  final String reportedUid;
  final String commentUid;
  ReportComentPage(
      this.boardUid, this.postUid, this.reportedUid, this.commentUid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '댓글 신고 테스트',
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
                  3,
                  1,
                  postUid,
                  reportedUid,
                  boardUid: boardUid,
                  commentUid: commentUid,
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
          ],
        ),
      ),
    );
  }
}
