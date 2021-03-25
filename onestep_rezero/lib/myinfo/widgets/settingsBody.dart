import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoNickNameChagnePage.dart';
import 'package:onestep_rezero/myinfo/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBody extends ConsumerWidget {
  final SharedPreferences _prefsPush;
  final SharedPreferences _prefsMarketing;
  SettingsBody(this._prefsPush, this._prefsMarketing);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _isSwitchCheckPush = watch(switchCheckPush.state);
    final _isSwitchCheckMarketing = watch(switchCheckMarketing.state);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Container(
              child: Text(
                "알림 설정",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "푸시 알림 설정",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Switch(
                    value: _isSwitchCheckPush,
                    onChanged: (value) {
                      context.read(switchCheckPush).changeSwitch(value);
                      _prefsPush.setBool('value', value);
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "마케팅 알림 설정",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Switch(
                    value: _isSwitchCheckMarketing,
                    onChanged: (value) {
                      context.read(switchCheckMarketing).changeSwitch(value);
                      _prefsMarketing.setBool('value', value);
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Container(
              child: Text(
                "사용자 설정",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => MyinfoNickNameChangePage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "닉네임 변경",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MyinfoNickNameChangePage()),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Container(
              child: Text(
                "기타",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "언어설정",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "로그아웃",
                      style: TextStyle(fontSize: 15, color: Colors.red[200]),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
