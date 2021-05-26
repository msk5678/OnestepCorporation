import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:onestep_rezero/board/StateManage/firebase_GetUID.dart';

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
        .collection("board")
        .doc(this.boardId ?? "boardFree")
        .collection(this.boardId ?? "boardFree")
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
}

// class Comment {
//   final String uid;
//   final String boardId;
//   final String boardName;
//   final String postId;
//   final String textContent;
//   final String deleted;
//   final String deletedTime;
//   final String reported;
//   final String reportCount;
//   final String uploadTime;
//   final String updateTime;
//   final String userName;
//   String commentId;
//   Comment({
//     this.textContent,
//     this.reported,
//     this.uploadTime,
//     this.uid,
//     this.boardName,
//     this.updateTime,
//     this.reportCount,
//     this.userName,
//     this.postId,
//     this.boardId,
//     this.deleted,
//     this.deletedTime,
//   });
//   Future toRealtimeDatabase(Comment comment) async {
//     final db = FirebaseDatabase.instance.reference();
//     String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
//     db
//         .child('board')
//         .child(boardId)
//         .child(postId)
//         .child(currentTimeStamp)
//         .set({
//           "uid": comment.uid,
//           "boardId": comment.boardId,
//           "boardName": comment.boardName,
//           "postId": comment.postId,
//           "textContent": comment.textContent ?? '',
//           "deleted": comment.deleted ?? 'false',
//           "deletedTime": comment.deletedTime ?? '',
//           "reported": comment.reported ?? '',
//           "reportCount": comment.reportCount ?? '',
//           "uploadTime": comment.uploadTime ?? currentTimeStamp,
//           "updateTime": comment.updateTime ?? '',
//           "userName": comment.userName
//         })
//         .then((value) => null)
//         .whenComplete(() => null);
//   }

//   Future commentFavoriteCount({String currentUID, Comment comment}) async {
//     final db = FirebaseDatabase.instance.reference();
//     db
//         .child('board')
//         .child(boardId)
//         .child(postId)
//         .child(commentId)
//         .child("favoriteUserList")
//         .set({currentUID: false})
//         .then((value) => null)
//         .whenComplete(() => null);
//   }

// Future _saveUidInBoardField(
//     DocumentSnapshot documentSnapshot, String currentUid) async {
//   Map _data = documentSnapshot.data();
//   List _commentList = documentSnapshot.data()["commentList"];

//   if (!_commentList.contains(currentUid)) {
//     return await FirebaseFirestore.instance
//         .collection("Board")
//         .doc(boardId)
//         .collection(boardId)
//         .doc(boardDocumentId)
//         .update({"commentList": _data["commentList"].add(currentUid)})
//         .catchError((onError) {
//           print("catchError ");
//         })
//         .then((value) => print("Something error null pointer or.. "))
//         .whenComplete(() => true);
//   }
// }

// getUnderComment(
//     String boardId, String currentBoardId, String commentId) async {
//   var _result;
//   await FirebaseFirestore.instance
//       .collection("Board")
//       .doc(boardId)
//       .collection(boardId)
//       .doc(currentBoardId)
//       .collection(COMMENT_COLLECTION_NAME)
//       .doc(commentId)
//       .collection(COMMENT_COLLECTION_NAME)
//       .get()
//       .catchError((onError) {
//     print(onError.toString() + "Under comment");
//   }).then((value) {
//     _result = value;
//   });

//   return _result;
// }

// class UnderComment extends Comment {
//   UnderComment(
//       {String createDate,
//       String uid,
//       var lastAlterDate,
//       String text,
//       int reportCount,
//       int favoriteCount,
//       List favoriteUserList,
//       String name,
//       String boardId,
//       String boardDocumentId})
//       : super(
//             createDate: createDate,
//             uid: uid,
//             favoriteCount: favoriteCount,
//             favoriteUserList: favoriteUserList,
//             lastAlterDate: lastAlterDate,
//             name: name,
//             reportCount: reportCount,
//             text: text,
//             boardDocumentId: boardDocumentId,
//             boardId: boardId);
//   getUnderComment(String boardDocumentId) {

//   }
// }
