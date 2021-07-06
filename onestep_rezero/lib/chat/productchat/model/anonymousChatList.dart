import 'package:onestep_rezero/chat/productchat/model/productChatUser.dart';

class AnonymousChatList {
  //productChatInfo
  String uid;
  String nickName;
  String content;
  String sendTime;
  //chatUsers
  ProductChatUser chatUsers;

  //user1['nickName'] = 'dd'; //str
  //user1['imageUrl'] = 'dd'; //str
  //user1['uid'] = 'dd'; //str
  //user1['connectTime'] = 'dd'; //int
  //user1['hide'] = 'bool';

  AnonymousChatList({
    this.uid,
    this.nickName,
    this.content,
    this.sendTime,
  });

  AnonymousChatList.forMapSnapshot(dynamic snapshot) {
    uid = snapshot["idFrom"]['uid'];
    nickName = snapshot["idFrom"]['nickName'];
    content = snapshot["content"];
    sendTime = snapshot["sendTime"];
  }
}
