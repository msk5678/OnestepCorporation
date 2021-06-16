import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/boardMain.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/home/homeMain.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoMain.dart';
// import 'package:onestep_rezero/notification/page/chatMain.dart';
import 'package:onestep_rezero/chat/page/chatMain.dart';
import 'package:onestep_rezero/product/pages/product/productMain.dart';
// import 'package:onestep_rezero/notification/realtime/realtimeProductChatController.dart' aaaaa;

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
          page: ProductMain(),
          icon: Icon(Icons.shopping_cart),
          title: "홈",
        ),
        BottomNavigationItem(
          page: HomeMain(),
          icon: Icon(Icons.add_rounded),
          title: "물품 등록",
        ),
        BottomNavigationItem(
          page: BoardMain(),
          icon: Icon(Icons.list),
          title: "게시판",
        ),
        BottomNavigationItem(
          page: ChatMainPage(),
          icon: ProductChatController().getTotalChatCountInBottomBar(),
          //Icon(Icons.chat_outlined),
          title: "알림",
        ),
        BottomNavigationItem(
          page: MyInfoMain(),
          icon: Icon(Icons.person_outline),
          title: "내정보",
        ),
      ];
}
