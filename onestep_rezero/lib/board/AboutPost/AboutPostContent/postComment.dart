import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/StateManage/Provider/commentFutureProvider.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';

final commentProvider =
    ChangeNotifierProvider<CommentProvider>((ref) => CommentProvider());

class CommentWidget extends ConsumerWidget {
  final boardId;
  final postId;
  CommentWidget({this.boardId, this.postId});

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
    print("HELLO");
    final comment = watch(commentProvider);
    context.read(commentProvider).fetchData(boardId, postId);

    return Container(
        child: AnimationLimiter(
      child: ListView.builder(
        key: PageStorageKey<String>("commentList"),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: comment.comments.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: commentBoxDesignMethod(index, comment.comments[index]),
              ),
            ),
          );
        },
      ),
    ));
  }
}
