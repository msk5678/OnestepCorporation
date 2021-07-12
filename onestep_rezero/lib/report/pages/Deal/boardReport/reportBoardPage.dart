import 'package:flutter/material.dart';

import '../reportDealController.dart';

class ReportBoardPage extends StatelessWidget {
  final String boardUid;
  final String postUid;
  final String reportedUid;
  ReportBoardPage(this.boardUid, this.postUid, this.reportedUid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '게시판 -> 글 신고 테스트',
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
                // boardUid 게시판만 적용돼서 값을 넘겨주면 boardUid 넘긴 값으로 세팅
                // 값 안넘겨주면 default 값 세팅되게 해야함
                reportDealController(context, 2, 1, postUid, reportedUid,
                    boardUid: boardUid);
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
