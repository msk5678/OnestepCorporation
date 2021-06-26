import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep_rezero/login/widgets/JoinBody.dart';

class LoginJoinPage extends ConsumerWidget {
  final List<UserInfo> user;
  LoginJoinPage(this.user);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "회원가입",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: JoinBody(user),
    );
  }
}
