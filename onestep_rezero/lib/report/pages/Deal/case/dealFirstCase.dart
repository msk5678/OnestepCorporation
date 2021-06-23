import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';

import '../../../../main.dart';
import '../../../../onestepCustomDialog.dart';
import '../../../../onestepCustomDialogNotCancel.dart';

final myController = TextEditingController();

void report() {
  Map<dynamic, dynamic> values;

  // 중복신고 방지
  FirebaseDatabase.instance
      .reference()
      .child('reportUser')
      .child(googleSignIn.currentUser.id)
      .set({'postUid': true});

  FirebaseDatabase.instance
      .reference()
      .child('report')
      .child('reportedUid')
      .once()
      .then((value) => {
            if (value.value == null)
              // 아예 신고가 처음일때
              {
                FirebaseDatabase.instance
                    .reference()
                    .child('report')
                    .child('reportedUid')
                    // 처음신고 시간
                    .child(DateTime.now().millisecondsSinceEpoch.toString())
                    .child('deal')
                    .child('postUid')
                    .child('value')
                    .child(DateTime.now().millisecondsSinceEpoch.toString())
                    .set({
                  'case': '1',
                  'content': myController.text.toString(),
                  'title': "case first",
                  'reportedUid': googleSignIn.currentUser.id,
                  'time': DateTime.now().millisecondsSinceEpoch.toString(),
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
                        // 처음신고 시간 2
                        .child(DateTime.now().millisecondsSinceEpoch.toString())
                        .child('deal')
                        .child('postUid')
                        .child('value')
                        .child(DateTime.now().millisecondsSinceEpoch.toString())
                        .set({
                      'case': '1',
                      'content': myController.text.toString(),
                      'title': "case first",
                      'reportedUid': googleSignIn.currentUser.id,
                      'time': DateTime.now().millisecondsSinceEpoch.toString(),
                    });
                  } else {
                    FirebaseDatabase.instance
                        .reference()
                        .child('report')
                        .child('reportedUid')
                        .child(key.toString())
                        .child('deal')
                        .child('postUid')
                        .child('value')
                        .child(DateTime.now().millisecondsSinceEpoch.toString())
                        .set({
                      'case': '1',
                      'content': myController.text.toString(),
                      'title': "case first",
                      'reportedUid': googleSignIn.currentUser.id,
                      'time': DateTime.now().millisecondsSinceEpoch.toString(),
                    });
                  }
                })
              }
          });
}

class DealFirstCase extends StatelessWidget {
  final String postUid;
  final String reportedUid;
  DealFirstCase(this.postUid, this.reportedUid);

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
              'deal case one',
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
                      style: ElevatedButton.styleFrom(
                          primary: OnestepColors().mainColor),
                      onPressed: () async {
                        // report();
                        Map<dynamic, dynamic> values;
                        bool flag = false;

                        await FirebaseDatabase.instance
                            .reference()
                            .child('reportUser')
                            .once()
                            .then((value) => {
                                  if (value.value == null)
                                    {
                                      flag = false,
                                    }
                                  else
                                    {
                                      values = value.value,
                                      values.forEach((key, value) {
                                        // 한번이라도 신고한적이 있다
                                        if (key ==
                                            googleSignIn.currentUser.id) {
                                          // 같은 글을 신고한다
                                          if (value['postUid'] == true) {
                                            flag = true;
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return OnestepCustomDialogNotCancel(
                                                  title: '이미 신고한 게시물입니다.',
                                                  confirmButtonText: '확인',
                                                  confirmButtonOnPress: () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                            );
                                          }
                                          // 신고를 한적이 있는데 같은 글이 아니다
                                          else {
                                            flag = false;
                                          }
                                        }
                                      })
                                    }
                                });
                        // 처음 신고한다
                        if (flag == false) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return OnestepCustomDialog(
                                title: '신고하시겠습니까?',
                                confirmButtonText: '확인',
                                cancleButtonText: '취소',
                                confirmButtonOnPress: () {
                                  report();
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                              );
                            },
                          );
                        }
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
