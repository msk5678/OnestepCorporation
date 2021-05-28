import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:firebase_database/firebase_database.dart';

class CommentProvider with ChangeNotifier {
  String _errorMessage = "Comment Provider RuntimeError";
  String get errorMessage => _errorMessage;
  List<CommentData> get comments => _commentDataList;
  List<CommentData> _commentDataList = [];

  fetchData(String boardId, String postId) async {
    _commentDataList = [];
    final db = FirebaseDatabase.instance;
    await db
        .reference()
        .child('board')
        .child(boardId)
        .child(postId)
        .once()
        .then((DataSnapshot dataSnapshot) {
      _commentDataList = CommentData().fromFirebaseReference(dataSnapshot);
      // return CommentData().fromFirebaseReference(dataSnapshot);
    });
  }

  refresh(String boardId, String postId) {
    _commentDataList = [];
    fetchData(boardId, postId);
    notifyListeners();
  }
}
