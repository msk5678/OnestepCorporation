import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/loggedInWidget.dart';

class CommentData {
  final uid;
  final boardId;
  final boardName;
  final postId;
  final textContent;
  final deleted;
  final deletedTime;
  final reported;
  final reportCount;
  final uploadTime;
  final updateTime;
  String userName;
  final commentId;
  final haveChildComment;
  final parentCommentId;
  List<CommentData> childCommentList;
  bool isUnderComment = false;
  CommentData(
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
      this.commentId,
      this.haveChildComment,
      this.parentCommentId,
      this.childCommentList});
  factory CommentData.toRealtimeDataWithPostData(PostData postData) {
    String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    return CommentData(
      uid: currentUserModel.uid,
      boardId: postData.boardId,
      boardName: postData.boardName,
      postId: postData.documentId,
      deleted: false,
      uploadTime: currentTimeStamp,
    );
  }
  factory CommentData.fromRealtimeData(DataSnapshot dataSnapshot) {
    Map<dynamic, dynamic> value = dataSnapshot.value;
    int reportCount;
    int uploadTime;
    int updateTime;
    if (value["reportCount"] == null ||
        value["reportCount"] == "null" ||
        value["reportCount"] == "")
      reportCount = 0;
    else
      reportCount = int.parse(value["reportCount"]);

    if (value["uploadTime"] == null ||
        value["uploadTime"] == "null" ||
        value["uploadTime"] == "")
      uploadTime = 0;
    else
      uploadTime = int.parse(value["uploadTime"]);

    if (value["updateTime"] == null ||
        value["updateTime"] == "null" ||
        value["updateTime"] == "")
      updateTime = 0;
    else
      updateTime = int.parse(value["updateTime"]);
    return CommentData(
        uid: value["uid"],
        boardId: value["boardId"],
        boardName: value["boardName"],
        postId: value["postId"],
        deleted: value["deleted"].toString() == 'true' ? true : false,
        deletedTime: value["deletedTime"],
        reportCount: reportCount,
        reported: value['reported'].toString() == 'true' ? true : false,
        updateTime: updateTime,
        uploadTime: uploadTime,
        textContent: value["textContent"].toString(),
        haveChildComment:
            value["haveChildComment"].toString() == 'true' ? true : false,
        parentCommentId: value["parentCommentId"] ?? "",
        commentId: dataSnapshot.key);
  }

  Future increaseCommentCount() async {
    return await FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(this.boardId)
        .collection(this.boardId)
        .doc(this.postId)
        .update({"commentCount": FieldValue.increment(1)})
        .then((value) => true)
        .whenComplete(() => true)
        .onError((error, stackTrace) => false);
  }

  Future updatePostCommentMap() async {
    final firestoreDb = FirebaseFirestore.instance;
    firestoreDb
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(this.boardId)
        .collection(this.boardId)
        .doc(this.postId)
        .update({"commentCount": FieldValue.increment(1)});
  }

  Future<bool> saveCommentToUserCollection(String timeStampId,
      {String parentCommentid}) async {
    final firestoreDb = FirebaseFirestore.instance;
    return firestoreDb
        .collection('user')
        .doc('aboutBoard')
        .collection('comment')
        .doc(timeStampId)
        .set({
          "boardId": boardId,
          "postId": postId,
          "haveChildComment": haveChildComment ?? false,
          "parentCommentId": parentCommentid ?? ""
        })
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  Future toRealtimeDatabase(String textContent) async {
    final realtimeDb = FirebaseDatabase.instance.reference();

    if (await updateCommentMap(false)) {
      if (await increaseCommentCount()) {
        String currentTimeStamp =
            DateTime.now().millisecondsSinceEpoch.toString();
        bool result =
            await saveCommentToUserCollection(currentTimeStamp) ?? false;
        if (result)
          return realtimeDb
              .child('board')
              .child(boardId)
              .child(postId)
              .child(currentTimeStamp)
              .set({
                "uid": this.uid.toString(),
                "boardId": this.boardId.toString(),
                "boardName": this.boardName.toString(),
                "postId": this.postId.toString(),
                "textContent":
                    textContent.toString() ?? this.textContent.toString() ?? '',
                "deleted": this.deleted.toString() ?? 'false',
                "deletedTime": this.deletedTime.toString() ?? '',
                "reported": this.reported.toString() ?? 'false',
                "reportCount": this.reportCount.toString() ?? '0',
                "uploadTime": currentTimeStamp,
                "updateTime": this.updateTime.toString() ?? '',
                "userName": "",
                "haveChildComment": "false",
                "parentCommentId": this.parentCommentId
              })
              .then((value) => true)
              .whenComplete(() => null);
      }
    }
  }

  fromFirebaseReference(DataSnapshot snapshot) async {
    Map<dynamic, dynamic> commentSnapshot =
        Map<dynamic, dynamic>.from(snapshot.value ?? {});

    List<CommentData> commentList = [];

    if (snapshot != null) {
      if (snapshot.value != null) {
        await Future.forEach(commentSnapshot.values, (value) async {
          String boardID = value["boardId"];
          String postID = value["postId"];

          int reportCount;
          int uploadTime;
          int updateTime;
          if (value["reportCount"] == null ||
              value["reportCount"] == "null" ||
              value["reportCount"] == "")
            reportCount = 0;
          else
            reportCount = int.parse(value["reportCount"]);

          if (value["uploadTime"] == null ||
              value["uploadTime"] == "null" ||
              value["uploadTime"] == "")
            uploadTime = 0;
          else
            uploadTime = int.parse(value["uploadTime"]);

          if (value["updateTime"] == null ||
              value["updateTime"] == "null" ||
              value["updateTime"] == "")
            updateTime = 0;
          else
            updateTime = int.parse(value["updateTime"]);

          bool haveChildComment =
              value["haveChildComment"].toString() == 'true' ? true : false;
          List<CommentData> childCommentList = haveChildComment
              ? await getChildCommentFromRealTime(
                  boardID, postID, uploadTime.toString())
              : [];
          commentList.add(new CommentData(
              uid: value["uid"],
              boardId: boardID,
              boardName: value["boardName"],
              postId: postID,
              deleted: value["deleted"].toString() == 'true' ? true : false,
              deletedTime: value["deletedTime"],
              reportCount: reportCount,
              reported: value['reported'].toString() == 'true' ? true : false,
              updateTime: updateTime,
              uploadTime: uploadTime,
              textContent: value["textContent"],
              haveChildComment: haveChildComment,
              parentCommentId: value["parentCommentId"] ?? "",
              childCommentList: childCommentList,
              commentId: uploadTime.toString()));
        });
      }
    } else {
      return null;
    }

    commentList.sort((a, b) {
      int aUploadTime = a.uploadTime;
      int bUploadTime = b.uploadTime;
      return aUploadTime.compareTo(bUploadTime);
    });
    return commentList;
  }

  covertDataSnapshotToCommentData(DataSnapshot snapshot) {
    List<CommentData> commentList = [];
    Map<dynamic, dynamic> commentSnapshot =
        Map<dynamic, dynamic>.from(snapshot.value ?? {});
    commentSnapshot.forEach((key, value) {
      String boardID = value["boardId"];
      String postID = value["postId"];

      int reportCount;
      int uploadTime;
      int updateTime;
      if (value["reportCount"] == null ||
          value["reportCount"] == "null" ||
          value["reportCount"] == "")
        reportCount = 0;
      else
        reportCount = int.parse(value["reportCount"]);

      if (value["uploadTime"] == null ||
          value["uploadTime"] == "null" ||
          value["uploadTime"] == "")
        uploadTime = 0;
      else
        uploadTime = int.parse(value["uploadTime"]);

      if (value["updateTime"] == null ||
          value["updateTime"] == "null" ||
          value["updateTime"] == "")
        updateTime = 0;
      else
        updateTime = int.parse(value["updateTime"]);
      commentList.add(new CommentData(
          uid: value["uid"],
          boardId: boardID,
          boardName: value["boardName"],
          postId: postID,
          deleted: value["deleted"].toString() == 'true' ? true : false,
          deletedTime: value["deletedTime"],
          reportCount: reportCount,
          reported: value['reported'].toString() == 'true' ? true : false,
          updateTime: updateTime,
          uploadTime: uploadTime,
          textContent: value["textContent"],
          haveChildComment: haveChildComment,
          parentCommentId: value["parentCommentId"] ?? "",
          childCommentList: childCommentList,
          commentId: snapshot.key));
    });
    return commentList;
  }

  getChildCommentFromRealTime(
      String boardId, String postId, String parentId) async {
    final db = FirebaseDatabase.instance;

    return await db
        .reference()
        .child('board')
        .child(boardId)
        .child(postId)
        .child(parentId)
        .child("CoComment")
        .once()
        .then((DataSnapshot childSnapshot) {
      return CommentData().covertDataSnapshotToCommentData(childSnapshot);
    }).whenComplete(() => null);
  }

  dismissComment() async {
    var realtimeDb;
    if (this.parentCommentId != null) {
      if (this.parentCommentId != "") {
        realtimeDb = FirebaseDatabase.instance
            .reference()
            .child('board')
            .child(this.boardId)
            .child(this.postId)
            .child(this.parentCommentId)
            .child("CoComment")
            .child(this.commentId);
      } else {
        realtimeDb = FirebaseDatabase.instance
            .reference()
            .child('board')
            .child(this.boardId)
            .child(this.postId)
            .child(this.commentId);
      }
    }

    String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    return realtimeDb
        .update({
          "deleted": 'true',
          "deletedTime": currentTimeStamp,
        })
        .then((value) => true)
        .whenComplete(() => null);
  }

  addCoComment(String comment) async {
    if (await increaseCommentCount()) if (await updateCommentMap(false)) {
      String currentTimeStamp =
          DateTime.now().millisecondsSinceEpoch.toString();
      bool result = await saveCommentToUserCollection(currentTimeStamp,
              parentCommentid: commentId) ??
          false;
      if (result) {
        bool isDone = await FirebaseDatabase.instance
            .reference()
            .child('board')
            .child(this.boardId)
            .child(this.postId)
            .child(this.commentId)
            .update({
              "haveChildComment": 'true',
            })
            .then((value) => true)
            .whenComplete(() => true)
            .onError((error, stackTrace) => false);
        return isDone
            ? FirebaseDatabase.instance
                .reference()
                .child('board')
                .child(this.boardId)
                .child(this.postId)
                .child(this.commentId)
                .child("CoComment")
                .child(currentTimeStamp)
                .set({
                  "uid": this.uid,
                  "boardId": this.boardId.toString(),
                  "boardName": this.boardName.toString(),
                  "postId": this.postId.toString(),
                  "textContent": comment.toString() ?? "Co Comment ERROR" ?? '',
                  "deleted": 'false',
                  "deletedTime": this.deletedTime.toString() ?? '',
                  "reported": 'false',
                  "reportCount": '0',
                  "uploadTime": currentTimeStamp,
                  "updateTime": '',
                  "userName": "",
                  "haveChildComment": "false",
                  "parentCommentId": "${this.commentId}"
                })
                .then((value) => true)
                .whenComplete(() => null)
            : false;
      }
    }
  }

  Future addCoCoComment(
    String textContent,
    CommentData parentComment,
  ) async {
    final realtimeDb = FirebaseDatabase.instance.reference();
    String parentCommentId = parentComment.parentCommentId;
    if (await increaseCommentCount()) if (await updateCommentMap(false)) {
      String currentTimeStamp =
          DateTime.now().millisecondsSinceEpoch.toString();
      bool result = await saveCommentToUserCollection(currentTimeStamp,
              parentCommentid: parentCommentId) ??
          false;
      if (result)
        return realtimeDb
            .child('board')
            .child(this.boardId)
            .child(this.postId)
            .child(parentCommentId)
            .child("CoComment")
            .child(currentTimeStamp)
            .set({
              "uid": this.uid.toString(),
              "boardId": this.boardId.toString(),
              "boardName": this.boardName.toString(),
              "postId": this.postId.toString(),
              "textContent":
                  textContent.toString() ?? this.textContent.toString() ?? '',
              "deleted": 'false',
              "deletedTime": this.deletedTime.toString() ?? '',
              "reported": 'false',
              "reportCount": '0',
              "uploadTime": currentTimeStamp,
              "updateTime": '',
              "userName": "",
              "haveChildComment": "false",
              "parentCommentId": parentCommentId
            })
            .then((value) => true)
            .whenComplete(() => null);
    }
  }

  coCommentFromFirebaseReference(DataSnapshot snapshot) {
    Map<dynamic, dynamic> commentSnapshot =
        Map<dynamic, dynamic>.from(snapshot.value) ?? {};
    List<CommentData> commentList = [];

    commentSnapshot.forEach((key, value) {
      String boardID = value["boardId"];
      String postID = value["postId"];

      int reportCount;
      int uploadTime;
      int updateTime;
      if (value["reportCount"] == null ||
          value["reportCount"] == "null" ||
          value["reportCount"] == "")
        reportCount = 0;
      else
        reportCount = int.parse(value["reportCount"]);

      if (value["uploadTime"] == null ||
          value["uploadTime"] == "null" ||
          value["uploadTime"] == "")
        uploadTime = 0;
      else
        uploadTime = int.parse(value["uploadTime"]);

      if (value["updateTime"] == null ||
          value["updateTime"] == "null" ||
          value["updateTime"] == "")
        updateTime = 0;
      else
        updateTime = int.parse(value["updateTime"]);
      commentList.add(new CommentData(
          uid: value["uid"],
          boardId: boardID,
          boardName: value["boardName"],
          postId: postID,
          deleted: value["deleted"].toString() == 'true' ? true : false,
          deletedTime: value["deletedTime"],
          reportCount: reportCount,
          reported: value['reported'].toString() == 'true' ? true : false,
          updateTime: updateTime,
          uploadTime: uploadTime,
          textContent: value["textContent"],
          haveChildComment: haveChildComment,
          parentCommentId: value["parentCommentId"] ?? "",
          childCommentList: childCommentList,
          commentId: snapshot.key));
    });
    commentList.sort((a, b) => int.tryParse(a.commentId ?? 0)
        .compareTo(int.tryParse(b.commentId ?? 0)));
    return commentList;
  }

  updateCommentMap(bool isDismiss) async {
    final firestoreDb = FirebaseFirestore.instance;
    var saveResult = isDismiss ? FieldValue.delete() : true;

    return await firestoreDb
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .doc(this.boardId)
        .collection(this.boardId)
        .doc(this.postId)
        .update({"commentUserList." + currentUserModel.uid: saveResult})
        .then((value) => true)
        .whenComplete(() => true);
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
