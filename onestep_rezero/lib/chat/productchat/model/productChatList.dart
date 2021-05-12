import 'package:onestep_rezero/chat/productchat/model/productChatUser.dart';

class ProductChatList {
  //productChatInfo
  String chatId;
  String postId;
  String createTime;
  String recentTime;
  String recentText;
  //chatUsers
  ProductChatUser user1;
  ProductChatUser user2;

  //user1['nickName'] = 'dd'; //str
  //user1['imageUrl'] = 'dd'; //str
  //user1['uid'] = 'dd'; //str
  //user1['connextTime'] = 'dd'; //int
  //user1['hide'] = 'bool';

  ProductChatList({
    this.chatId,
    this.postId,
    this.createTime,
    this.recentTime,
    this.recentText,
  });

  ProductChatList.forMapSnapshot(dynamic snapshot) {
    //productChatInfo
    chatId = snapshot["chatId"];
    postId = snapshot["postId"];
    createTime = snapshot["createTime"];
    recentTime = snapshot["recentTime"];
    recentText = snapshot["recentText"];
    user1 = ProductChatUser.forMapSnapshot(snapshot);
    user2 = ProductChatUser.forMapSnapshot(snapshot);
  }
}
