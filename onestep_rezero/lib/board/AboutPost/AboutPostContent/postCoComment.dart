import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/timeUtil.dart';

class ChildComment extends StatelessWidget implements Comment {
  final postWriterUID;
  final openSlidingPanelCallback;
  final coCommentCallback;
  final childCommentList;
  final commentMap;
  final refreshCallback;
  final boardId;
  final postId;
  final SlidableController slidableController;
  final showDialogCallback;

  ChildComment(
      {this.coCommentCallback,
      this.openSlidingPanelCallback,
      this.postWriterUID,
      this.commentMap,
      this.childCommentList,
      this.slidableController,
      this.refreshCallback,
      this.postId,
      this.boardId,
      this.showDialogCallback});
  @override
  Widget build(
    BuildContext context,
  ) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.width;
    if (childCommentList == null) {
      return Center(
        child: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => refreshCallback(context, boardId, postId)),
      );
    }
    bool isEmpty = childCommentList.length == 0 ? true : false;
    if (!isEmpty)
      return Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(left: 5),
          child: animationLimiterListView(
              childCommentList, deviceWidth, deviceHeight));
    else
      return Container();
  }

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
          currentIndexCommentData
            ..userName = commentName(
                currentIndexCommentData.uid, postWriterUID, commentMap);
          bool isDeleted = comment[index].deleted;
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: !isDeleted
                      ? commentListSwipeMenu(
                          currentIndexCommentData,
                          context,
                          currentUserModel.uid,
                          slidableKey: Key(currentIndexCommentData.commentId),
                          child: commentBoxDesignMethod(
                              index,
                              currentIndexCommentData,
                              deviceWidth,
                              deviceHeight),
                        )
                      : commentBoxDesignMethod(index, currentIndexCommentData,
                          deviceWidth, deviceHeight),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  commentListEmptyWidget() {}

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
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '댓글달기',
          color: Colors.black45,
          icon: Icons.add_comment,
          onTap: () {
            coCommentCallback(comment..isUnderComment = true);
          },
        ),
        isWritter
            ? IconSlideAction(
                caption: '삭제',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  bool result = await comment.dismissComment() ?? false;
                  if (result)
                    context
                        .read(commentProvider)
                        .refresh(comment.boardId, comment.postId);
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

  @override
  Widget commentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    DateTime uploadTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(comment.uploadTime ?? 0) ?? 0);
    bool isWritter = comment.userName == "작성자";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
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
            left: 10,
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
                    style: TextStyle(color: Colors.grey[700], fontSize: 10),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "${TimeUtil.timeAgo(date: uploadTime)}",
                  style: TextStyle(color: Colors.grey[700], fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
