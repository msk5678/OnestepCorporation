import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/boardchat/inRealTimeChattingRoom.dart';
import 'package:onestep_rezero/chat/productchat/productchattingroom/productChattingRoom.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/models/product.dart';

class RealTimeChatNavigationManager {
  static void navigateToRealTimeChattingRoom(
      var context, String myUid, String friendUid, String postId) {
    print("#### 노티 $myUid $friendUid $postId");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InRealTimeChattingRoomPage(
                  myUid: googleSignIn.currentUser.id.toString() == myUid
                      ? myUid
                      : friendUid,
                  friendId: googleSignIn.currentUser.id.toString() != myUid
                      ? myUid
                      : friendUid,
                  postId: postId,
                )));
  }

  //기존 장터 챗 리스트에서 채팅방으로 넘어가는 경우
  static void navigateToProductChattingRoom(
      var context, String myUid, String friendUid, String postId) {
    print("#### 노티 $myUid $friendUid $postId");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductChattingRoomPage(
                  myUid: googleSignIn.currentUser.id.toString() == myUid
                      ? myUid
                      : friendUid,
                  friendId: googleSignIn.currentUser.id.toString() != myUid
                      ? myUid
                      : friendUid,
                  postId: postId,
                  product: null,
                )));
  }

  //장터에서 채팅방으로 넘어가는 경우 -> 초기 메세지 저장
  static void navigateProductToProductChat(var context, String myUid,
      String friendUid, String postId, Product product) {
    //1. 나인지 판별( 나면 못넘어감)

    //2. 나 아니면 (디비 저장 후에 )
    print("#### 노티 $myUid $friendUid $postId");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductChattingRoomPage(
                  myUid: googleSignIn.currentUser.id.toString() == myUid
                      ? myUid
                      : friendUid,
                  friendId: googleSignIn.currentUser.id.toString() != myUid
                      ? myUid
                      : friendUid,
                  postId: postId,
                  product: product,
                )));
  }

  // static void navigateToProductChattingRoom(
  //     var context, String myUid, String friendUid, String postId) {
  //   print("#### 노티 $myUid $friendUid $postId");
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => ProductChattingRoomPage(
  //                 myUid: googleSignIn.currentUser.id.toString() == myUid
  //                     ? myUid
  //                     : friendUid,
  //                 friendId: googleSignIn.currentUser.id.toString() != myUid
  //                     ? myUid
  //                     : friendUid,
  //                 postId: postId,
  //               )));
  // }

  // static void navigateToBoardChattingRoom(var context, String myUid,
  //     String friendUid, String boardId, String postId) {
  //   print("#### 노티 $myUid $friendUid $boardId $postId");
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => InBoardChattingRoomPage(
  //                 myUid: googleSignIn.currentUser.id.toString() == myUid ? myUid : friendUid,
  //                 friendId: googleSignIn.currentUser.id.toString() != myUid ? myUid : friendUid,
  //                 postId: postId,
  //                 boardId: boardId,
  //               )));
  // }
}
