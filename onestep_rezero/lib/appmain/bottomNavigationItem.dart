import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/boardMain.dart';
import 'package:onestep_rezero/home/homeMain.dart';
import 'package:onestep_rezero/home/pages/homeMain.dart';
import 'package:onestep_rezero/login/pages/loginJoinPage.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoMain.dart';
import 'package:onestep_rezero/notification/page/chatMain.dart';
import 'package:onestep_rezero/notification/realtime/realtimeProductChatController.dart';
import 'package:onestep_rezero/product/pages/productMain.dart';

class BottomNavigationItem {
  final Widget page;
  final String title;
  final Widget icon;

  BottomNavigationItem({
    this.page,
    this.title,
    this.icon,
  });

  static List<BottomNavigationItem> get items => [
        BottomNavigationItem(
          page: HomeMain(),
          icon: Icon(Icons.home),
          title: "홈",
        ),
        BottomNavigationItem(
          page: ProductMain(),
          icon: Icon(Icons.shopping_cart),
          title: "장터",
        ),
        BottomNavigationItem(
          // page: BoardMain(),
          page: LoginJoinPage(),
          icon: Icon(Icons.list),
          title: "게시판",
        ),
        BottomNavigationItem(
          page: LoginJoinPage(),
          icon: Icon(Icons.list),
          // page: ChatMainPage(),
          // icon: RealtimeProductChatController().getTotalChatCountInBottomBar(),
          title: "알림",
        ),
        BottomNavigationItem(
          page: MyInfoMain(),
          icon: Icon(Icons.person_outline),
          title: "내정보",
        ),
      ];
}
