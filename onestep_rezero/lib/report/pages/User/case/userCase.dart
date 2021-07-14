import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/report/public/reportDefaultText.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialog.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialogNotCancel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final myController = TextEditingController();

void report(
    String postUid, String reportedUid, int reportCase, BuildContext context) {
  Map<dynamic, dynamic> values;
  List reportKeys;

  // 중복신고 방지
  FirebaseDatabase.instance
      .reference()
      .child('reportOverlapCheck')
      .child(currentUserModel.uid)
      .child('user')
      .set({postUid: true});

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
                    .child('user')
                    .child(postUid)
                    .child('value')
                    .child(DateTime.now().millisecondsSinceEpoch.toString())
                    .set({
                  'case': reportCase.toString(),
                  'content': myController.text.toString(),
                  'title': "case first",
                  // 신고 당한 사람
                  'reportedUid': reportedUid,
                  // 신고 한 사람
                  'reportingUid': currentUserModel.uid,
                  'time': DateTime.now().millisecondsSinceEpoch.toString(),
                  'university': currentUserModel.university,
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
                          .child('user')
                          .child(postUid)
                          .child('value')
                          .child(
                              DateTime.now().millisecondsSinceEpoch.toString())
                          .set({
                        'case': reportCase.toString(),
                        'content': myController.text.toString(),
                        'title': "case first",
                        // 신고 당한 사람
                        'reportedUid': reportedUid,
                        // 신고 한 사람
                        'reportingUid': currentUserModel.uid,
                        'time':
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        'university': currentUserModel.university,
                      });
                    } else {
                      FirebaseDatabase.instance
                          .reference()
                          .child('report')
                          .child(reportedUid)
                          .child(key.toString())
                          .child('user')
                          .child(postUid)
                          .child('value')
                          .child(
                              DateTime.now().millisecondsSinceEpoch.toString())
                          .set({
                        'case': reportCase.toString(),
                        'content': myController.text.toString(),
                        'title': "case first",
                        // 신고 당한 사람
                        'reportedUid': reportedUid,
                        // 신고 한 사람
                        'reportingUid': currentUserModel.uid,
                        'time':
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        'university': currentUserModel.university,
                      });
                    }
                  }
                })
              }
          });
  Navigator.pop(context);
}

class UserCase extends StatelessWidget {
  final String title;
  final String content;
  final int reportCase;
  final String chatId;
  final String reportedUid;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserCase(
      this.title, this.content, this.reportCase, this.chatId, this.reportedUid);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        myController.text = "";
        Navigator.pop(context, false);
        return Future(() => false);
      },
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 1,
            title: Text(
              '사용자 신고',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20.h),
                    child: Row(
                      children: [
                        getReportUserNickName(chatId, reportedUid, 15),
                        Text(
                          " 님을 신고하는 이유를 간략하게 알려주세요.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 32.h, 0, 0),
                    child: Container(
                      height: 150,
                      child: TextField(
                        controller: myController,
                        maxLines: 5,
                        maxLength: 150,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.3)),
                          hintText: '내용을 입력해주세요',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 17.h, 0, 2.h),
                    child: getReportDefaulBodytText(),
                  ),
                  getReportDefaulTailtText(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15.h, 0, 0),
                    child: Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: OnestepColors().mainColor),
                          onPressed: () async {
                            // report();
                            Map<dynamic, dynamic> values;
                            bool flag = false;
                            await FirebaseDatabase.instance
                                .reference()
                                .child('reportOverlapCheck')
                                .child(currentUserModel.uid)
                                .child('board')
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
                                            if (key == chatId) {
                                              // 같은 글을 신고한다
                                              if (value == true) {
                                                flag = true;
                                                OnestepCustomDialogNotCancel
                                                    .show(
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
                                      ? report(chatId, reportedUid, reportCase,
                                          context)
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
                            height: 40.h,
                            width: 300.w,
                            child: Center(child: Text("onestep 팀에게 제출하기")),
                          )),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
