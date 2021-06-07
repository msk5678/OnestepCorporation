import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/main.dart';

final myController = TextEditingController();

// Navigator.of(context).popUntil((route) => route.isFirst);

class DealThirdCase extends StatelessWidget {
  final String postUid;
  DealThirdCase(this.postUid);

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
              'case third',
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
                    "case third report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  child: Text(
                    "case third report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  child: Text(
                    "case third report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  child: Text(
                    "case third report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  child: Text(
                    "case third report",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                // 이거 고려 아직 안함
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
                      onPressed: () {
                        print("제출하기 click");

                        String count;
                        int countValue;

                        FirebaseDatabase.instance
                            .reference()
                            .child('report')
                            .child(googleSignIn.currentUser.id)
                            .child('deal')
                            .child('post1')
                            .once()
                            .then((value) => {
                                  if (value.value == null)
                                    {
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child('report')
                                          .child(googleSignIn.currentUser.id)
                                          .child('deal')
                                          .child('post1')
                                          .child('value')
                                          .child(DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString())
                                          .set({
                                        'case': '3',
                                        'content': myController.text.toString(),
                                        'title': "case third",
                                        'count': '0',
                                        'reportedUid':
                                            googleSignIn.currentUser.id,
                                        'time': DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                      })
                                    }
                                  else
                                    {
                                      countValue = value.value.length,
                                      countValue++,
                                      count = countValue.toString(),
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child('report')
                                          .child(googleSignIn.currentUser.id)
                                          .child('deal')
                                          .child('post1')
                                          .child('value')
                                          .child(DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString())
                                          .set({
                                        'case': '3',
                                        'content': myController.text.toString(),
                                        'title': "case third",
                                        'count': count,
                                        'reportedUid':
                                            googleSignIn.currentUser.id,
                                        'time': DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
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
