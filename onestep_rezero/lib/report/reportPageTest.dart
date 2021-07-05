import 'package:flutter/material.dart';
import 'package:onestep_rezero/report/pages/Deal/boardReport/reportBoardPage.dart';
import 'package:onestep_rezero/report/pages/Deal/cocommentReport/reportCocommentPage.dart';
import 'package:onestep_rezero/report/pages/Deal/commentReport/reportCommentPage.dart';
import 'package:onestep_rezero/report/pages/Deal/productReport/reportProductPage.dart';
import 'package:onestep_rezero/report/pages/reportUserPage.dart';

class ReportPageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '신고 테스트',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // // boardUid
                  // String boardUid;
                  // // postUid
                  // String postUid;
                  // // 신고당한사람 uid
                  // String reportedUid;

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         ReportDealPage(boardUid, postUid, reportedUid)));

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportProductPage()));
                },
                child: Text("장터 -> 글 신고"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // // boardUid
                  // String boardUid;
                  // // postUid
                  // String postUid;
                  // // 신고당한사람 uid
                  // String reportedUid;

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         ReportDealPage(boardUid, postUid, reportedUid)));

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportBoardPage()));
                },
                child: Text("게시판 -> 글 신고"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // // boardUid
                  // String boardUid;
                  // // postUid
                  // String postUid;
                  // // 신고당한사람 uid
                  // String reportedUid;

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         ReportDealPage(boardUid, postUid, reportedUid)));

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportComentPage()));
                },
                child: Text("댓글 신고"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // // boardUid
                  // String boardUid;
                  // // postUid
                  // String postUid;
                  // // 신고당한사람 uid
                  // String reportedUid;

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         ReportDealPage(boardUid, postUid, reportedUid)));

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportCocommentPage()));
                },
                child: Text("대댓글 신고"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // postUid
                String uid;
                // 신고당한사람 uid
                String reportedUid;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReportUserPage(uid, reportedUid)));
              },
              child: Text("사용자신고"),
            ),
          ],
        ));
  }
}
