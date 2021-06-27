import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:onestep_rezero/loggedInWidget.dart';

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
    List<String> _imgUriarr = [];

    for (var imaged in _imageArr) {
      if (imaged.runtimeType == String) {
        _imgUriarr.add(imaged);
      } else {
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
          "favoriteCount": 0
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

  Future updatePostData(
      BuildContext context, PostData updatingData, int urlImageCount) async {
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
          "imageCommentList": imageCommentMap ?? {},
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
    );
  }
  Future<bool> updateFavorite(String uid, bool isUndo) async {
    if (!isUndo) {
      return FirebaseFirestore.instance
          .collection('university')
          .doc(currentUserModel.university)
          .collection('board')
          .doc(this.boardId)
          .collection(this.boardId)
          .doc(this.documentId)
          .update({"favoriteCount": FieldValue.increment(1)})
          .then((value) async {
            await FirebaseFirestore.instance
                .collection('user')
                .doc('aboutBoard')
                .collection('favorite')
                .doc(this.documentId)
                .set({
              "postId": documentId,
              "boardId": boardId,
            });
          })
          .onError((error, stackTrace) {})
          .then((value) => true);
    } else {
      return FirebaseFirestore.instance
          .collection('university')
          .doc(currentUserModel.university)
          .collection('board')
          .doc(this.boardId)
          .collection(this.boardId)
          .doc(this.documentId)
          .update({"favoriteCount": FieldValue.increment(-1)})
          .then((value) async {
            await FirebaseFirestore.instance
                .collection('user')
                .doc('aboutBoard')
                .collection('favorite')
                .doc(this.documentId)
                .delete();
          })
          .onError((error, stackTrace) {})
          .then((value) => true);
    }
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
