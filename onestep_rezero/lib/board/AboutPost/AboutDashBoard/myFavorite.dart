import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:onestep_rezero/board/AboutPost/AboutPostListView/listRiverpod.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/postList.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/postListMain.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/StateManage/Provider/userProvider.dart';
import 'package:onestep_rezero/board/boardMain.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class UserFavoriteList extends StatefulWidget {
  final dashBoardIconData;
  UserFavoriteList({Key key, this.dashBoardIconData}) : super(key: key);

  @override
  _UserPostingListState createState() => _UserPostingListState();
}

class _UserPostingListState extends PostListParentWidget<UserFavoriteList> {
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
    context.read(userBoardDataProvider).getUserFavoriteList(currentUid);
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
    return UserFavoriteListRiverPod(
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

class UserFavoriteListRiverPod extends ConsumerWidget {
  final postClickEventCallback;
  UserFavoriteListRiverPod({this.postClickEventCallback});

  @override
  Widget build(BuildContext context, watch) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final userFavoriteProvider = watch(userBoardDataProvider);

    // var user = userFavoriteProvider.userFavoritePostMap;
    //Get PostId From RealtimeFirebase
    List<UserData> _userFavoritePostIdList =
        userFavoriteProvider.userFavoritePostMap.values.toList();
    //send to PostIdList To postList using parameter and Set postList
    context.read(listProvider).fetchPostDataFromPostId(_userFavoritePostIdList);
    bool isFetching = userFavoriteProvider.isFetching;

    if (!isFetching && _userFavoritePostIdList.length == 0) {
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
              ? UserFavoriteListData(
                  userFavoriteDataList: _userFavoritePostIdList,
                  callback: postClickEventCallback,
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

class UserFavoriteListData extends ConsumerWidget {
  final List<UserData> userFavoriteDataList;
  final Function callback;
  UserFavoriteListData({this.userFavoriteDataList, this.callback});
  @override
  Widget build(BuildContext context, watch) {
    final userFavoriteProvider = watch(listProvider);
    bool isFetching = userFavoriteProvider.isFetch;
    return isFetching
        ? Container()
        : PostList(
            postList: userFavoriteProvider.posts,
            customPostListCallback: callback,
          );
  }
}
