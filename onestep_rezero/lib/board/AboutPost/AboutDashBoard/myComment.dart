import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/main.dart';
// class UserWritenCommentList extends CommentWidget{

// }
class UserWrittenCommentList extends StatefulWidget {
  UserWrittenCommentList({Key key}) : super(key: key);

  @override
  _UserWrittenCommentListState createState() => _UserWrittenCommentListState();
}

class _UserWrittenCommentListState extends State<UserWrittenCommentList> {
  @override
  void initState() {
    context.read(commentProvider).fetchUserWrittenComment(currentUserModel.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UserWrittenCommentListWidget();
  }
}

class UserWrittenCommentListWidget extends CommentWidget {}
