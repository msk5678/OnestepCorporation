import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';

class CommentProvider with ChangeNotifier {
  String _errorMessage = "Comment Provider RuntimeError";
  String get errorMessage => _errorMessage;
  List<CommentData> get comments => _commentDataList;
  bool get isFetching => _isFetching;
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
    List<UserWrittenCommentData> _userWrittenCommentList = [];
    final db = FirebaseDatabase.instance;
    final firestore = FirebaseFirestore.instance;

    _userWrittenCommentList = await firestore
        .collection('user')
        .doc('aboutBoard')
        .collection('comment')
        .get()
        .then((QuerySnapshot querySnapshot) {
      return UserWrittenCommentData().fromFireStoreQuerySnapshot(querySnapshot);
    });
    await Future.forEach(_userWrittenCommentList,
        (UserWrittenCommentData data) async {
      var commentDb;
      if (data.haveChildComment) {
        commentDb = db
            .reference()
            .child('board')
            .child(data.boardId)
            .child(data.postId)
            .child(data.parentCommentId)
            .child("CoComment")
            .child(data.commentId);
      } else {
        commentDb = db
            .reference()
            .child('board')
            .child(data.boardId)
            .child(data.postId)
            .child(data.commentId);
      }
      _commentDataList
          .add(await commentDb.once().then((DataSnapshot dataSnapshot) {
        return CommentData.fromRealtimeData(dataSnapshot);
      }).whenComplete(() {}));
      notifyListeners();
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

class UserWrittenCommentData {
  final String boardId;
  final bool haveChildComment;
  final String parentCommentId;
  final String postId;
  final String commentId;
  UserWrittenCommentData(
      {this.boardId,
      this.commentId,
      this.haveChildComment,
      this.parentCommentId,
      this.postId});

  factory UserWrittenCommentData.fromFireStoreDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data() ?? {};
    return UserWrittenCommentData(
        boardId: data["boardId"],
        commentId: documentSnapshot.id,
        haveChildComment: data["haveChildComment"] ?? false,
        parentCommentId: data["parentCommentId"],
        postId: data["postId"]);
  }
  fromFireStoreQuerySnapshot(QuerySnapshot querySnapshot) {
    List<UserWrittenCommentData> list = [];
    querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
      list.add(UserWrittenCommentData.fromFireStoreDocumentSnapshot(
          documentSnapshot));
    });
    return list;
  }
}
