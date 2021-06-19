import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/photoList.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/postList.dart';
import 'package:onestep_rezero/board/StateManage/Provider/postListProvider.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';

final listProvider =
    ChangeNotifierProvider<PostListProvider>((ref) => PostListProvider());

class ListRiverPod extends ConsumerWidget {
  final boardCategory;
  final customPostListCallback;
  ListRiverPod({this.boardCategory, this.customPostListCallback});
  @override
  Widget build(BuildContext context, watch) {
    final listprovider = watch(listProvider).posts;
    if (boardCategory != null) {
      if (boardCategory == BoardCategory.POST) {
        return PostList(
          postList: listprovider,
        );
      } else if (boardCategory == BoardCategory.PICTURE) {
        return PhotoList(
          photoList: listprovider,
        );
      } else if (boardCategory == BoardCategory.VOTE) {
        return Container();
      } else {
        return Container(
          child: Center(
            child: Text("Post List Error "),
          ),
        );
      }
    } else {
      //This class is userPost list
      return PostList(
        postList: listprovider,
        customPostListCallback: customPostListCallback,
      );
    }
  }
}
