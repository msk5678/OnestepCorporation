import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5)),
          //     border: Border(
          //       bottom: BorderSide(
          //           color: OnestepColors().thirdColor.withOpacity(0.2),
          //           width: 2.0),
          //       left: BorderSide(
          //           color: OnestepColors().thirdColor.withOpacity(0.2),
          //           width: 2.0),
          //       top: BorderSide(color: Colors.white, width: 2.0),
          //       right: BorderSide(color: Colors.white, width: 2.0),
          // )),
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
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Column(
                  children: [
                    !comment[index].deleted
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
                        // Dismissible(
                        //     onDismissed: (direction) {},
                        //     key: ValueKey<String>(comment[index].commentId),
                        //     background: Container(
                        //       color: Colors.green,
                        //     ),
                        //     child: commentBoxDesignMethod(index, comment[index],
                        //         deviceWidth, deviceHeight),
                        //   )
                        : commentBoxDesignMethod(index, currentIndexCommentData,
                            deviceWidth, deviceHeight),
                  ],
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

    return Container(
        alignment: Alignment.centerLeft,
        height: deviceHeight / 9,
        padding: EdgeInsets.only(
          left: 8,
          top: deviceHeight / 30,
          bottom: deviceHeight / 30,
        ),
        child: deletedTimeWithDay
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
                style: TextStyle(color: Colors.redAccent),
              ));
  }

  @override
  Widget commentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    DateTime uploadTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(comment.uploadTime ?? 0) ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: deviceHeight / 30)),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(comment.userName),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 8,
            top: 5,
          ),
          alignment: Alignment.centerLeft,
          child: Text(comment.textContent ?? "NO"),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            "${TimeUtil.timeAgo(date: uploadTime)}",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
        Container(
          width: deviceWidth / 2,
          margin: EdgeInsets.only(bottom: deviceHeight / 100),
          // decoration: BoxDecoration(
          //     border: Border(
          //   bottom: BorderSide(
          //       color: OnestepColors().thirdColor.withOpacity(0.2), width: 2.0),
          // left: BorderSide(
          //     color: OnestepColors().thirdColor.withOpacity(0.2),
          //     width: 2.0)
          // )),
          alignment: Alignment.topLeft,
        )
      ],
    );
  }
}
