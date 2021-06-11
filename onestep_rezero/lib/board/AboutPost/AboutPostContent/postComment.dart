import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/StateManage/Provider/commentProvider.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/timeUtil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final commentProvider =
    ChangeNotifierProvider<CommentProvider>((ref) => CommentProvider());

abstract class Comment {
  commentBoxDesignMethod(
      int index, CommentData comment, double deviceWidth, double deviceHeight);
  checkCommentDeleted(
    CommentData comment,
  );

  commentName(commentUID, commentList);
  animationLimiterListView(
      List comment, double deviceWidth, double deviceHeight);
  commentListEmptyWidget();
  commentListSwipeMenu(comment, BuildContext context, {Widget child});
}

class CommentWidget extends ConsumerWidget implements Comment {
  final boardId;
  final postId;
  final commentList;
  final postWriterUID;
  final openSlidingPanelCallback;
  final SlidableController slidableController = SlidableController();

  CommentWidget(
      {this.boardId,
      this.postId,
      this.openSlidingPanelCallback,
      this.commentList,
      this.postWriterUID});

  @override
  Widget commentBoxDesignMethod(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    //Check Deleted
    if (checkCommentDeleted(comment)) {
      return deletedCommentWidget(index, comment, deviceWidth, deviceHeight);
    } else {
      //is deleted

      return commentWidget(index, comment, deviceWidth, deviceHeight);
    }
  }

  @override
  commentName(commentUID, commentList) {
    Map<String, dynamic> commentUserMap = commentList ?? {};
    List commentUserList = commentUserMap.keys.toList();
    if (commentUID.toString() == postWriterUID) {
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

// TimeUtil.timeAgo(date: postData.uploadTime)
  @override
  Widget build(BuildContext context, watch) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.width;
    final comment = watch(commentProvider).comments;

    bool isEmpty = comment.length == 0 ? true : false;
    if (!isEmpty)
      return Container(
          child: animationLimiterListView(comment, deviceWidth, deviceHeight));
    else
      return Container(child: commentListEmptyWidget());
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
                child: commentListSwipeMenu(
                  comment[index],
                  context,
                  slidableKey: Key(comment[index].commentId),
                  child: commentBoxDesignMethod(
                      index, comment[index], deviceWidth, deviceHeight),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  commentListEmptyWidget() {
    Column(
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
  commentListSwipeMenu(comment, context, {Widget child, Key slidableKey}) {
    Widget childWidget = child ?? Container();

    bool isWritter = comment.uid == postWriterUID;
    Key key = slidableKey ?? null;
    return Slidable(
      controller: slidableController,
      key: key,
      actionPane: SlidableDrawerActionPane(),
      child: childWidget,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          // onTap: () => _showSnackBar('Archive'),
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          // onTap: () => _showSnackBar('Share'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '댓글달기',
          color: Colors.black45,
          icon: Icons.add_comment,
        ),
        isWritter
            ? IconSlideAction(
                caption: '삭제',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  print("HELLO");
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
  checkCommentDeleted(CommentData comment) {
    return comment.deleted.toLowerCase() == "true";
  }

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
              )
        // StatefulBuilder(
        //   builder: (BuildContext context, setState) {
        //     bool animated = false;
        //     String textField = "삭제되었습니다.";
        //     showText() {
        //       if (animated) {
        //         textField = comment.textContent;
        //       } else {
        //         textField = "삭제되었습니다.";
        //       }
        //       animated = !animated;
        //     }

        //     return GestureDetector(
        //       onLongPress: () {
        //         setState(() {
        //           print("hi");
        //           // showText();
        //           animated = !animated;
        //           textField = "HIHIHIH";
        //         });
        //       },
        //       child:
        //           // AnimatedDefaultTextStyle(
        //           //   duration: Duration(milliseconds: 200),
        //           //   style: animated
        //           //       ? TextStyle(
        //           //           color: Colors.blue,
        //           //           fontSize: 26,
        //           //           fontWeight: FontWeight.w800,
        //           //           letterSpacing: 4,
        //           //         )
        //           //       : TextStyle(
        //           //           color: Colors.grey,
        //           //           fontWeight: FontWeight.w100,
        //           //           fontSize: 14,
        //           //           letterSpacing: 1,
        //           //         ),
        //           //   curve: Curves.elasticOut,
        //           //   child:
        //           Text(textField),
        //       // ),
        //     );
        //   },
        // ),
        );
  }

  commentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    DateTime uploadTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(comment.uploadTime ?? 0) ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: deviceHeight / 30)),
        Container(
          alignment: Alignment.centerLeft,
          child: commentName(comment.uid, commentList),
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
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: OnestepColors().thirdColor.withOpacity(0.2),
                      width: 2.0),
                  left: BorderSide(
                      color: OnestepColors().thirdColor.withOpacity(0.2),
                      width: 2.0))),
          alignment: Alignment.topLeft,
        )
      ],
    );
  }
}
