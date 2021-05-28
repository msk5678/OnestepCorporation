import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMenuItem.dart';

class ProductChatMenuItems {
  static const List<ProductChatMenuItem> itemsFirst = [
    itemSettings,
    itemBlock,
  ];
  static const List<ProductChatMenuItem> itemsSecond = [
    itemExit,
  ];

  static const itemSettings = ProductChatMenuItem(
    text: 'Settings',
    icon: Icons.settings,
  );

  static const itemBlock = ProductChatMenuItem(
    text: 'Block',
    icon: Icons.block,
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
