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
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final listprovider = watch(listProvider);
    bool isFetching = listprovider.isFetch;
    bool isNextFetching = listprovider.nextFetching;
    if (boardCategory != null) {
      Widget postListWidget;

      if (boardCategory == BoardCategory.POST) {
        postListWidget = PostList(
          postList: listprovider.posts,
          isfetch: isFetching,
        );
      } else if (boardCategory == BoardCategory.PICTURE) {
        postListWidget = PhotoList(
          photoList: listprovider.posts,
        );
      } else if (boardCategory == BoardCategory.VOTE) {
        postListWidget = Container();
      } else {
        postListWidget = Container(
          child: Center(
            child: Text("Post List Error "),
          ),
        );
      }

      return Column(
        children: [
          postListWidget,
          isNextFetching
              ? Container(
                  height: deviceHeight,
                  width: deviceWidth,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : Container(),
        ],
      );
    } else {
      //This class is userPost list
      return Column(
        children: [
          !isFetching
              ? PostList(
                  isfetch: isFetching,
                  postList: listprovider.posts,
                  customPostListCallback: customPostListCallback,
                )
              : Container(),
          isFetching
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : Container(),
        ],
      );
    }
  }
}
