import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMenuItem.dart';
import 'package:onestep_rezero/chat/widget/productMenuItems.dart';

class ProductChatMenu {
  Widget getProductMenu(BuildContext context, String chatId) {
    return PopupMenuButton<ProductChatMenuItem>(
      onSelected: (item) => onSelected(context, item, chatId),
      itemBuilder: (context) => [
        ...ProductChatMenuItems.itemsFirst.map(buildItem).toList(),
        PopupMenuDivider(),
        ...ProductChatMenuItems.itemsSecond.map(buildItem).toList(),
      ],
    );
  }

  PopupMenuItem<ProductChatMenuItem> buildItem(ProductChatMenuItem item) =>
      PopupMenuItem(
          value: item,
          child: Row(
            children: [
              Icon(item.icon, color: Colors.black, size: 20),
              const SizedBox(
                width: 12,
              ),
              Text(item.text),
            ],
          ));

  void onSelected(
      BuildContext context, ProductChatMenuItem item, String chatId) {
    switch (item) {
      case ProductChatMenuItems.itemSettings:
        Fluttertoast.showToast(msg: "미구현");
        print("widget메뉴-설정");
        break;
      case ProductChatMenuItems.itemShare:
        Fluttertoast.showToast(msg: "미구현");
        print("widget메뉴-공유");
        break;

      case ProductChatMenuItems.itemExit:
        Fluttertoast.showToast(msg: "채팅방을 나갑니다..");
        ProductChatController().exitProductChat(chatId);
        Navigator.pop(context);
        print("widget나가기");
        break;
    }
  }
}
