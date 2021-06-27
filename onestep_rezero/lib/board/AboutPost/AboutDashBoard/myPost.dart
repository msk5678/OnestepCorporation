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

import '../../../loggedInWidget.dart';

class UserPostingList extends StatefulWidget {
  final dashBoardIconData;
  UserPostingList({Key key, this.dashBoardIconData}) : super(key: key);

  @override
  _UserPostingListState createState() => _UserPostingListState();
}

class _UserPostingListState extends PostListParentWidget<UserPostingList> {
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
    context.read(listProvider).fetchUserPosting(currentUid);
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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: FadeIn(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: deviceWidth / 200, right: deviceWidth / 250),
                  child: IconButton(
                    icon: dashBoardIcon.icons,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Text(
                  dashBoardIcon.explain,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 300),
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
    return MyPostRiverPod(
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

class MyPostRiverPod extends ConsumerWidget {
  final postClickEventCallback;
  MyPostRiverPod({this.postClickEventCallback});

  @override
  Widget build(BuildContext context, watch) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final userPostList = watch(listProvider);
    bool isFetching = userPostList.isFetch;
    if (!isFetching && userPostList.posts.length == 0) {
      return Container(
        height: deviceHeight / 2,
        width: deviceWidth,
        child: Center(
          child: ShowUp(delay: 300, child: Text("좋아하는 게시글이 없습니다.")),
        ),
      );
    } else
      return Column(
        children: [
          !isFetching
              ? PostList(
                  postList: userPostList.posts,
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
