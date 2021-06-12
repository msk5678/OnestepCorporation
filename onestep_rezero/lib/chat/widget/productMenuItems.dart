import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMenuItem.dart';

class ProductChatMenuItems {
  static const List<ProductChatMenuItem> itemsFirst = [
    itemSettings,
    itemShare,
  ];
  static const List<ProductChatMenuItem> itemsSecond = [
    itemExit,
  ];

  static const itemSettings = ProductChatMenuItem(
    text: 'Settings',
    icon: Icons.settings,
  );

  static const itemShare = ProductChatMenuItem(
    text: 'Share',
    icon: Icons.share,
  );

  static const itemExit = ProductChatMenuItem(
    text: 'Exit',
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
