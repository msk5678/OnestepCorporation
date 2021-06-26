import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:onestep_rezero/board/declareData/commentData.dart';

import 'package:onestep_rezero/board/declareData/postData.dart';

class UserProvider with ChangeNotifier {
  String _errorMessage = "UserProvider Provider RuntimeError";
  String get errorMessage => _errorMessage;
  List<CommentData> _userCommentList = [];
  Map<String, UserFavoriteData> _userFavoritePostList = {};
  Map<String, UserFavoriteData> get userFavoritePostMap =>
      _userFavoritePostList;
  List<CommentData> get userCommentList => _userCommentList;
  bool get isFetching => _isFetching;
  bool _isFetching = false;

  getUserFavoriteList() async {
    if (_isFetching) return;
    _isFetching = true;
    _userFavoritePostList = {};
    try {
      //UserComment List
      await FirebaseFirestore.instance
          .collection('user')
          .doc("aboutBoard")
          .collection('favorite')
          .get()
          .then((QuerySnapshot querySnapshot) async {
        await Future.forEach(querySnapshot.docs,
            (DocumentSnapshot documentSnapshot) {
          _userFavoritePostList.addAll({
            documentSnapshot.id:
                UserFavoriteData.fromFirestore(documentSnapshot)
          });
          notifyListeners();
        });
      });
    } catch (e) {
      _isFetching = false;
    }
    _isFetching = false;
    notifyListeners();
  }

  getUserCommentList() async {
    if (_isFetching) return;
    _isFetching = true;
    _userCommentList = [];
    try {
      List<UserWrittenCommentData> _userWrittenCommentList = [];
      final db = FirebaseDatabase.instance;
      _userWrittenCommentList = await FirebaseFirestore.instance
          .collection('user')
          .doc('aboutBoard')
          .collection('comment')
          .get()
          .then((QuerySnapshot querySnapshot) {
        return UserWrittenCommentData()
            .fromFireStoreQuerySnapshot(querySnapshot);
      });
      await Future.forEach(_userWrittenCommentList,
          (UserWrittenCommentData data) async {
        var commentDb;
        if (data.haveChildComment || data.parentCommentId != "") {
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
        CommentData _commentData =
            await commentDb.once().then((DataSnapshot dataSnapshot) {
          if (dataSnapshot.value.runtimeType != Null)
            return CommentData.fromRealtimeData(dataSnapshot);
        });
        _userCommentList.add(_commentData);

        notifyListeners();
      });
    } catch (e) {
      _isFetching = false;
    }
    _isFetching = false;
    notifyListeners();
  }

  getUserData() async {
    if (_isFetching) return;
    _isFetching = true;
    _userFavoritePostList = {};
    _userCommentList = [];
    final firestore = FirebaseFirestore.instance;

    try {
      //User Favorite Post List
      await getUserFavoriteList();

      //UserComment List
      await getUserCommentList();
    } catch (e) {
      _isFetching = false;
    }

    _isFetching = false;
    notifyListeners();
  }

  updateFavorite(
    PostData currentPost,
    String uid,
    bool isUndo,
  ) async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      var result = await currentPost.updateFavorite(uid, isUndo) ?? false;
      try {
        if (result) {
          _isFetching = false;
          notifyListeners();
        }
      } catch (e) {}
    } catch (e) {
      _isFetching = false;
    }
    _isFetching = false;
    notifyListeners();
  }
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
        parentCommentId: data["parentCommentId"] ?? "",
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

class UserFavoriteData {
  final String boardId;
  final String postId;
  UserFavoriteData({this.boardId, this.postId});
  factory UserFavoriteData.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data() ?? {};
    return UserFavoriteData(boardId: data["boardId"], postId: data["postId"]);
  }
}
