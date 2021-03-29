import 'package:flutter/material.dart';
import 'firebase_api.dart';
import 'inRealTimeChattingRoom.dart';

class RealTimeChatNavigationManager {
  static void navigateToRealTimeChattingRoom(
      var context, String myUid, String friendUid, String postId) {
    print("#### 노티 $myUid $friendUid $postId");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InRealTimeChattingRoomPage(
                  myUid: FirebaseApi.getId() == myUid ? myUid : friendUid,
                  friendId: FirebaseApi.getId() != myUid ? myUid : friendUid,
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
  //                 myUid: FirebaseApi.getId() == myUid ? myUid : friendUid,
  //                 friendId: FirebaseApi.getId() != myUid ? myUid : friendUid,
  //                 postId: postId,
  //                 boardId: boardId,
  //               )));
  // }
}
