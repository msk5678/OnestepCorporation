import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/main.dart';

class PostProvider with ChangeNotifier {
  String _errorMessage = "PostProvider Provider RuntimeError";
  String get errorMessage => _errorMessage;
  PostData _postData = PostData(uid: "");
  PostData get latestPostData => _postData;
  set setPostData(PostData postData) => _postData = postData;
  bool get isFetching => _isFetching;

  bool _isFetching = false;
  getLatestPostData(PostData currentPostData) async {
    if (_isFetching) return;
    _isFetching = true;
    _postData = PostData(uid: "");
    try {
      _isFetching = true;
      final db = FirebaseFirestore.instance;
      String boardId = currentPostData.boardId;
      String postId = currentPostData.documentId;
      _postData = await db
          .collection('university')
          .doc(currentUserModel.university)
          .collection('board')
          .doc(boardId)
          .collection(boardId)
          .doc(postId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        return PostData.fromFireStore(documentSnapshot);
      }).whenComplete(() {
        _isFetching = false;
      });
    } catch (e) {
      _isFetching = false;
    }
    print("here!");
    _isFetching = false;
    notifyListeners();
  }
}
