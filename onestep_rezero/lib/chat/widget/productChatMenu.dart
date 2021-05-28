import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMenuItem.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/chat/widget/productMenuItems.dart';
import 'package:onestep_rezero/chat/productchat/controller/chatBlockController.dart';

class ProductChatMenu {
  Widget getProductMenu(BuildContext context, String chatId, String friendId) {
    return PopupMenuButton<ProductChatMenuItem>(
      // color: Colors.red,
      icon: Container(
        child: Icon(
          Icons.menu,
          color: Colors.black,
          // OnestepColors().mainColor,
        ),
      ),
      onSelected: (item) => onSelected(context, item, chatId, friendId),
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

  void onSelected(BuildContext context, ProductChatMenuItem item, String chatId,
      String friendId) {
    switch (item) {
      case ProductChatMenuItems.itemSettings:
        Fluttertoast.showToast(msg: "미구현");
        print("widget메뉴-설정");
        break;
      case ProductChatMenuItems.itemBlock:
        // Fluttertoast.showToast(msg: "미구현");
        ChatBlockController().blockToUser(friendId);
        print("widget메뉴-차단");
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
