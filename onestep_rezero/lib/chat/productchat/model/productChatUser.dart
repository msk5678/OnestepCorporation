import 'package:onestep_rezero/main.dart';

class ProductChatUser {
  //user1
  String user1Uid;
  // String user1NickName;
  // String user1ImageUrl;
  int user1ConnectTime;
  bool user1Hide;
//user2
  String user2Uid;
  // String user2NickName;
  // String user2ImageUrl;
  int user2ConnectTime;
  bool user2Hide;

  ProductChatUser({
    this.user1Uid,
    this.user1ConnectTime,
    this.user1Hide,
    this.user2Uid,
    this.user2ConnectTime,
    this.user2Hide,
  });

  ProductChatUser.forMapSnapshot(dynamic snapshot) {
    String user1;
    String user2;
    user1 = snapshot['chatUsers'].keys.toList()[0];
    user2 = snapshot['chatUsers'].keys.toList()[1];

    user1Uid = snapshot['chatUsers'][user1]['uid'];
    // user1NickName = snapshot["chatUsers"]['user1']['user1NickName'];
    // user1ImageUrl = snapshot["chatUsers"]['user1']['user1ImageUrl'];
    user1ConnectTime = snapshot['chatUsers'][user1]['connectTime'];
    user1Hide = snapshot['chatUsers'][user1]['hide'];

    user2Uid = snapshot['chatUsers'][user2]['uid'];
    // user2NickName = snapshot["chatUsers"]['user2']['uid'];
    // user2ImageUrl = snapshot["chatUsers"]['user2']['uid'];
    user2ConnectTime = snapshot['chatUsers'][user2]['connectTime'];
    user2Hide = snapshot['chatUsers'][user2]['hide'];
  }
}
