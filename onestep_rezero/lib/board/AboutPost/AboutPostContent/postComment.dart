import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/StateManage/Provider/commentProvider.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/timeUtil.dart';

final commentProvider =
    ChangeNotifierProvider<CommentProvider>((ref) => CommentProvider());

class CommentWidget extends ConsumerWidget {
  final boardId;
  final postId;
  final commentList;
  final postWriterUID;
  final openSlidingPanelCallback;

  CommentWidget(
      {this.boardId,
      this.postId,
      this.openSlidingPanelCallback,
      this.commentList,
      this.postWriterUID});

  Widget commentBoxDesignMethod(
      int index, CommentData comment, double width, double height) {
    DateTime uploadTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(comment.uploadTime ?? 0));
    return
        // padding: EdgeInsets.symmetric(horizontal: width / 20),
        // width: width,
        // height: height / 6,
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: commentName(comment.uid),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(comment.textContent ?? "NO"),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text("${TimeUtil.timeAgo(date: uploadTime)}"),
        ),
        Container(
          width: width / 2,
          margin: EdgeInsets.only(bottom: height / 100),
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

  Widget commentName(
    String commentUID,
  ) {
    if (commentUID == postWriterUID) {
      return Text("작성자", style: TextStyle(color: OnestepColors().secondColor));
    }
    return Text("hi");
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
          child: AnimationLimiter(
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
                  child: commentBoxDesignMethod(
                      index, comment[index], deviceWidth, deviceHeight),
                ),
              ),
            );
          },
        ),
      ));
    else
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
}
