class ProductChatCount {
  String chatId;
  int chatCount;
  String timeStamp;

  ProductChatCount({
    this.chatId,
    this.chatCount,
    this.timeStamp,
  });

  ProductChatCount.forMapSnapshot(
      String key, int unreadchat, dynamic chatsnapshot) {
    chatId = key;
    chatCount = unreadchat;
    print("리얼타임 메세지 처리 2 : 내부 진입 ");

    print("리얼타임 메세지 처리 3 : ${chatsnapshot.toString()}");
    print("리얼타임 메세지 처리 4 : ${chatsnapshot['chatUsers']}");
    print("리얼타임 메세지 처리 5 : ${chatsnapshot['message']}");

    print("리얼타임 메세지 처리 6 : ${chatsnapshot['timestamp']}");
    timeStamp = chatsnapshot["timestamp"];
    print("리얼타임 메세지 내부 처리 완료");
  }

  toJson() {
    return {
      "chatId": chatId,
      "chatCount": chatCount,
      "timeStamp": timeStamp,
    };
  }
}
