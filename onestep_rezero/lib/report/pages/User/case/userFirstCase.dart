import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

final myController = TextEditingController();

class UserFirstCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        myController.text = "";
        Navigator.pop(context, false);
        return Future(() => false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'user case one',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "case one report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  child: Text(
                    "case one report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  child: Text(
                    "case one report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  child: Text(
                    "case one report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  child: Text(
                    "case one report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  height: 150,
                  padding: EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 100.0,
                    child: TextField(
                      controller: myController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '내용을 입력해주세요',
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        Map<dynamic, dynamic> values;

                        FirebaseDatabase.instance
                            .reference()
                            .child('report')
                            .child(googleSignIn.currentUser.id)
                            .once()
                            .then((value) => {
                                  if (value.value == null)
                                    // 아예 신고가 처음일때
                                    {
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child('report')
                                          .child('reportedUid')
                                          .child('처음신고 시간')
                                          .child('user')
                                          .child('postUid')
                                          .child('value')
                                          .child(DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString())
                                          .set({
                                        'case': '1',
                                        'content': myController.text.toString(),
                                        'title': "case first",
                                        'reportedUid':
                                            googleSignIn.currentUser.id,
                                        'time': DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                      })
                                    }
                                  else
                                    {
                                      // 같은 post 인지 확인
                                      values = value.value,
                                      values.forEach((key, value) {
                                        // 최초신고 timestamp 마지막 꺼 확인해서 value['reportCount'] 이용 25 면 꽉 찬거고 25 아니면 ++
                                        if (value['reportCount'] == 25) {
                                          FirebaseDatabase.instance
                                              .reference()
                                              .child('report')
                                              .child('reportedUid')
                                              .child('처음신고 시간2')
                                              .child('user')
                                              .child('postUid')
                                              .child('value')
                                              .child(DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString())
                                              .set({
                                            'case': '1',
                                            'content':
                                                myController.text.toString(),
                                            'title': "case first",
                                            'reportedUid':
                                                googleSignIn.currentUser.id,
                                            'time': DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                          });
                                        } else {
                                          FirebaseDatabase.instance
                                              .reference()
                                              .child('report')
                                              .child('reportedUid')
                                              .child(key.toString())
                                              .child('user')
                                              .child('postUid')
                                              .child('value')
                                              .child(DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString())
                                              .set({
                                            'case': '1',
                                            'content':
                                                myController.text.toString(),
                                            'title': "case first",
                                            'reportedUid':
                                                googleSignIn.currentUser.id,
                                            'time': DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                          });
                                        }
                                      })
                                    }
                                });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Center(child: Text("onestep 팀에게 제출하기")),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
