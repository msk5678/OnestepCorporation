class ProductMessage {
  String content;
  String idFrom;
  String idTo;
  bool isRead;
  String timestamp;
  int type;

  ProductMessage({
    this.content,
    this.idFrom,
    this.idTo,
    // this.isRead,
    this.timestamp,
    this.type,
  });

  ProductMessage.forMapSnapshot(dynamic snapshot) {
    content = snapshot["content"];
    idFrom = snapshot["idFrom"];
    idTo = snapshot["idTo"].keys.toList()[0];
    isRead = snapshot['idTo'].values.toList()[0];
    timestamp = snapshot["timestamp"];
    type = snapshot["type"];
  }

  toJson() {
    return {
      "content": content,
      "idFrom": idFrom,
      "idTo": idTo,
      "isRead": isRead,
      "timestamp": timestamp,
      "type": type,
    };
  }
}
