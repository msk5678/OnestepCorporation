import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/main.dart';

class FavoriteProvider with ChangeNotifier {
  String _errorMessage = "FavoriteComment Provider RuntimeError";
  String get errorMessage => _errorMessage;
  PostData _postData = PostData();
  PostData get latestPostData => _postData;
  bool get isFetching => _isFetching;
  setPostData(PostData postData) => _postData = postData;

  bool _isFetching = false;
  getLatestPostData(PostData currentPostData) async {
    if (_isFetching) return;
    _isFetching = true;
    _postData = PostData();
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
    _isFetching = false;
    notifyListeners();
  }

  updateFavorite(PostData currentPostData, String uid, bool isUndo) async {
    if (_isFetching) return;
    _isFetching = true;

    await getLatestPostData(currentPostData);

    _postData = currentPostData;
    final db = FirebaseFirestore.instance;
    String boardId = currentPostData.boardId;
    String postId = currentPostData.documentId;
    Map<String, dynamic> favoriteMapList = currentPostData.favoriteUserList;

    if (isUndo) {
      if (favoriteMapList.containsKey(uid)) favoriteMapList.remove(uid);
    } else {
      favoriteMapList.addAll({uid: true});
    }

    return await db
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(boardId)
        .collection(boardId)
        .doc(postId)
        .update({"favoriteUserList": currentPostData.favoriteUserList}).then(
            (value) {
      notifyListeners();
      return true;
    }).whenComplete(() => _isFetching = false);
  }
}
