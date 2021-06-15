import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';

class CoComment extends StatelessWidget implements Comment {
  const CoComment({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // child: ,
        );
  }

  @override
  commentBoxDesignMethod(
      int index, CommentData comment, double width, double height) {
    // TODO: implement commentBoxDesignMethod
    throw UnimplementedError();
  }

  @override
  animationLimiterListView(
      List comment, double deviceWidth, double deviceHeight) {
    // TODO: implement animationLimiterListView
    throw UnimplementedError();
  }

  @override
  commentListEmptyWidget() {
    // TODO: implement commentListEmptyWidget
    throw UnimplementedError();
  }

  @override
  checkCommentDeleted(CommentData comment) {
    // TODO: implement checkCommentDeleted
    throw UnimplementedError();
  }

  @override
  commentListSwipeMenu(comment, BuildContext context, {Widget child}) {
    // TODO: implement commentListSwipeMenu
    throw UnimplementedError();
  }

  @override
  commentName(String commentUID, String postWriterUid, commentList) {
    // TODO: implement commentName
    throw UnimplementedError();
  }
}
