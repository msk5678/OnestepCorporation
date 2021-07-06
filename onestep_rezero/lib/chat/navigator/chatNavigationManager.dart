import 'package:flutter/material.dart';

import 'package:onestep_rezero/chat/boardchat/inRealTimeChattingRoom.dart';
import 'package:onestep_rezero/chat/page/anonymousChatPage.dart';
import 'package:onestep_rezero/chat/productchat/productchattingroom/productChattingRoom.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

import 'package:onestep_rezero/product/models/product.dart';

class ChatNavigationManager {
  //1. Product
  //1-1. List -> ProductChat
  static void navigateToProductChattingRoom(
      var context, String myUid, String friendUid, String postId) {
    //print("#### $myUid $friendUid $postId");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductChattingRoomPage(
                  myUid: currentUserModel.uid == myUid ? myUid : friendUid,
                  friendId: currentUserModel.uid != myUid ? myUid : friendUid,
                  postId: postId,
                  product: null,
                )));
  }

  //1-2. Product -> ProductChat
  static void navigateProductToProductChat(var context, String myUid,
      String friendUid, String postId, Product product) {
    print("#### $myUid $friendUid $postId ${product.title}");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductChattingRoomPage(
                  myUid: currentUserModel.uid == myUid ? myUid : friendUid,
                  friendId: currentUserModel.uid != myUid ? myUid : friendUid,
                  postId: postId,
                  product: product,
                )));
  }

  //2. Board
  //2-1. BoardChat
  static void navigateToRealTimeChattingRoom(
      var context, String myUid, String friendUid, String postId) {
    print("#### $myUid $friendUid $postId");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InRealTimeChattingRoomPage(
                  myUid: currentUserModel.uid == myUid ? myUid : friendUid,
                  friendId: currentUserModel.uid != myUid ? myUid : friendUid,
                  postId: postId,
                )));
  }

  static void navigateToAnonymousChattingRoom(var context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnonymousChattingRoomPage(),
      ),
    );
  }
}
