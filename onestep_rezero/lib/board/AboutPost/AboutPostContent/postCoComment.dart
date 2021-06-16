import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/timeUtil.dart';

class CoComment extends StatelessWidget implements Comment {
  final boardId;
  final postId;
  final postWriterUID;
  final openSlidingPanelCallback;
  final coCommentCallback;
  final coCommentList;
  final commentMap;
  final SlidableController slidableController;
  CoComment(
      {this.boardId,
      this.postId,
      this.coCommentCallback,
      this.openSlidingPanelCallback,
      this.postWriterUID,
      this.commentMap,
      this.coCommentList,
      this.slidableController});
  @override
  Widget build(
    BuildContext context,
  ) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.width;

    bool isEmpty = coCommentList.length == 0 ? true : false;
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
              coCommentList, deviceWidth, deviceHeight));
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
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                  child: !comment[index].deleted
                      ? commentListSwipeMenu(
                          comment[index],
                          context,
                          slidableKey: Key(comment[index].commentId),
                          child: commentBoxDesignMethod(
                              index, comment[index], deviceWidth, deviceHeight),
                        )
                      : commentBoxDesignMethod(
                          index, comment[index], deviceWidth, deviceHeight)),
            ),
          );
        },
      ),
    );
  }

  @override
  commentListEmptyWidget() {}

  @override
  commentListSwipeMenu(comment, context, {Widget child, Key slidableKey}) {
    Widget childWidget = child ?? Container();

    bool isWritter = comment.uid == postWriterUID;
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
                  if (result)
                    context.read(commentProvider).refresh(boardId, postId);
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
      return Text("작성자",
          style: TextStyle(color: OnestepColors().secondColor, fontSize: 13));
    } else {
      for (int i = 0; i < commentUserList.length; i++) {
        if (commentUserList[i].toString() == commentUID) {
          return Text("익명 ${i + 1}",
              style:
                  TextStyle(color: OnestepColors().secondColor, fontSize: 13));
        } else {
          return Text("ERROR",
              style:
                  TextStyle(color: OnestepColors().secondColor, fontSize: 13));
        }
      }
    }
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
            ? Text(
                "삭제되었습니다.",
                style: TextStyle(color: Colors.grey),
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
          child: commentName(comment.uid, postWriterUID, commentMap),
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
