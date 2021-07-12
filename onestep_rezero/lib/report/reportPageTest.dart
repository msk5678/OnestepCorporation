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
                  // postUid
                  String postUid;
                  // 신고당한사람 uid
                  String reportedUid;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ReportProductPage(postUid, reportedUid)));
                },
                child: Text("장터 -> 글 신고"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // boardUid
                  String boardUid;
                  // postUid
                  String postUid;
                  // 신고당한사람 uid
                  String reportedUid;

                  // 찬섭 게시판 신고
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ReportBoardPage(boardUid, postUid, reportedUid)));
                },
                child: Text("게시판 -> 글 신고"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // boardUid
                  String boardUid;
                  // postUid
                  String postUid;
                  // 신고당한사람 uid
                  String reportedUid;
                  // comment uid
                  String commentUid;

                  // 찬섭 댓글 신고
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportCommentPage(
                          boardUid, postUid, reportedUid, commentUid)));
                },
                child: Text("댓글 신고"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // boardUid
                  String boardUid;
                  // postUid
                  String postUid;
                  // 신고당한사람 uid
                  String reportedUid;
                  // comment uid
                  String commentUid;
                  // cocomment uid
                  String cocommentUid;

                  // 찬섭 대댓글 신고
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportCocommentPage(boardUid,
                          postUid, reportedUid, commentUid, cocommentUid)));
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
