import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/AboutPost/createPost.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';

class AlterPost extends StatefulWidget {
  final postData;
  AlterPost({Key key, this.postData}) : super(key: key);

  @override
  _AlterPostState createState() => _AlterPostState();
}

class _AlterPostState extends CreatePageParent<AlterPost> {
  PostData alterPostData;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alterPostData = widget.postData;
  }

  @override
  setBoardData() {
    // TODO: implement setBoardData
    throw UnimplementedError();
  }
}
