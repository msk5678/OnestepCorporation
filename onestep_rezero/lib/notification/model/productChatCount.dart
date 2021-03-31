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
    timeStamp = chatsnapshot["timestamp"];
  }

  toJson() {
    print("리얼타임 투제이슨 실행");
    //print("리얼타임내부:" + boardType);
    return {
      "chatId": chatId,
      "chatCount": chatCount,
      "timeStamp": timeStamp,
    };
  }
}
