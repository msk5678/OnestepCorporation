import 'package:flutter/material.dart';
import 'package:onestep_rezero/report/pages/reportDealPage.dart';
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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportDealPage()));
                },
                child: Text("거래신고"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReportUserPage()));
              },
              child: Text("사용자신고"),
            ),
          ],
        ));
  }
}
