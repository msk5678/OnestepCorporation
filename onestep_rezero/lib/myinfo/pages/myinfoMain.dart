import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/widgets/mainBody.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myinfoSettingsPage.dart';

class MyInfoMain extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '내정보',
                style: TextStyle(color: Colors.black),
              ),
              IconButton(
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
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: MyinfoMainBody());
  }
}
