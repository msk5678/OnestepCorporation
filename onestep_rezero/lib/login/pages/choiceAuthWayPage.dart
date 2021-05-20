import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onestep_rezero/login/pages/loginAuthPage.dart';
import 'package:onestep_rezero/login/pages/loginCertificatePage.dart';
import 'package:onestep_rezero/notification/realtime/firebase_api.dart';

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("증명서인증 대기중"),
        content: Text("증명서인증 대기중입니다"),
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

class ChoiceAuthWayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Navigator.pop(context, false);
        return Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            "인증방법선택",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseApi.getId())
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("onestep 어플을 이용하시려면"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, 0, MediaQuery.of(context).size.height / 10),
                      child: Container(
                        child: Text("학교인증을 필수로 해주셔야합니다"),
                      ),
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (snapshot.data.data()['auth'] == 1) {
                                    _showDialog(context);
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginCertificatePage()));
                                  }
                                },
                                child: Container(
                                  child: Text("증명서"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text("증명서로 인증하기"),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginAuthPage()));
                                },
                                child: Container(
                                  child: Text("이메일"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text("학교이메일로 인증하기"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
