import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';

class CommentProvider with ChangeNotifier {
  String _errorMessage = "Comment Provider RuntimeError";
  String get errorMessage => _errorMessage;
  List<CommentData> get comments => _commentDataList;
  List<CommentData> _commentDataList = [];
  bool _isFetching = false;
  fetchData(String boardId, String postId) async {
    if (_isFetching) return;
    _isFetching = true;
    _commentDataList = [];
    final db = FirebaseDatabase.instance;

    _commentDataList = await db
        .reference()
        .child('board')
        .child(boardId.toString())
        .child(postId.toString())
        .orderByKey()
        // .orderByChild("uploadTime")
        .once()
        .then((DataSnapshot dataSnapshot) {
      return CommentData().fromFirebaseReference(dataSnapshot);
    }).whenComplete(() {
      _isFetching = false;
    });

    _isFetching = false;
    notifyListeners();
  }

  fetchUserWrittenComment(String uid) async {
    if (_isFetching) return;
    _isFetching = true;
    _commentDataList = [];
    final db = FirebaseDatabase.instance;

    _commentDataList = await db
        .reference()
        .child('board')
        // .orderByChild("uploadTime")
        .once()
        .then((DataSnapshot dataSnapshot) {
      print("dataSnapshot : ${dataSnapshot.value}");
      // return CommentData().fromFirebaseReference(dataSnapshot);
    }).whenComplete(() {
      _isFetching = false;
    });

    _isFetching = false;
    notifyListeners();
  }

  refresh(String boardId, String postId) {
    // _commentDataList = [];
    fetchData(boardId, postId);
    notifyListeners();
  }

  clear() {}
}
