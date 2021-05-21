import 'package:flutter/material.dart';

class ProductSendMessage {
  String contentMsg;
  int type;
  String friendId;
  String postId;
  String chattingRoomId;
  TextEditingController textEditingController;
  ScrollController listScrollController;

  ProductSendMessage({
    this.contentMsg,
    this.type,
    this.friendId,
    this.postId,
    this.chattingRoomId,
    this.textEditingController,
    this.listScrollController,
  });

  ProductSendMessage.forMapSnapshot(contentMsg, type, friendId, postId,
      chattingRoomId, textEditingController, listScrollController) {
    this.contentMsg = contentMsg;
    this.type = type;
    this.friendId = friendId;
    this.postId = postId;
    this.chattingRoomId = chattingRoomId;
    this.textEditingController = textEditingController;
    this.listScrollController = listScrollController;
  }
}
