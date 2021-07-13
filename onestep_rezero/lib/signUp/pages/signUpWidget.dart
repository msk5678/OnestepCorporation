import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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
      body: Padding(
        padding: EdgeInsets.only(top: 60.h),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  '한발자국',
                  style: TextStyle(
                      fontSize: 60.0.sp,
                      fontFamily: "Billabong",
                      color: Colors.black),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 100.h)),
              Container(
                child: SignInButtonBuilder(
                  image: Image(
                    image: AssetImage(
                      'assets/logos/google_dark.png',
                      package: 'flutter_signin_button',
                    ),
                    height: 36.0.h,
                  ),
                  backgroundColor: Color(0xFF4285F4),
                  width: 230.w,
                  text: "Google 계정으로 로그인",
                  fontSize: 14.0.sp,
                  padding: EdgeInsets.all(5.0),
                  onPressed: () {
                    context.read(googleSignInProvider).googleLogin();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
