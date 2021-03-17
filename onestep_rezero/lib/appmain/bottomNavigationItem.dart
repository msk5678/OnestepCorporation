import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/boardMain.dart';
import 'package:onestep_rezero/home/homeMain.dart';
import 'package:onestep_rezero/myinfo/myinfoMain.dart';
import 'package:onestep_rezero/notification/notificationMain.dart';
import 'package:onestep_rezero/product/pages/productMain.dart';

class BottomNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  BottomNavigationItem({
    this.page,
    this.title,
    this.icon,
  });

  static List<BottomNavigationItem> get items => [
        BottomNavigationItem(
          page: HomeMain(),
          icon: Icon(Icons.home),
          title: Text("홈"),
        ),
        BottomNavigationItem(
          page: ProductMain(),
          icon: Icon(Icons.shopping_cart),
          title: Text("장터"),
        ),
        BottomNavigationItem(
          page: BoardMain(),
          icon: Icon(Icons.list),
          title: Text("게시판"),
        ),
        BottomNavigationItem(
          page: NotificationMain(),
          icon: Icon(Icons.notifications_none),
          title: Text("알림"),
        ),
        BottomNavigationItem(
          page: MyInfoMain(),
          icon: Icon(Icons.person_outline),
          title: Text("내정보"),
        ),
      ];
}
