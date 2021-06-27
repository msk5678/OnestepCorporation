import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProductChatLocalController {
  //Local Image
  String getChatUserimageUrl(String chatId) {
    String imageUrl = Hive.box('localChatList').get('$chatId + image');
    return imageUrl;

    // SharedPreferences prefsChatUserImageUrls =
    //     await SharedPreferences.getInstance();
    // imageUrl = prefsChatUserImageUrls.getString(chatId);
    // print("클 2. 내부 db 값 : GetChatUserPhotoUrl : $imageUrl");
  }

  void setChatUserimageUrl(String chatId, String imageUrl) {
    if (Hive.box('localChatList').get('$chatId + image') == null ||
        Hive.box('localChatList').get('$chatId + image') != imageUrl) {
      Hive.box('localChatList').put('$chatId + image', imageUrl);
    }
    // SharedPreferences prefsChatUserImageUrls =
    //     await SharedPreferences.getInstance();
    // await prefsChatUserImageUrls.setString(chatId, imageUrl);
  }

  Widget getUserImageToChat(String chatId) {
    return Material(
      child: CachedNetworkImage(
        imageUrl: getChatUserimageUrl(chatId),
        fit: BoxFit.cover,
        height: 40,
        width: 40,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(18.0),
      ),
      clipBehavior: Clip.hardEdge,
    );
  }

  //Local NickName
  String getChatUserNickName(String chatId) {
    String nickName = Hive.box('localChatList').get('$chatId + nickName');
    return nickName;
  }

  void setChatUserNickName(String chatId, String nickName) {
    if (Hive.box('localChatList').get('$chatId + nickName') == null ||
        Hive.box('localChatList').get('$chatId + nickName') != nickName) {
      Hive.box('localChatList').put('$chatId + nickName', nickName);
    }
  }
}
