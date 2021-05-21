import 'package:cloud_firestore/cloud_firestore.dart';

class BoardData {
  final boardName;
  final boardExplain;
  final boardId;
  final boardCategory;
  BoardData(
      {this.boardName, this.boardExplain, this.boardId, this.boardCategory});

  factory BoardData.fromFireStore(DocumentSnapshot snapshot) {
    Map boardData = snapshot.data();
    return BoardData(
        boardId: snapshot.id,
        boardName: boardData["boardName"],
        boardExplain: boardData["boardExplain"] ?? '',
        boardCategory: boardData["boardCategory"] ?? '');
  }
}
