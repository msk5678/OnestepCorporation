import 'package:flutter/material.dart';
import 'package:onestep_rezero/main.dart';
import 'inRealTimeChattingRoom.dart';

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
