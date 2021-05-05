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
    return {
      "chatId": chatId,
      "chatCount": chatCount,
      "timeStamp": timeStamp,
    };
  }
}
