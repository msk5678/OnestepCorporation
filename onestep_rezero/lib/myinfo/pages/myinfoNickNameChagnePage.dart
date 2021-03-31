import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/widgets/nickNameChangeBody.dart';

String _tempNickName = "";
bool _firstEnter = true;

class MyinfoNickNameChangePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return WillPopScope(
      onWillPop: () {
        _tempNickName = "";
        _firstEnter = true;
        Navigator.pop(context, false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              '설정',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: NickNameChangeBody(_tempNickName, _firstEnter)),
    );
  }
}
