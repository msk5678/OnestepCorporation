import 'package:flutter/material.dart';
import 'package:onestep_rezero/admob/googleAdmob.dart';
import 'package:onestep_rezero/appmain/bottomNavigationItem.dart';
import 'package:onestep_rezero/util/floatingSnackBar.dart';

class AppMain extends StatefulWidget {
  AppMain({Key key}) : super(key: key);

  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  static DateTime currentBackPressTime;
  int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    bool isEnd() {
      DateTime now = DateTime.now();

      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;

        FloatingSnackBar.show(
          context,
          "버튼을 한번 더 누르시면 종료됩니다.",
        );

        return false;
      }
      return true;
    }

    return SafeArea(
      child: WillPopScope(
          child: Scaffold(
            body: Stack(
              children: [
                IndexedStack(
                  index: _currentIndex,
                  children: [
                    for (final tabItem in BottomNavigationItem.items)
                      tabItem.page,
                  ],
                ),
                if (_currentIndex == 3)
                  Positioned(
                    child: GoogleAdmob().getChatMainBottomBanner(deviceWidth),
                    bottom: 0,
                  ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.black,
              currentIndex: _currentIndex,
              onTap: (int index) {
                if (index == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BottomNavigationItem.items[index].page));
                } else if (_currentIndex != index)
                  setState(() => _currentIndex = index);
              },
              type: BottomNavigationBarType.fixed,
              // showSelectedLabels: false,
              // showUnselectedLabels: false, // title 안보이게 설정
              items: [
                for (final tabItem in BottomNavigationItem.items)
                  BottomNavigationBarItem(
                    icon: tabItem.icon,
                    label: tabItem.title,
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
