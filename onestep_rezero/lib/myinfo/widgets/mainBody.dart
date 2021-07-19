import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onestep_rezero/favorite/pages/favoriteMain.dart';
import 'package:onestep_rezero/myinfo/pages/myProduct/myProductMain.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/myinfo/pages/infomation/noticePage.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoTransaction.dart';
import 'package:onestep_rezero/myinfo/widgets/myProfileImage.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialogNotCancel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../spinkitTest.dart';

final f = DateFormat('yyyy-MM-dd hh:mm a');

// 카카오톡 처럼 뒤에 화면 남기고 로딩 화면 보여주고 로딩 끝나면 넘어가는건 화면 넘어오고 나서가 아니라 넘어가기전에 세팅해줘야할듯, 근데 그건 구조를 바꿔야하는거 같은데 일단 이렇게 세팅
testLoading() {
  return Stack(children: <Widget>[SpinkitTest()]);
}

class MyinfoMainBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(currentUserModel.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: testLoading());
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
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ),
                            // Container(
                            //   child: Text(
                            //     // 아이디
                            //     snapshot.data.data()['email'].toString(),
                            //     style: TextStyle(fontSize: 15),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
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
                                settings: RouteSettings(name: 'MyProduct'),
                                builder: (context) => MyProductMain()));
                          },
                          child: Column(
                            children: [
                              Icon(Icons.error_outline),
                              Text("내 상품"),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FavoriteMain(),
                                    ),
                                  );
                                },
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
                            fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      return OnestepCustomDialogNotCancel.show(
                        context,
                        title: '대학교인증 완료',
                        description:
                            '${f.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data()['authTime']))} 에 완료하셨습니다',
                        confirmButtonText: '확인',
                        confirmButtonOnPress: () {
                          Navigator.pop(context);
                        },
                      );
                    },

                    //                     AsyncSnapshot<DocumentSnapshot> snapshot) {
                    // final f = DateFormat('yyyy-MM-dd hh:mm');
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     // return object of type Dialog
                    //     return authValue == 1
                    //         ? AlertDialog(
                    //             title: Text("증명서인증 대기중"),
                    //             content: Text("대기중"),
                    //             actions: <Widget>[
                    //               ElevatedButton(
                    //                 child: Text("확인"),
                    //                 onPressed: () {
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               ),
                    //             ],
                    //           )
                    //         : AlertDialog(
                    //             title: Text("학교인증"),
                    //             content: Text(
                    //                 "${f.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.data()['authTime']))} 에 완료하셨습니다"),
                    //             actions: <Widget>[
                    //               ElevatedButton(
                    //                 child: Text("확인"),
                    //                 onPressed: () {
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               ),
                    //             ],
                    //           );
                    // snapshot.data.data()['auth'] == 1
                    //     ? _showDialog(context, 1, snapshot)
                    //     : _showDialog(context, 2, snapshot);
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 20,
                          MediaQuery.of(context).size.width / 15,
                          0,
                          MediaQuery.of(context).size.height / 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "학교 인증",
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0,
                                MediaQuery.of(context).size.width / 20, 0),
                            child: Icon(Icons.keyboard_arrow_right),
                          ),
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
                            fontWeight: FontWeight.bold, fontSize: 15.sp),
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
                          MediaQuery.of(context).size.width / 15,
                          0,
                          MediaQuery.of(context).size.height / 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "공지사항",
                              style: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0,
                                MediaQuery.of(context).size.width / 20, 0),
                            child: Icon(Icons.keyboard_arrow_right),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20,
                        MediaQuery.of(context).size.width / 30,
                        0,
                        MediaQuery.of(context).size.height / 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "문의사항",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, 0, MediaQuery.of(context).size.width / 20, 0),
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20,
                        MediaQuery.of(context).size.width / 30,
                        0,
                        MediaQuery.of(context).size.height / 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "고객센터",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, 0, MediaQuery.of(context).size.width / 20, 0),
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20,
                        MediaQuery.of(context).size.width / 30,
                        0,
                        MediaQuery.of(context).size.height / 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "개인정보 처리방침",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, 0, MediaQuery.of(context).size.width / 20, 0),
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20,
                        MediaQuery.of(context).size.width / 30,
                        0,
                        MediaQuery.of(context).size.height / 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "서비스 이용약관",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, 0, MediaQuery.of(context).size.width / 20, 0),
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20,
                        MediaQuery.of(context).size.width / 30,
                        0,
                        MediaQuery.of(context).size.height / 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "버전정보",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, 0, MediaQuery.of(context).size.width / 20, 0),
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
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
