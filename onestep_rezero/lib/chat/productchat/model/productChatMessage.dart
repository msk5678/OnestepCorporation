class ProductChatMessage {
  String content;
  String idFrom;
  String idTo;
  bool isRead;
  String sendTime;
  int type;

  ProductChatMessage({
    this.content,
    this.idFrom,
    this.idTo,
    // this.isRead,
    this.sendTime,
    this.type,
  });

  ProductChatMessage.forMapSnapshot(dynamic snapshot) {
    content = snapshot["content"];
    idFrom = snapshot["idFrom"];
    idTo = snapshot["idTo"].keys.toList()[0];
    isRead = snapshot['idTo'].values.toList()[0];
    sendTime = snapshot["sendTime"];
    type = snapshot["type"];
  }

  ProductChatMessage.forReadMapSnapshot(dynamic snapshot) {
    content = snapshot["content"];
    idFrom = snapshot["idFrom"];
    idTo = snapshot["idTo"].keys.toList()[0];
    isRead = true;
    sendTime = snapshot["sendTime"];
    type = snapshot["type"];
  }

  toJson() {
    return {
      "content": content,
      "idFrom": idFrom,
      "idTo": idTo,
      "isRead": isRead,
      "sendTime": sendTime,
      "type": type,
    };
  }
}
