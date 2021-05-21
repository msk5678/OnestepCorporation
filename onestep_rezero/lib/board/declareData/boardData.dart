import 'package:cloud_firestore/cloud_firestore.dart';

class BoardData {
  final boardName;
  final boardExplain;
  BoardData({this.boardName, this.boardExplain});

  factory BoardData.fromFireStore(DocumentSnapshot snapshot) {
    Map boardData = snapshot.data();
    return BoardData(
      boardName: boardData["boardName"],
      boardExplain: boardData["boardExplain"] ?? '',
    );
  }
}
