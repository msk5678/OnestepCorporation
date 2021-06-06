import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/StateManage/Provider/commentProvider.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';

final commentProvider =
    ChangeNotifierProvider<CommentProvider>((ref) => CommentProvider());

class CommentWidget extends ConsumerWidget {
  final boardId;
  final postId;
  final openSlidingPanelCallback;
  CommentWidget({this.boardId, this.postId, this.openSlidingPanelCallback});

  Widget commentBoxDesignMethod(int index, CommentData comment) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(comment.textContent ?? "NO"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, watch) {
    context.read(commentProvider).fetchData(boardId, postId);
    final comment = watch(commentProvider).comments;
    print("Comment List length is : ${comment.length}");
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
                  child: commentBoxDesignMethod(index, comment[index]),
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
