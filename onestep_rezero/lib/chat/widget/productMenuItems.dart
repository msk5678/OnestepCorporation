import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMenuItem.dart';

class ProductChatMenuItems {
  static const List<ProductChatMenuItem> itemsFirst = [
    itemSettings,
    itemReport,
    itemBlock,
  ];
  static const List<ProductChatMenuItem> itemsSecond = [
    itemExit,
  ];

  static const itemSettings = ProductChatMenuItem(
    text: '설정',
    icon: Icons.settings,
  );

  static const itemReport = ProductChatMenuItem(
    text: '신고',
    icon: Icons.report,
  );

  static const itemBlock = ProductChatMenuItem(
    text: '차단',
    icon: Icons.block,
  );

  static const itemExit = ProductChatMenuItem(
    text: '나가기',
    icon: Icons.exit_to_app_rounded,
  );

  // Widget getProductChatMenu(){
  // return PopupMenuButton<ProductChatMenuItem>(
  //   itemBuilder : (context) => [
  //     ...ProductChatMenuItems.itemsFirst,
  //   ]
  //   ,
  // );
  // }
}
