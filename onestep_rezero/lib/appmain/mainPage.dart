import 'package:flutter/material.dart';

import 'bottomNavigationItem.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  static DateTime currentBackPressTime;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  bool isEnd() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("한번더 누르면 종료"),
      ));

      // _globalKey.currentState!
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(SnackBar(
      //     duration: Duration(seconds: 2),
      //     content: Text("한번더 누르면 종료"),
      //   ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
          child: Scaffold(
            // key: _globalKey,
            body: IndexedStack(
              index: _currentIndex,
              children: [
                for (final tabItem in BottomNavigationItem.items) tabItem.page,
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.black,
              currentIndex: _currentIndex,
              onTap: (int index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false, // title 안보이게 설정
              items: [
                for (final tabItem in BottomNavigationItem.items)
                  BottomNavigationBarItem(
                    icon: tabItem.icon,
                    title: tabItem.title,
                  )
              ],
            ),
          ),
          onWillPop: () async {
            bool result = isEnd();
            return await Future.value(result);
          }),
    );
  }
}
