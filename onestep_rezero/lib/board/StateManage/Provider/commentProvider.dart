import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';

class CommentProvider with ChangeNotifier {
  String _errorMessage = "Comment Provider RuntimeError";
  String get errorMessage => _errorMessage;
  List<CommentData> get comments => _commentDataList;
  Map<String, dynamic> get wroteUserList => _commentUserMapList;
  bool get isFetching => _isFetching;
  List<CommentData> _commentDataList = [];
  Map<String, dynamic> _commentUserMapList = {};
  bool _isFetching = false;
  fetchData(String boardId, String postId) async {
    if (_isFetching) return;
    _isFetching = true;
    _commentDataList = [];

    await fetchCommentList(boardId, postId, ignoreFetching: true);

    final db = FirebaseDatabase.instance;

    _commentDataList = await db
        .reference()
        .child('commentInBoard')
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
    _commentDataList.sort((a, b) => int.tryParse(a.commentId ?? 0)
        .compareTo(int.tryParse(b.commentId ?? 0)));

    _isFetching = false;
    notifyListeners();
  }

  fetchCommentList(String boardId, String postId, {bool ignoreFetching}) async {
    ignoreFetching = ignoreFetching ?? false;
    if (!ignoreFetching) {
      if (_isFetching) return;
      _isFetching = true;
    }

    _commentUserMapList = {};
    final db = FirebaseDatabase.instance;

    _commentUserMapList = Map<String, dynamic>.from(await db
            .reference()
            .child('commentInBoard')
            .child(boardId.toString())
            .child(postId.toString())
            .child("userList")
            .once()
            .then((DataSnapshot dataSnapshot) {
      return PostCommentUserList.fromDataSnapshot(dataSnapshot).commentList ??
          {};
    }).whenComplete(() {
      if (!ignoreFetching) _isFetching = false;
    })
        // .onError((error, stackTrace) {
        //   print("commentUserList Error in Comment Provider : $error");
        //   if (!ignoreFetching) _isFetching = false;
        //   return {};
        // }
        // )
        );

    // notifyListeners();
  }

  refresh(String boardId, String postId) {
    // _commentDataList = [];
    fetchData(boardId, postId);
    notifyListeners();
  }

  clear() {}
}

class PostCommentUserList {
  final Map<String, dynamic> commentList;
  PostCommentUserList({this.commentList});

  factory PostCommentUserList.fromDataSnapshot(DataSnapshot dataSnapshot) {
    if (dataSnapshot.value != null) {
      Map<String, String> result = {};
      Map<String, dynamic> userMapList =
          Map<String, dynamic>.from(dataSnapshot.value);
      List<dynamic> userWroteTimeList = userMapList.keys.toList()
        ..sort((a, b) => a.toString().compareTo(b.toString()));

      for (int i = 0; i < userWroteTimeList.length; i++) {
        result
            .addAll({userMapList[userWroteTimeList[i]]["uid"]: "익명 ${i + 1}"});
      }

      return PostCommentUserList(commentList: result);
    }
    return PostCommentUserList(commentList: {});
  }
}
