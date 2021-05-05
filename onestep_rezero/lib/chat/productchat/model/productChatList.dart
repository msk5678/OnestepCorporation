import 'package:firebase_database/firebase_database.dart';

class ProductChatList {
  String boardType;
  String title;
  String postId;
  String user1;
  String user2;
  String friendNickName;
  String friendImageUrl;
  String recentText;
  String timeStamp;
  String chatId;
  String users;

  ProductChatList({
    this.boardType,
    this.title,
    this.postId,
    this.friendNickName,
    this.friendImageUrl,
    // this.user1,
    // this.user2,
    this.chatId,
    this.recentText,
    this.timeStamp,
    this.users,
  });

  ProductChatList.forMapSnapshot(dynamic snapshot) {
    chatId = snapshot["chatId"];
    boardType = snapshot["boardtype"];
    title = snapshot["title"];
    postId = snapshot["postId"];
    friendNickName = snapshot["friendNickName"];
    friendImageUrl = snapshot["friendImageUrl"];
    recentText = snapshot["recentText"];
    timeStamp = snapshot["timestamp"];
    users = snapshot["users"].toString();
    user1 = snapshot['users'].keys.toList()[0];
    user2 = snapshot['users'].keys.toList()[1];
  }

//채팅방 ID
  DatabaseReference createChatID(String chatId) {
    return FirebaseDatabase.instance.reference().child("path").child(chatId);
  }

  createChat(String chatId) {
    createChatID(chatId).set(toJson());
  }

  toJson() {
    return {
      "boardtype": boardType,
      "title": title,
      "postId": postId,
      "friendNickName": friendNickName,
      "friendImageUrl": friendImageUrl,
      "recentText": recentText,
      "timestamp": timeStamp,
      "users": [user1, user2],
    };
  }
}
