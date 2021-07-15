import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/listRiverpod.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/postList.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/postListMain.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class TopFavoritePostList extends StatefulWidget {
  final dashBoardIconData;
  TopFavoritePostList({Key key, this.dashBoardIconData}) : super(key: key);

  @override
  _TopFavoritePostListState createState() => _TopFavoritePostListState();
}

class _TopFavoritePostListState
    extends PostListParentWidget<TopFavoritePostList> {
  final currentUid = currentUserModel.uid;
  BoardInitData dashBoardIcon;
  @override
  void initState() {
    dashBoardIcon = widget.dashBoardIconData;
    super.initState();
  }

  @override
  setCurrentBoardDataCategory(
      BoardData boardData, BoardCategory boardCategory) {}
  @override
  getPostList(BoardData currentBoard) {
    context.read(listProvider).fetchTopFavoritePost();
  }

  @override
  Widget productAddFLoatingActionButton(
      BoardData currentBoard, StreamController productAddStreamController) {
    return Container();
  }

  @override
  setProductScroll(StreamController productAddStreamController,
      ScrollController scrollController) {}

  @override
  void scrollListenerScroll() {
    super.scrollListenerScroll();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            dashBoardIcon.explain,
            style: TextStyle(color: Colors.black),
          ),
        ),
        // ),
        body: SingleChildScrollView(
          child: Column(children: [postListMainWidget(currentBoardCategory)]),
          controller: scrollController,
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: scrollToTopFloatingActionButton(scrollToTopstreamController),
        ),
      ),
    );
  }

  @override
  postListMainWidget(BoardCategory currentCategory) {
    return TopFavoriteListRiverPod(
      postClickEventCallback: _postClickEventCallback,
    );
  }

  _postClickEventCallback(
      BuildContext context, PostData postData, String uid) async {
    await Navigator.of(context)
        .pushNamed('/PostContent', arguments: {"CURRENTBOARDDATA": postData});
    // .then((value) => context.read(listProvider).fetchUserPosting(uid));
  }
}

class TopFavoriteListRiverPod extends ConsumerWidget {
  final postClickEventCallback;
  TopFavoriteListRiverPod({this.postClickEventCallback});

  @override
  Widget build(BuildContext context, watch) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final topFavoriteList = watch(listProvider);
    bool isFetching = topFavoriteList.isFetch;
    if (!isFetching && topFavoriteList.posts.length == 0) {
      return Container(
        height: deviceHeight / 2,
        width: deviceWidth,
        child: Center(
          child: ShowUp(delay: 300, child: Text("인기게시글이 없습니다.")),
        ),
      );
    } else
      return Column(
        children: [
          !isFetching
              ? PostList(
                  postList: topFavoriteList.posts,
                  customPostListCallback: postClickEventCallback,
                )
              : Container(),
          isFetching
              ? Container(
                  height: deviceHeight / 2,
                  width: deviceWidth,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ))
              : Container(),
        ],
      );
  }
}
