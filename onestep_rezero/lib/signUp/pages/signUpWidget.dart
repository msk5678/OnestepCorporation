import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/signIn/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpWidget extends StatefulWidget {
  SignUpWidget({Key key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 240.0.h),
          child: Column(
            children: <Widget>[
              Text(
                '한발자국',
                style: TextStyle(
                    fontSize: 60.0.sp,
                    fontFamily: "Billabong",
                    color: Colors.black),
              ),
              Padding(padding: EdgeInsets.only(bottom: 100.0.h)),
              GestureDetector(
                onTap: () => {
                  context.read(googleSignInProvider).googleLogin(),
                },
                child: Container(child: Text("구글 로그인")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
