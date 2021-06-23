import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

import '../../main.dart';

class PostData {
  var uploadTime;
  var updateTime;
  String documentId;
  final String title;
  final String contentCategory;
  final int reportCount;
  final String textContent;
  final String uid;
  final int commentCount;
  final String boardName;
  final String boardId;
  final Map<String, dynamic> favoriteUserList;
  final Map<String, dynamic> scrabUserList;
  final Map<String, dynamic> views;
  final Map<String, dynamic> commentUserList;
  int favoriteCount;
  int scribeCount;
  Map<String, dynamic> imageCommentMap;
  Function completeImageUploadCallback;
  List imgUriList;

  bool deleted;
  int deletedTime;

  Future convertImage(var _imageArr) async {
    List _imgUriarr = [];

    for (var imaged in _imageArr) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child("boardimages/freeboard/${randomAlphaNumeric(15)}");
      UploadTask storageUploadTask = storageReference
          .putData((await imaged.getByteData()).buffer.asUint8List());
      await storageUploadTask.whenComplete(() async {
        String downloadURL = await storageReference.getDownloadURL();
        _imgUriarr.add(downloadURL);
      });
    }
    return _imgUriarr;
  }

  PostData(
      {this.scrabUserList,
      this.commentUserList,
      this.favoriteUserList,
      this.contentCategory,
      this.boardName,
      this.uploadTime,
      this.title,
      this.reportCount,
      this.textContent,
      this.uid,
      this.imageCommentMap,
      this.scribeCount,
      this.favoriteCount,
      this.views,
      this.documentId,
      this.commentCount,
      this.imgUriList,
      this.boardId,
      this.deleted,
      this.deletedTime});
  Future toFireStore(BuildContext context) async {
    String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    imgUriList = await convertImage(imageCommentMap["IMAGE"]);
    imageCommentMap.update("IMAGE", (value) => imgUriList);
    return await FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(this.boardId)
        .collection(this.boardId)
        .doc(currentTimeStamp)
        .set({
          "uid": googleSignIn.currentUser.id,
          "uploadTime": Timestamp.fromDate(DateTime.now()),
          "updateTime": 0,
          "commentCount": commentCount ?? 0,
          "reportCount": reportCount ?? 0,
          "deletedTime": deletedTime ?? 0,
          "title": title ?? "",
          "contentCategory": contentCategory.toString(),
          "textContent": textContent ?? "",
          "boardName": boardName ?? "",
          "boardId": boardId ?? "",
          "deleted": deleted ?? false,
          "views": views ?? {},
          "imageCommentList": imageCommentMap ?? {},
          "scrabUserList": scrabUserList ?? {},
          "favoriteUserList": favoriteUserList ?? {},
          "commentUserList": commentUserList ?? {},
        })
        .whenComplete(() => true)
        .then((value) => true)
        .timeout(
          Duration(seconds: 3),
          onTimeout: () {
            Navigator.pop(context);
            return null;
          },
        );
  }

  Future updatePostData(BuildContext context, PostData updatingData) async {
    String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    imgUriList = await convertImage(imageCommentMap["IMAGE"]);
    imageCommentMap.update("IMAGE", (value) => imgUriList);
    return await FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(this.boardId)
        .collection(this.boardId)
        .doc(this.documentId)
        .update({
          "updateTime": currentTimeStamp,
          "title": updatingData.title ?? "",
          "contentCategory": updatingData.contentCategory.toString(),
          "textContent": updatingData.textContent ?? "",
          "imageCommentList": updatingData.imageCommentMap ?? {},
        })
        .whenComplete(() => true)
        .then((value) => true)
        .timeout(
          Duration(seconds: 3),
          onTimeout: () {
            Navigator.pop(context);
            return null;
          },
        );
  }

  factory PostData.fromFireStore(DocumentSnapshot snapshot) {
    Map postData = snapshot.data();
    return PostData(
      title: postData["title"],
      contentCategory: postData["contentCategory"] ?? '',
      textContent: postData["textContent"] ?? '',
      uid: postData["uid"] ?? '',
      documentId: snapshot.id,
      commentCount: postData["commentCount"] ?? 0,
      uploadTime: postData["uploadTime"].toDate(),
      boardId: postData["boardId"] ?? '',
      boardName: postData["boardName"] ?? '',
      deleted: postData["deleted"] ?? false,
      deletedTime: postData["deletedTime"] ?? 0,
      reportCount: postData["reportCount"] ?? 0,
      views: postData["views"] ?? {},
      commentUserList: postData["commentUserList"] ?? {},
      favoriteUserList: postData["favoriteUserList"] ?? {},
      scrabUserList: postData["scrabUserList"] ?? {},
      imageCommentMap: postData["imageCommentList"] ?? {},
      favoriteCount: postData["favoriteUserList"] != null
          ? postData["favoriteUserList"].length
          : 0,
      scribeCount: postData["commentUserList"] != null
          ? postData["commentUserList"].length
          : 0,
    );
  }
  Future<bool> updateFavorite(String uid) async {
    final db = FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(this.boardId)
        .collection(this.boardId)
        .doc(this.documentId);

    DocumentSnapshot getLatestDb =
        await db.get().onError((error, stackTrace) => null);

    if (getLatestDb != null) {
      Map<String, dynamic> latestFavoriteUserMap =
          getLatestDb.data()["favoriteUserList"];

      return await db
          .update({
            "favoriteUserList": latestFavoriteUserMap..addAll({uid: true})
          })
          .then((value) => true)
          .onError((error, stackTrace) => false);
    } else {
      return false;
    }
  }
}
