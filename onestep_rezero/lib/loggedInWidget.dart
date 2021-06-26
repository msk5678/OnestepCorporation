import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBA;
import 'package:flutter/material.dart';
import 'package:onestep_rezero/appMain.dart';
import 'package:onestep_rezero/login/model/user.dart';
import 'package:onestep_rezero/login/pages/loginAuthPage.dart';
import 'package:onestep_rezero/login/pages/termsPage.dart';

User currentUserModel;

class LoggedInWidget extends StatefulWidget {
  final String user;
  LoggedInWidget({Key key, this.user}) : super(key: key);

  @override
  _LoggedInWidgetState createState() => _LoggedInWidgetState();
}

class _LoggedInWidgetState extends State<LoggedInWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(widget.user)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(child: Text("hasError"));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();

            default:
              DocumentSnapshot userRecord = snapshot.data;

              if (userRecord.data() == null) {
                return TermsPage(
                    FBA.FirebaseAuth.instance.currentUser.providerData);
              } else {
                currentUserModel = User.fromDocument(userRecord);
                if (currentUserModel.auth == 1) {
                  // GoogleSignInAccount user = GoogleSignIn().currentUser;

                  // 증명서 대기 페이지
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) => AuthWaitPage()));
                  // 이메일 인증 페이지
                  return LoginAuthPage(
                      FBA.FirebaseAuth.instance.currentUser.providerData);
                } else {
                  return AppMain();
                }
              }
          }
        });
  }
}
