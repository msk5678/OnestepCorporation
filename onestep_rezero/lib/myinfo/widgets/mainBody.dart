import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onestep_rezero/login/pages/choiceAuthWayPage.dart';
import 'package:onestep_rezero/login/pages/loginAuthPage.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/myinfo/pages/infomation/noticePage.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoProfilePage.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoSettingsPage.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoTransaction.dart';
import 'package:onestep_rezero/myinfo/providers/providers.dart';
import 'package:onestep_rezero/myinfo/widgets/myProfileImage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _showDialog(BuildContext context, int authValue,
    AsyncSnapshot<DocumentSnapshot> snapshot) {
  final f = DateFormat('yyyy-MM-dd hh:mm');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return authValue == 1
          ? AlertDialog(
              title: Text("증명서인증 대기중"),
              content: Text("대기중"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("확인"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          : AlertDialog(
              title: Text("학교인증"),
              content: Text(
                  "${f.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data()['authTime']))} 에 완료하셨습니다"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("확인"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
    },
  );
}

// push, marketing 알림 dialog
void _testShowDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("OneStep 회원가입을 진심으로 환영합니다!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("마케팅 및 이벤트성 알림을 받으시겠습니까?"),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height / 30, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        child: Text("취소"),
                        onPressed: () {
                          // FirebaseFirestore.instance
                          //     .collection('user')
                          //     .doc(googleSignIn.currentUser.id)
                          //     .collection('notification')
                          //     .doc('setting')
                          //     .set({"marketing": 0, "push": 1});
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        child: Text("확인"),
                        onPressed: () {
                          // FirebaseFirestore.instance
                          //     .collection('user')
                          //     .doc(googleSignIn.currentUser.id)
                          //     .collection('notification')
                          //     .doc('setting')
                          //     .set({"marketing": 1, "push": 1});
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

class MyinfoMainBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(googleSignIn.currentUser.id)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyProfileImage(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 20, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                // 닉네임
                                snapshot.data.data()['nickName'].toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              child: Text(
                                // 아이디
                                snapshot.data.data()['email'].toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width / 7, 0, 0, 0),
                          child: IconButton(
                            icon: Icon(Icons.settings),
                            color: Colors.black,
                            iconSize: 30,
                            onPressed: () async {
                              // // SharedPreferences 내부 db
                              // SharedPreferences _prefsPush;
                              // SharedPreferences _prefsMarketing;
                              // _prefsPush =
                              //     await SharedPreferences.getInstance();
                              // // set 부분은 추후에 회원가입할때 푸시 알림 받으시겠습니까? ok -> true, no -> false
                              // // 줘서 로그인할때 set 해주는 코드 넣기 지금은 임시
                              // _prefsPush.setBool('value', true);
                              // context
                              //     .read(switchCheckPush)
                              //     .changeSwitch(_prefsPush.getBool('value'));
                              // _prefsMarketing =
                              //     await SharedPreferences.getInstance();
                              // _prefsMarketing.setBool('value', true);
                              // context.read(switchCheckMarketing).changeSwitch(
                              //     _prefsMarketing.getBool('value'));
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => MyinfoSettingsPage(
                              //         _prefsPush, _prefsMarketing)));

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyinfoSettingsPage()));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0,
                        MediaQuery.of(context).size.width / 20,
                        0,
                        MediaQuery.of(context).size.width / 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyinfoProfilePage()));
                          },
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyinfoProfilePage()));
                                },
                                icon: Icon(Icons.error_outline),
                              ),
                              Text("프로필보기"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyinfoTransaction()));
                          },
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.error_outline),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyinfoTransaction()));
                                },
                              ),
                              Text("거래내역"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.error_outline),
                              ),
                              Text("찜목록"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20,
                        MediaQuery.of(context).size.width / 30,
                        0,
                        0),
                    child: Container(
                      child: Text(
                        "인증",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showDialog(context, 2, snapshot);
                      // snapshot.data.data()['auth'] == 1
                      //     ? _showDialog(context, 1, snapshot)
                      //     : _showDialog(context, 2, snapshot);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 20,
                          MediaQuery.of(context).size.width / 40,
                          0,
                          0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "학교 인증",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              _showDialog(context, 2, snapshot);
                              // snapshot.data.data()['auth'] == 1
                              //     ? _showDialog(context, 1, snapshot)
                              //     : _showDialog(context, 2, snapshot);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20,
                        MediaQuery.of(context).size.width / 30,
                        0,
                        0),
                    child: Container(
                      child: Text(
                        "정보",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NoticePage()));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 20,
                          MediaQuery.of(context).size.width / 40,
                          0,
                          0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "공지사항",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NoticePage()));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "문의사항",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "고객센터",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "개인정보 처리방침",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "서비스 이용약관",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "버전정보",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
