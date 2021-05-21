class ProductChatListCount {
  String chatId;
  int chatCount;
  String sendTime;

  ProductChatListCount({
    this.chatId,
    this.chatCount,
    this.sendTime,
  });

  ProductChatListCount.forMapSnapshot(
      String key, int unreadchat, dynamic chatsnapshot) {
    chatId = key;
    chatCount = unreadchat;
    // print("리얼타임 메세지 처리 - 프로덕트 리스트2 : 내부 진입 ");

    // print("리얼타임 메세지 처리 - 프로덕트 리스트3 : ${chatsnapshot.toString()}");
    // print("리얼타임 메세지 처리 - 프로덕트 리스트4 : ${chatsnapshot['chatUsers']}");
    // print("리얼타임 메세지 처리 - 프로덕트 리스트5 : ${chatsnapshot['message']}");

    // print("리얼타임 메세지 처리 - 프로덕트 리스트6 : ${chatsnapshot['recentTime']}");
    sendTime = chatsnapshot["recentTime"];
    // print("리얼타임 메세지 처리 - 프로덕트 리스트6완료");
  }

  toJson() {
    return {
      "chatId": chatId,
      "chatCount": chatCount,
      "sendTime": sendTime,
    };
  }
}
