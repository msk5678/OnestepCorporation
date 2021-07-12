import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMenuItem.dart';
import 'package:onestep_rezero/chat/widget/productMenuItems.dart';
import 'package:onestep_rezero/report/pages/Deal/productReport/reportProductPage.dart';
import 'package:onestep_rezero/report/pages/reportUserPage.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialog.dart';

class ProductChatMenu {
  Widget getProductMenu(
    BuildContext context,
    String chatId,
    String friendId,
  ) {
    // FocusScopeNode currentFocus = FocusScope.of(context);

    return PopupMenuButton<ProductChatMenuItem>(
      // color: Colors.red,
      icon: Container(
        child: Icon(
          Icons.menu,
          color: Colors.black,
          // OnestepColors().mainColor,
        ),
      ),
      elevation: 0.2,
      onCanceled: () {
        FocusManager.instance.primaryFocus.unfocus();
        // _menuCanceledPrint();
      },
      onSelected: (item) {
        // print("텍스트 끝, 메뉴 선택");
        onSelected(context, item, chatId, friendId);
      },
      itemBuilder: (context) => [
        ...ProductChatMenuItems.itemsFirst.map(buildItem).toList(),
        PopupMenuDivider(),
        ...ProductChatMenuItems.itemsSecond.map(buildItem).toList(),
      ],
    );
  }

  // void _menuCanceledPrint() {
  //   print("메뉴 캔슬");
  // }

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
        OnestepCustomDialog.show(
          context,
          title: '설정',
          description: '설정으로 가시겠습니까?',
          cancleButtonText: '취소',
          confirmButtonText: '확인',
          cancleButtonOnPress: () {
            Navigator.pop(context);
          },
          confirmButtonOnPress: () {
            Fluttertoast.showToast(msg: "설정 미구현");
          },
        );

        // Fluttertoast.showToast(msg: "미구현");
        print("widget메뉴-설정");
        break;

      case ProductChatMenuItems.itemReport:
        // Fluttertoast.showToast(msg: "미구현");
        Fluttertoast.showToast(msg: "채팅 - 신고 클릭.");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReportUserPage(chatId, friendId)));

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReportUserPage(chatId, friendId)));
        // OnestepCustomDialog.show(
        //   context,
        //   title: '신고하기',
        //   description: '신고 하시겠습니까? \n신고 화면으로 넘어갑니다.',
        //   cancleButtonText: '취소',
        //   confirmButtonText: '신고',
        //   confirmButtonOnPress: () {
        //     // ChatBlockController().blockToUser(friendId);
        //     Navigator.pop(context);
        //     // Navigator.pop(context);
        //     // Fluttertoast.showToast(msg: "차단되었습니다.");
        //   },
        // );

        print("widget메뉴-차단");
        break;

      case ProductChatMenuItems.itemBlock:
        // Fluttertoast.showToast(msg: "미구현");

        OnestepCustomDialog.show(
          context,
          title: '차단(항후 차단 <-> 차단 해제 변경)',
          description: '상대를 차단할 경우 채팅이 불가합니다.\n\n' + '차단하시겠습니까? 현재 기능 비활성화',
          cancleButtonText: '취소',
          confirmButtonText: '차단',
          cancleButtonOnPress: () {
            Navigator.pop(context);
          },
          confirmButtonOnPress: () {
            // ChatBlockController().blockToUser(friendId);
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "차단되었습니다.");
          },
        );

        print("widget메뉴-차단");
        break;

      case ProductChatMenuItems.itemExit:
        OnestepCustomDialog.show(
          context,
          title: '',
          description: '채팅방을 나갈 경우 기존 대화가 모두 사라집니다. \n\n' + '나가시겠습니까?',
          cancleButtonText: '취소',
          confirmButtonText: '나가기',
          cancleButtonOnPress: () {
            Navigator.pop(context);
          },
          confirmButtonOnPress: () {
            ProductChatController().exitProductChat(chatId);
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(msg: '채팅방을 나갔습니다.');

            print("widget나가기");
          },
        );

        break;
    }
  }
}
