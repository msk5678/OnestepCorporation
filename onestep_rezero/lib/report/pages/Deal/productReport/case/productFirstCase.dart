import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialog.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialogNotCancel.dart';
import 'package:onestep_rezero/loggedInWidget.dart';

import '../../../../../onestepCustomDialog.dart';
import '../../../../../onestepCustomDialogNotCancel.dart';

final myController = TextEditingController();

void report(String postUid, String reportedUid) {
  Map<dynamic, dynamic> values;
  List reportKeys;

  // 중복신고 방지
  FirebaseDatabase.instance
      .reference()
      .child('reportOverlapCheck')
      .child(currentUserModel.uid)
      .child('product')
      .set({postUid: true});

  // reportedUid = 신고당한사람
  // postUid = 게시글 uid

  FirebaseDatabase.instance
      .reference()
      .child('report')
      .child(reportedUid)
      .once()
      .then((value) => {
            if (value.value == null)
              // 아예 신고가 처음일때
              {
                FirebaseDatabase.instance
                    .reference()
                    .child('report')
                    .child(reportedUid)
                    // 처음신고 시간
                    .child(DateTime.now().millisecondsSinceEpoch.toString())
                    .child('product')
                    .child(postUid)
                    .child('value')
                    .child(DateTime.now().millisecondsSinceEpoch.toString())
                    .set({
                  'case': '1',
                  'content': myController.text.toString(),
                  'title': "case first",
                  // 신고 당한 사람
                  'reportedUid': reportedUid,
                  // 신고 한 사람
                  'reportingUid': currentUserModel.uid,
                  'time': DateTime.now().millisecondsSinceEpoch.toString(),
                  'university': currentUserModel.university,
                  'postUid': postUid,
                })
              }
            else
              {
                // 같은 post 인지 확인
                values = value.value,
                reportKeys = values.keys.toList(),
                reportKeys.sort(),
                values.forEach((key, value) {
                  // 최초신고 timestamp 마지막 꺼 확인해서 value['reportCount'] 이용 25 면 꽉 찬거고 25 아니면 ++
                  if (key == reportKeys.last) {
                    if (value['reportCount'] == 25) {
                      FirebaseDatabase.instance
                          .reference()
                          .child('report')
                          .child(reportedUid)
                          // 처음신고 시간 2
                          .child(
                              DateTime.now().millisecondsSinceEpoch.toString())
                          .child('product')
                          .child(postUid)
                          .child('value')
                          .child(
                              DateTime.now().millisecondsSinceEpoch.toString())
                          .set({
                        'case': '1',
                        'content': myController.text.toString(),
                        'title': "case first",
                        // 신고 당한 사람
                        'reportedUid': reportedUid,
                        // 신고 한 사람
                        'reportingUid': currentUserModel.uid,
                        'time':
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        'university': currentUserModel.university,
                        'postUid': postUid,
                      });
                    } else {
                      FirebaseDatabase.instance
                          .reference()
                          .child('report')
                          .child(reportedUid)
                          .child(key.toString())
                          .child('product')
                          .child(postUid)
                          .child('value')
                          .child(
                              DateTime.now().millisecondsSinceEpoch.toString())
                          .set({
                        'case': '1',
                        'content': myController.text.toString(),
                        'title': "case first",
                        // 신고 당한 사람
                        'reportedUid': reportedUid,
                        // 신고 한 사람
                        'reportingUid': currentUserModel.uid,
                        'time':
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        'university': currentUserModel.university,
                        'postUid': postUid,
                      });
                    }
                  }
                })
              }
          });
}

class ProductFirstCase extends StatelessWidget {
  // final String boardUid;
  final String postUid;
  final String reportedUid;
  ProductFirstCase(this.postUid, this.reportedUid);

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
              'product case one',
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
                        Map<dynamic, dynamic> values;
                        bool flag = false;

                        await FirebaseDatabase.instance
                            .reference()
                            .child('reportOverlapCheck')
                            .child(currentUserModel.uid)
                            .child('product')
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
                                        if (key == postUid) {
                                          // 같은 글을 신고한다
                                          if (value == true) {
                                            flag = true;
                                            OnestepCustomDialogNotCancel.show(
                                              context,
                                              title: '이미 신고한 게시물입니다.',
                                              confirmButtonText: '확인',
                                              confirmButtonOnPress: () {
                                                Navigator.pop(context);
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
                          final DocumentSnapshot reportState =
                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(currentUserModel.uid)
                                  .get();

                          return OnestepCustomDialog.show(
                            context,
                            title: '신고하시겠습니까?',
                            confirmButtonText: '확인',
                            cancleButtonText: '취소',
                            confirmButtonOnPress: () {
                              reportState.data()['reportState'] == 0
                                  ? report(postUid, reportedUid)
                                  : null;
                              Navigator.pop(context);
                            },
                            cancleButtonOnPress: () {
                              Navigator.pop(context);
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
