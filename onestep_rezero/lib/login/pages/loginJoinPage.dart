import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/login/widgets/JoinBody.dart';

class LoginJoinPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "회원가입",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: JoinBody(),
    );
  }
}
