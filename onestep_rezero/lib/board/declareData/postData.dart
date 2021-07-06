import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class PostData {
  var uploadTime;
  var updateTime;
  String documentId;
  final String title;
  final String contentCategory;
  final int reportCount;
  final String textContent;
  final String uid;
  int commentCount;
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

  bool reported;
  int reportedTime;

  Future convertImage(var _imageArr) async {
    List<String> _imgUriarr = [];

    for (var imaged in _imageArr) {
      try {
        // Reference storageReference = FirebaseStorage.instance
        //     .ref()
        //     .child("boardimages/freeboard/${randomAlphaNumeric(15)}");
        // UploadTask storageUploadTask = storageReference
        //     .putData((await imaged.getByteData()).buffer.asUint8List());
        // await storageUploadTask.whenComplete(() async {
        //   String downloadURL = await storageReference.getDownloadURL();
        //   _imgUriarr.add(downloadURL);
        // });
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("productimage/${DateTime.now().microsecondsSinceEpoch}");

        Uint8List uint8list = await assetCompressFile(await imaged.originFile);

        UploadTask storageUploadTask = storageReference.putData(uint8list);
        await storageUploadTask.whenComplete(() async {
          String downloadURL = await storageReference.getDownloadURL();
          _imgUriarr.add(downloadURL);
        });
      } catch (e) {
        print("Save Image Error in Board $e");
      }
    }
    return _imgUriarr;
  }

  Future<Uint8List> assetCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 30,
    );

    return result;
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
      this.deletedTime,
      this.reported,
      this.reportedTime});
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
          "uid": currentUserModel.uid,
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
          "favoriteCount": 0,
          "reported": false,
          "reportedTime": 0
        })
        .then((value) => true)
        .timeout(
          Duration(seconds: 3),
          onTimeout: () {
            Navigator.pop(context);
            return null;
          },
        );
  }

  Future updatePostData(BuildContext context) async {
    String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    imgUriList = await convertImage(imageCommentMap["ALTERIMAGE"]);
    imageCommentMap.update("ALTERIMAGE", (value) => []);
    imageCommentMap.update("IMAGE", (value) => imgUriList);
    return await FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(boardId)
        .collection(boardId)
        .doc(documentId)
        .update({
          "updateTime": currentTimeStamp,
          "title": this.title ?? "",
          "contentCategory": this.contentCategory.toString(),
          "textContent": this.textContent ?? "",
          "imageCommentList": this.imageCommentMap ?? {},
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
        favoriteCount: postData["favoriteCount"] ?? 0,
        scribeCount: postData["commentUserList"] != null
            ? postData["commentUserList"].length
            : 0,
        reported: postData["reported"],
        reportedTime: postData["reportedTime"] ?? 0);
  }
  Future<bool> updateFavorite(String currentUid, bool isUndo) async {
    final firebaseRealtimeDb = FirebaseDatabase.instance.reference();
    return FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(this.boardId)
        .collection(this.boardId)
        .doc(this.documentId)
        .update({
          "favoriteCount":
              !isUndo ? FieldValue.increment(1) : FieldValue.increment(-1)
        })
        .then((value) async {
          if (!isUndo) {
            await firebaseRealtimeDb
                .child('user')
                .child(currentUid)
                .child('aboutBoard')
                .child('favorite')
                .child(this.documentId)
                .set({
              "postId": documentId,
              "boardId": boardId,
            });
          } else {
            await firebaseRealtimeDb
                .child('user')
                .child(currentUid)
                .child('aboutBoard')
                .child('favorite')
                .child(this.documentId)
                .remove();
          }
        })
        .onError((error, stackTrace) {})
        .then((value) => true);
  }

  dismissPostData() async {
    return await FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(boardId)
        .collection(boardId)
        .doc(documentId)
        .update({
          "deleted": true,
          "deletedTime": DateTime.now().millisecondsSinceEpoch
        })
        .then((value) => true)
        .onError((error, stackTrace) => false)
        .whenComplete(() => null);
  }

  updateViewers(String uid) async {
    return await FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(this.boardId)
        .collection(this.boardId)
        .doc(this.documentId)
        .update(
      {"views." + uid: true},
    ).then((value) {
      return true;
    });
  }
}
