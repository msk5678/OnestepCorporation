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
  Map<String, CommentData> _postIdListAboutWrittenComment = {};
  Map<String, UserData> _userFavoritePostList = {};
  Map<String, UserData> get userFavoritePostMap => _userFavoritePostList;
  List<CommentData> get userCommentList => _userCommentList;
  Map<String, CommentData> get postIdListAboutWrittenComment =>
      _postIdListAboutWrittenComment;

  bool get isFetching => _isFetching;
  bool _isFetching = false;

  getUserFavoriteList(String currentUid) async {
    if (_isFetching) return;
    final firebaseRealtimeDb = FirebaseDatabase.instance.reference();
    _isFetching = true;
    _userFavoritePostList = {};
    try {
      //UserComment List
      await firebaseRealtimeDb
          .child('user')
          .child(currentUid.toString())
          .child('aboutBoard')
          .child('favorite')
          .once()
          .then((DataSnapshot dataSnapshot) {
        dataSnapshot.value.forEach((key, value) {
          _userFavoritePostList
              .addAll({key: UserData.fromRealtimeUserFavoriteList(value)});
          notifyListeners();
        });
      });
    } catch (e) {
      _isFetching = false;
    }
    _isFetching = false;
    notifyListeners();
  }

  getUserCommentList(String currentUid) async {
    if (_isFetching) return;
    _isFetching = true;
    _userCommentList = [];
    _postIdListAboutWrittenComment = {};
    try {
      List<UserData> _userWrittenCommentList = [];
      final firebaseRealtimeDb = FirebaseDatabase.instance.reference();
      final db = FirebaseDatabase.instance;
      await firebaseRealtimeDb
          .child('user')
          .child(currentUid)
          .child('aboutBoard')
          .child('comment')
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> userCommentedMap =
            Map<dynamic, dynamic>.from(dataSnapshot.value);
        userCommentedMap.forEach((commentId, commentData) {
          _userWrittenCommentList.add(
              UserData.fromRealtimeUserWrittenCommentList(
                  commentId, commentData));
        });
      });
      await Future.forEach(_userWrittenCommentList, (UserData data) async {
        var commentDb;
        if (data.parentCommentId != "") {
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
          return CommentData.fromRealtimeData(dataSnapshot);
        });

        _postIdListAboutWrittenComment
            .addAll({_commentData.postId: _commentData});
        _userCommentList.add(_commentData);

        // notifyListeners();
      });
    } catch (e) {
      print(e);
      _isFetching = false;
    }
    _isFetching = false;
    notifyListeners();
  }

  getUserData(String currentUid) async {
    if (_isFetching) return;
    _isFetching = true;
    _userFavoritePostList = {};
    _userCommentList = [];
    _postIdListAboutWrittenComment = {};

    try {
      //User Favorite Post List
      await getUserFavoriteList(currentUid);
      //UserComment List
      await getUserCommentList(currentUid);
    } catch (e) {
      _isFetching = false;
    }

    _isFetching = false;
    notifyListeners();
  }

  updateFavorite(
    PostData currentPost,
    String currentUid,
    bool isUndo,
  ) async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      var result =
          await currentPost.updateFavorite(currentUid, isUndo) ?? false;
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

class UserData {
  final String boardId;
  final String postId;
  final String parentCommentId;
  String commentId;

  UserData({this.boardId, this.postId, this.parentCommentId, this.commentId});
  factory UserData.fromRealtimeUserFavoriteList(var mapData) {
    mapData = Map<dynamic, dynamic>.from(mapData);
    return UserData(boardId: mapData["boardId"], postId: mapData["postId"]);
  }
  factory UserData.fromRealtimeUserWrittenCommentList(
      String commId, var mapData) {
    return UserData(
        boardId: mapData["boardId"],
        postId: mapData["postId"],
        commentId: commId,
        parentCommentId: mapData["parentCommentId"]);
  }
}
