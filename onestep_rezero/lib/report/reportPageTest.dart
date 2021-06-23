import 'package:flutter/material.dart';
import 'package:onestep_rezero/report/pages/reportDealPage.dart';

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
                  String uid;
                  // 신고당한사람 uid
                  String reportedUid;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportDealPage(uid, reportedUid)));
                },
                child: Text("거래신고"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // String uid;
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => ReportUserPage(uid)));
              },
              child: Text("사용자신고"),
            ),
          ],
        ));
  }
}
