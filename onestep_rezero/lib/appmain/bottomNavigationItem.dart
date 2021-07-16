import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/boardMain.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatMainController.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoMain.dart';
import 'package:onestep_rezero/chat/page/chatMain.dart';
import 'package:onestep_rezero/product/pages/product/productAddMain.dart';
import 'package:onestep_rezero/product/pages/product/productMain.dart';

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
          icon: Icon(Icons.home),
          title: "홈",
        ),
        BottomNavigationItem(
          page: BoardMain(),
          icon: Icon(Icons.list),
          title: "게시판",
        ),
        BottomNavigationItem(
          page: ProductAddMain(),
          icon: Icon(Icons.add_rounded),
          title: "상품 등록",
        ),
        BottomNavigationItem(
          page: ChatMain(),
          icon: ProductChatMainController().getTotalChatCountInBottomBar(),
          //Icon(Icons.chat_outlined),
          title: "채팅",
        ),
        BottomNavigationItem(
          page: MyInfoMain(),
          icon: Icon(Icons.person_outline),
          title: "내정보",
        ),
      ];
}
