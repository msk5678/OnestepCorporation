class ProductChatListCount {
  String chatId;
  int chatCount;
  String timeStamp;

  ProductChatListCount({
    this.chatId,
    this.chatCount,
    this.timeStamp,
  });

  ProductChatListCount.forMapSnapshot(
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
