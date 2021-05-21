import 'package:onestep_rezero/chat/productchat/model/productChatUser.dart';

class ProductChatList {
  //productChatInfo
  String chatId;
  String postId;
  String createTime;
  String recentTime;
  String recentText;
  //chatUsers
  ProductChatUser chatUsers;

  //user1['nickName'] = 'dd'; //str
  //user1['imageUrl'] = 'dd'; //str
  //user1['uid'] = 'dd'; //str
  //user1['connectTime'] = 'dd'; //int
  //user1['hide'] = 'bool';

  ProductChatList({
    this.chatId,
    this.postId,
    this.createTime,
    this.recentTime,
    this.recentText,
  });

  ProductChatList.forMapSnapshot(dynamic snapshot) {
    print("##@#채팅방 생성@#@# ${snapshot["chatId"]} ${snapshot["chatUsers"]}");
    //print("##@#채팅방 생성@#@# ${snapshot["chatUsers"][0]}");
    //productChatInfo
    chatId = snapshot["chatId"];
    postId = snapshot["postId"];
    createTime = snapshot["createTime"];
    recentTime = snapshot["recentTime"];
    recentText = snapshot["recentText"];
    chatUsers = ProductChatUser.forMapSnapshot(snapshot);
  }
}
