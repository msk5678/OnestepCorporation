import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postCoComment.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/StateManage/Provider/commentProvider.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/timeUtil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final commentProvider =
    ChangeNotifierProvider<CommentProvider>((ref) => CommentProvider());

abstract class Comment {
  commentBoxDesignMethod(
      int index, CommentData comment, double deviceWidth, double deviceHeight);

  commentName(String commentUID, String postWriterUid, commentList);
  animationLimiterListView(
      List comment, double deviceWidth, double deviceHeight);
  commentListEmptyWidget();
  commentListSwipeMenu(comment, BuildContext context, currentLogInUid,
      {Widget child});
  deletedCommentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight);
  commentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight);
}

class CommentWidget extends CommentParent {
  final boardId;
  final postId;
  final commentMap;
  final postWriterUID;
  final openSlidingPanelCallback;
  final coCommentCallback;
  final showDialogCallback;
  final SlidableController slidableController = SlidableController();

  CommentWidget(
      {this.boardId,
      this.postId,
      this.openSlidingPanelCallback,
      this.commentMap,
      this.postWriterUID,
      this.coCommentCallback,
      this.showDialogCallback});
  @override
  Widget build(BuildContext context, watch) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final commentprovider = watch(commentProvider);
    bool isFetch = commentprovider.isFetching;
    if (isFetch) {
      return CupertinoActivityIndicator();
    } else {
      bool isEmpty = commentprovider.comments.length == 0 ? true : false;
      if (!isEmpty)
        return Container(
            child: animationLimiterListView(
                commentprovider.comments, deviceWidth, deviceHeight));
      else
        return Container(child: commentListEmptyWidget());
    }
  }
}

abstract class CommentParent extends ConsumerWidget implements Comment {
  final boardId;
  final postId;
  final commentMap;
  final postWriterUID;
  final openSlidingPanelCallback;
  final coCommentCallback;
  final showDialogCallback;
  final SlidableController slidableController = SlidableController();

  CommentParent(
      {this.boardId,
      this.postId,
      this.openSlidingPanelCallback,
      this.commentMap,
      this.postWriterUID,
      this.coCommentCallback,
      this.showDialogCallback});

  @override
  Widget commentBoxDesignMethod(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    //Check Deleted
    if (comment.deleted)
      return deletedCommentWidget(index, comment, deviceWidth, deviceHeight);
    else
      //is deleted
      return commentWidget(index, comment, deviceWidth, deviceHeight);
  }

  // @override
  // commentName(commentUID, postWriterUid, commentList) {
  //   Map<String, dynamic> commentUserMap = commentList ?? {};
  //   List commentUserList = commentUserMap.keys.toList();
  //   if (commentUID.toString() == postWriterUid) {
  //     return Text("작성자",
  //         style: TextStyle(color: OnestepColors().mainColor, fontSize: 13));
  //   } else {
  //     for (int i = 0; i < commentUserList.length; i++) {
  //       if (commentUserList[i].toString() == commentUID) {
  //         return Text("익명 ${i + 1}",
  //             style:
  //                 TextStyle(color: OnestepColors().secondColor, fontSize: 13));
  //       } else {
  //         return Text("익명 ${commentUserList.length + 1}",
  //             style:
  //                 TextStyle(color: OnestepColors().secondColor, fontSize: 13));
  //       }
  //     }
  //   }
  // }
  @override
  commentName(commentUID, postWriterUid, commentList) {
    Map<String, dynamic> commentUserMap = commentList ?? {};
    List commentUserList = commentUserMap.keys.toList();
    if (commentUID.toString() == postWriterUid) {
      return "작성자";
    } else {
      for (int i = 0; i < commentUserList.length; i++) {
        if (commentUserList[i].toString() == commentUID)
          return "익명 ${i + 1}";
        else
          return "익명 ${commentUserList.length + 1}";
      }
    }
    return "";
  }

  @override
  animationLimiterListView(
      List comment, double deviceWidth, double deviceHeight) {
    return AnimationLimiter(
      child: ListView.builder(
        key: PageStorageKey<String>("commentList"),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: comment.length,
        itemBuilder: (BuildContext context, int index) {
          CommentData currentIndexCommentData = comment[index];
          // print("currentIndexCommentData : ${currentIndexCommentData.}");
          bool isDeleted = currentIndexCommentData.deleted;
          bool haveChildComment = currentIndexCommentData.haveChildComment;
          currentIndexCommentData
            ..userName = commentName(
                currentIndexCommentData.uid, postWriterUID, commentMap);

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: OnestepColors().mainColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: !isDeleted
                          ? commentListSwipeMenu(
                              currentIndexCommentData,
                              context,
                              currentUserModel.uid,
                              slidableKey:
                                  Key(currentIndexCommentData.commentId),
                              child: commentBoxDesignMethod(
                                  index,
                                  currentIndexCommentData,
                                  deviceWidth,
                                  deviceHeight),
                            )
                          : commentBoxDesignMethod(
                              index,
                              currentIndexCommentData,
                              deviceWidth,
                              deviceHeight),
                    ),
                    haveChildComment
                        ? childCommentWidget(
                            currentIndexCommentData.childCommentList)
                        : Container()
                    // coCommentWidget(currentIndexCommentData.haveChildComment,
                    //     currentIndexCommentData)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  childCommentWidget(childCommentList) {
    return ChildComment(
      childCommentList: childCommentList,
      coCommentCallback: coCommentCallback,
      openSlidingPanelCallback: openSlidingPanelCallback,
      slidableController: slidableController,
      postWriterUID: postWriterUID,
      commentMap: commentMap,
      refreshCallback: refreshComment,
      showDialogCallback: showDialogCallback,
    );
  }

  @override
  commentListEmptyWidget() {
    return Column(
      children: [
        ShowUp(
          delay: 300,
          child: Text("작성된 댓글이 없습니다."),
        ),
        ShowUp(
            delay: 350,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    elevation: 0, primary: OnestepColors().secondColor),
                onPressed: () => openSlidingPanelCallback(),
                // onPressed: () {
                // context.read(commentProvider).refresh(boardId, postId);
                // },
                icon: Icon(Icons.add_comment_rounded),
                label: Text("작성하기"))),
      ],
    );
  }

  @override
  commentListSwipeMenu(comment, context, currentLogInUid,
      {Widget child, Key slidableKey}) {
    Widget childWidget = child ?? Container();

    bool isWritter = comment.uid == currentLogInUid;

    Key key = slidableKey ?? null;
    return Slidable(
      controller: slidableController,
      key: key,
      actionPane: SlidableDrawerActionPane(),
      child: childWidget,
      // actions: <Widget>[
      //   IconSlideAction(
      //     caption: 'Archive',
      //     color: Colors.blue,
      //     icon: Icons.archive,
      //     // onTap: () => _showSnackBar('Archive'),
      //   ),
      //   IconSlideAction(
      //     caption: 'Share',
      //     color: Colors.indigo,
      //     icon: Icons.share,
      //     // onTap: () => _showSnackBar('Share'),
      //   ),
      // ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '댓글달기',
          color: Colors.black45,
          icon: Icons.add_comment,
          onTap: () {
            coCommentCallback(comment);
          },
        ),
        isWritter
            ? IconSlideAction(
                caption: '삭제',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  bool result = await comment.dismissComment() ?? false;
                  if (result) refreshComment(context, boardId, postId);
                },
              )
            : IconSlideAction(
                caption: '신고하기',
                color: Colors.red,
                icon: Icons.flag,
              ),
      ],
    );
  }

  @override
  deletedCommentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    DateTime deleteTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(comment.deletedTime ?? 0) ?? 0);
    bool deletedTimeWithDay = DateTime.now().difference(deleteTime).inDays < 1;
    //Deleted Time with in 24h
    DateTime uploadTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(comment.uploadTime ?? 0) ?? 0);
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
          left: 8,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          deletedTimeWithDay
              ? GestureDetector(
                  onLongPress: () => showDialogCallback(comment),
                  child: Container(
                    width: deviceWidth,
                    child: Text(
                      "삭제되었습니다.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : Text(
                  "삭제되었습니다.",
                  style: TextStyle(color: Colors.grey),
                ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              "${TimeUtil.timeAgo(date: uploadTime)}",
              style: TextStyle(color: Colors.grey[700], fontSize: 10),
            ),
          )
        ]));
  }

  refreshComment(BuildContext context, String boardId, String postId) {
    context.read(commentProvider).refresh(boardId, postId);
  }

  // coCommentWidget(bool haveChildComment, CommentData comment) {
  //   final dbReference = FirebaseDatabase.instance.reference();
  //   if (haveChildComment) {
  //     return FutureBuilder<DataSnapshot>(
  //         future: dbReference
  //             .child('board')
  //             .child(boardId.toString())
  //             .child(postId.toString())
  //             .child(comment.commentId)
  //             .child("CoComment")
  //             .once(),
  //         builder: (context, snapshot) {
  //           switch (snapshot.connectionState) {
  //             case ConnectionState.none:
  //             case ConnectionState.waiting:
  //               return Container();
  //             default:
  //               if (snapshot.hasError || !snapshot.hasData) {
  //                 return Center(
  //                     child: Column(
  //                   children: [
  //                     Text("Error"),
  //                     IconButton(
  //                         icon: Icon(Icons.refresh),
  //                         onPressed: () {
  //                           context
  //                               .read(commentProvider)
  //                               .refresh(boardId, postId);
  //                         })
  //                   ],
  //                 ));
  //               } else {
  //                 List<CommentData> _commentDataList = [];
  //                 _commentDataList =
  //                     CommentData().fromFirebaseReference(snapshot.data);
  //                 return CoComment(
  //                   boardId: boardId,
  //                   commentMap: commentMap,
  //                   coCommentCallback: coCommentCallback,
  //                   coCommentList: _commentDataList,
  //                   openSlidingPanelCallback: openSlidingPanelCallback,
  //                   postId: postId,
  //                   postWriterUID: postWriterUID,
  //                   slidableController: slidableController,
  //                 );
  //               }
  //           }
  //         });
  //   } else {
  //     return Container();
  //   }
  // }

  @override
  commentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    DateTime uploadTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(comment.uploadTime ?? 0) ?? 0);
    bool isWritter = comment.userName == "작성자";
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              // child: commentName(comment.uid, postWriterUID, commentList),
              child: Text(
                comment.userName,
                style: isWritter
                    ? TextStyle(
                        fontWeight: FontWeight.bold,
                        color: OnestepColors().mainColor)
                    : TextStyle(
                        fontWeight: FontWeight.bold,
                        color: OnestepColors().secondColor),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 8,
                top: 10,
              ),
              alignment: Alignment.centerLeft,
              child: Text(comment.textContent ?? "NO"),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () =>
                          coCommentCallback(comment..isUnderComment = true),
                      child: Text(
                        "댓글달기",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${TimeUtil.timeAgo(date: uploadTime)}",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
