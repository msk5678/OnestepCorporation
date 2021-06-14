import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

final myController = TextEditingController();

// Navigator.of(context).popUntil((route) => route.isFirst);

class DealFirstCase extends StatelessWidget {
  final String postUid;
  DealFirstCase(this.postUid);

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
              'case one',
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
                        // String count;
                        // int countValue;
                        int count = 0;

                        Map<dynamic, dynamic> values;

                        FirebaseDatabase.instance
                            .reference()
                            .child('report')
                            .child(googleSignIn.currentUser.id)
                            .once()
                            .then((value) => {
                                  if (value.value == null)
                                    // 아예 신고가 처음일때
                                    {}
                                  else
                                    {
                                      values = value.value,
                                      values.forEach((key, value) {
                                        count++;
                                        // 최초신고 timestamp 마지막 꺼 확인해서 value['reportCount'] 이용 25 면 꽉 찬거고 25 아니면 ++
                                        if (count == value.length) {
                                          print('key = ${key}');
                                          print(
                                              'value = ${value['reportCount']}');
                                        }
                                      })
                                    }
                                  // Map<dynamic, dynamic> values = value.value,
                                  // 첫 신고

                                  // if (value.value == null)
                                  //   {
                                  //     FirebaseDatabase.instance
                                  //         .reference()
                                  //         .child('report')
                                  //         .child(googleSignIn.currentUser.id)
                                  //         .child('처음신고 시간')
                                  //         .child('deal')
                                  //         .child('post1')
                                  //         .child('value')
                                  //         .child(DateTime.now()
                                  //             .millisecondsSinceEpoch
                                  //             .toString())
                                  //         .set({
                                  //       'case': '1',
                                  //       'content': myController.text.toString(),
                                  //       'title': "case first",
                                  //       // 'count': '0',
                                  //       'reportedUid':
                                  //           googleSignIn.currentUser.id,
                                  //       'time': DateTime.now()
                                  //           .millisecondsSinceEpoch
                                  //           .toString(),
                                  //     })
                                  //   }
                                  // else
                                  //   {
                                  // countValue = value.value.length,
                                  //     // countValue++,
                                  //     // count = countValue.toString(),
                                  //     FirebaseDatabase.instance
                                  //         .reference()
                                  //         .child('report')
                                  //         .child(googleSignIn.currentUser.id)
                                  //         .child('처음신고 시간')
                                  //         .child('deal')
                                  //         .child('post1')
                                  //         .child('value')
                                  //         .child(DateTime.now()
                                  //             .millisecondsSinceEpoch
                                  //             .toString())
                                  //         .set({
                                  //       'case': '1',
                                  //       'content': myController.text.toString(),
                                  //       'title': "case first",
                                  //       // 'count': count,
                                  //       'reportedUid':
                                  //           googleSignIn.currentUser.id,
                                  //       'time': DateTime.now()
                                  //           .millisecondsSinceEpoch
                                  //           .toString(),
                                  //     })
                                  //   }
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
