import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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
                  FirebaseDatabase.instance
                      .reference()
                      .child('report')
                      .child('user1')
                      .child('deal')
                      .child('post1')
                      .onValue
                      .listen((Event event) {
                    print("@@@@@@@@@@@@ ${event.snapshot.value.length}");
                  });

                  // FirebaseDatabase.instance
                  //     .reference()
                  //     .child('report')
                  //     .child("user1")
                  //     .child('deal')
                  //     .child('post1')
                  //     .child(DateTime.now().millisecondsSinceEpoch.toString())
                  //     .set({
                  //   'case': '1',
                  //   'content': "asdasdasd",
                  //   'title': "asdasd111",
                  //   'count': "5",
                  //   'reportedUid':'uid'
                  // });

                  // FirebaseFirestore.instance
                  //     .collection('users')
                  //     .doc(FirebaseApi.getId())
                  //     .update({"userScore": 5});

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => ReportDealPage()));
                },
                child: Text("거래신고"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // FirebaseFirestore.instance
                //     .collection('users')
                //     .doc(FirebaseApi.getId())
                //     .update({"userScore": 1});

                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => ReportUserPage()));
              },
              child: Text("사용자신고"),
            ),
          ],
        ));
  }
}
