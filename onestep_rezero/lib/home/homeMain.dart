import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep_rezero/home/pages/homeNotificationPage.dart';
import 'package:onestep_rezero/login/pages/loginJoinPage.dart';
import 'package:onestep_rezero/report/reportPageTest.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';
import 'package:onestep_rezero/search/pages/searchMain.dart';

import '../main.dart';
import '../sendMail.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("홈"),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SearchMain(searchKey: 0)),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none),
                    color: Colors.black,
                    onPressed: () {
                      // 회원가입 넘어가는 부분
                      GoogleSignInAccount user = googleSignIn.currentUser;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginJoinPage(user)));

                      // 알림으로 넘어가는 부분
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => HomeNotificationPage(),
                      // ));

                      // 신고 page test
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => ReportPageTest()));
                    },
                  ),
                  // 추후에 시간남으면 수정해서 추가하기
                  // StreamBuilder(
                  //     stream: p.watchNotificationAll(),
                  //     builder: (context, snapshot) {
                  //       switch (snapshot.connectionState) {
                  //         case ConnectionState.waiting:
                  //           return Positioned(
                  //             top: 8,
                  //             right: 10,
                  //             child: Icon(
                  //                 // check 다 했으면 아이콘이 없는 쪽으로 코드 변경
                  //                 null),
                  //           );

                  //         default:
                  //           bool chk = true;
                  //           if (snapshot.data != null) {
                  //             List<NotificationChk> notiList = snapshot.data;
                  //             chk = notiList.isEmpty;
                  //           }
                  //           return Positioned(
                  //             top: 8,
                  //             right: 10,
                  //             child: chk
                  //                 ? Container()
                  //                 : Icon(
                  //                     Icons.brightness_1,
                  //                     color: Colors.red,
                  //                     size: 15,
                  //                   ),
                  //           );
                  //       }
                  //     }),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: Container(),
    );
  }
}
