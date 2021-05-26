import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';

import '../../main.dart';

class Comment {
  final String uid;
  final String boardId;
  final String boardName;
  final String postId;
  final String textContent;
  final String deleted;
  final String deletedTime;
  final String reported;
  final String reportCount;
  final String uploadTime;
  final String updateTime;
  final String userName;
  final String commentId;
  Comment(
      {this.uid,
      this.boardId,
      this.boardName,
      this.postId,
      this.textContent,
      this.reported,
      this.uploadTime,
      this.updateTime,
      this.reportCount,
      this.userName,
      this.deleted,
      this.deletedTime,
      this.commentId});
  factory Comment.toRealtimeDataWithPostData(PostData postData) {
    String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    return Comment(
      uid: googleSignIn.currentUser.id,
      boardId: postData.boardId,
      boardName: postData.boardName,
      postId: postData.documentId,
      deleted: "false",
      deletedTime: "",
      reportCount: "",
      reported: "",
      updateTime: "",
      uploadTime: currentTimeStamp,
    );
  }
  Future toRealtimeDatabase(
      {String textContent, Map<String, dynamic> commentList}) async {
    final realtimeDb = FirebaseDatabase.instance.reference();
    final firestoreDb = FirebaseFirestore.instance;
    if (!commentList.containsKey(googleSignIn.currentUser.id)) {
      firestoreDb
          .collection('board')
          .doc(this.boardId)
          .collection(this.boardId)
          .doc(this.postId)
          .update({
        "commentUserList": {googleSignIn.currentUser.id: true}
      });
      String currentTimeStamp =
          DateTime.now().millisecondsSinceEpoch.toString();
      realtimeDb
          .child('board')
          .child(boardId)
          .child(postId)
          .child(currentTimeStamp)
          .set({
            "uid": this.uid,
            "boardId": this.boardId,
            "boardName": this.boardName,
            "postId": this.postId,
            "textContent": textContent ?? this.textContent ?? '',
            "deleted": this.deleted ?? 'false',
            "deletedTime": this.deletedTime ?? '',
            "reported": this.reported ?? '',
            "reportCount": this.reportCount ?? '',
            "uploadTime": this.uploadTime ?? currentTimeStamp,
            "updateTime": this.updateTime ?? '',
            "userName": ""
          })
          .then((value) => null)
          .whenComplete(() => null);
    }
  }

  Future _uploadRealtimeDatabase() {}

  fromFirebaseReference(DataSnapshot snapshot) {
    if (snapshot == null)
      print("SNAPSHOT NULL : ");
    else
      print("SNAPSHOT : " + snapshot.value.runtimeType.toString());
    Map<dynamic, dynamic> commentSnapshot = snapshot.value;
    List<Comment> commentList = [];
    commentSnapshot.forEach((key, value) {
      commentList.add(Comment(
          uid: value["uid"],
          boardId: value["boardId"],
          boardName: value["boardName"],
          postId: value["postId"],
          deleted: value["deleted"],
          deletedTime: value["deletedTime"],
          reportCount: value["reportCount"],
          reported: value['reported'],
          updateTime: value["updateTime"],
          uploadTime: value["uploadTime"],
          commentId: key));
    });
    return commentList;
  }
}

// Future toRealtimeDatabase(Comment comment) async {
//   final db = FirebaseDatabase.instance.reference();
//   String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
//   db
//       .child('board')
//       .child(boardId)
//       .child(postId)
//       .child(currentTimeStamp)
//       .set({
//         "uid": comment.uid,
//         "boardId": comment.boardId,
//         "boardName": comment.boardName,
//         "postId": comment.postId,
//         "textContent": comment.textContent ?? '',
//         "deleted": comment.deleted ?? 'false',
//         "deletedTime": comment.deletedTime ?? '',
//         "reported": comment.reported ?? '',
//         "reportCount": comment.reportCount ?? '',
//         "uploadTime": comment.uploadTime ?? currentTimeStamp,
//         "updateTime": comment.updateTime ?? '',
//         "userName": comment.userName
//       })
//       .then((value) => null)
//       .whenComplete(() => null);
// }

// Future commentFavoriteCount({String currentUID, Comment comment}) async {
//   final db = FirebaseDatabase.instance.reference();
//   db
//       .child('board')
//       .child(boardId)
//       .child(postId)
//       .child(commentId)
//       .child("favoriteUserList")
//       .set({currentUID: false})
//       .then((value) => null)
//       .whenComplete(() => null);
// }
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
