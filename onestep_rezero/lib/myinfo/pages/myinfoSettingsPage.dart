import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/widgets/settingsBody.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyinfoSettingsPage extends ConsumerWidget {
  final SharedPreferences _prefsPush;
  final SharedPreferences _prefsMarketing;
  MyinfoSettingsPage(this._prefsPush, this._prefsMarketing);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '설정',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SettingsBody(_prefsPush, _prefsMarketing));
  }
}
