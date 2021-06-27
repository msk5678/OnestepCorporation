import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/boardMain.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/loggedInWidget.dart';

import 'package:onestep_rezero/timeUtil.dart';
// class UserWritenCommentList extends CommentWidget{

// }

class UserWrittenCommentList extends StatefulWidget {
  final dashBoardIconData;
  UserWrittenCommentList({Key key, this.dashBoardIconData}) : super(key: key);

  @override
  _UserWrittenCommentListState createState() => _UserWrittenCommentListState();
}

class _UserWrittenCommentListState extends State<UserWrittenCommentList> {
  double deviceWidth;
  BoardInitData dashBoardIcon;
  @override
  void initState() {
    context.read(userBoardDataProvider).getUserCommentList();
    dashBoardIcon = widget.dashBoardIconData;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    deviceWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
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
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Container(
                        child: UserWrittenCommentListWidget(
                      snackBarCallback: showSnackBar,
                    ))))));
  }

  showSnackBar(Text textMessage,
      {SnackBarAction snackBarAction, Duration duration}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: textMessage,
      duration: duration ?? Duration(milliseconds: 500),
      action: snackBarAction ?? null,
    ));
  }
}

class UserWrittenCommentListWidget extends ConsumerWidget implements Comment {
  final snackBarCallback;
  UserWrittenCommentListWidget({this.snackBarCallback});
  @override
  Widget build(BuildContext context, watch) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final userProvider = watch(userBoardDataProvider);
    List<CommentData> commentList = userProvider.userCommentList;
    bool isFetch = userProvider.isFetching;
    bool isEmpty = commentList.length == 0 ? true : false;
    if (!isEmpty)
      return Column(
        children: [
          Container(
              child: animationLimiterListView(
                  commentList, deviceWidth, deviceHeight)),
          isFetch ? Center(child: CupertinoActivityIndicator()) : Container()
        ],
      );
    else
      return !isFetch
          ? Container(
              child: Center(
                  child: commentListEmptyWidget(
                      deviceHeight: deviceHeight, deviceWidth: deviceWidth)))
          : Center(child: CupertinoActivityIndicator());
  }

  @override
  commentListSwipeMenu(comment, BuildContext context, currentLogInUid,
      {Widget child, Key slidableKey}) {
    return child;
    // return GestureDetector(
    //     onTap: () async {
    //       PostData clickedPostData = await FirebaseFirestore.instance
    //           .collection('university')
    //           .doc(currentUserModel.university)
    //           .collection("board")
    //           .doc(comment.boardId)
    //           .collection(comment.boardId)
    //           .doc(comment.postId)
    //           .get()
    //           .then((DocumentSnapshot documentSnapshot) =>
    //               PostData.fromFireStore(documentSnapshot));
    //       print("clickedPostData.deleted : ${clickedPostData.deleted}");
    //       if (!clickedPostData.deleted) {
    //         Navigator.of(context).pushNamed("/PostContent",
    //             arguments: {"CURRENTBOARDDATA": clickedPostData}).then((value) {
    //           // context
    //           //     .read(writtenCommentProvider)
    //           //     .fetchUserWrittenComment(currentUserModel.uid);
    //         });
    //       } else {
    //         ScaffoldMessenger.of(context)
    //             .showSnackBar(showSnackBar(textMessage: Text("삭제된 게시글입니다.")));
    //       }
    //     },
    //     child: child);
  }

  @override
  animationLimiterListView(
      List comment, double deviceWidth, double deviceHeight) {
    return AnimationLimiter(
      child: ListView.builder(
        key: PageStorageKey<String>("commentList"),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: comment.length,
        itemBuilder: (BuildContext context, int index) {
          CommentData currentIndexCommentData = comment[index];

          bool isDeleted = currentIndexCommentData.deleted;

          currentIndexCommentData
            ..userName = commentName(currentIndexCommentData.uid, null, null);

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        PostData clickedPostData = await FirebaseFirestore
                            .instance
                            .collection('university')
                            .doc(currentUserModel.university)
                            .collection("board")
                            .doc(currentIndexCommentData.boardId)
                            .collection(currentIndexCommentData.boardId)
                            .doc(currentIndexCommentData.postId)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) =>
                                PostData.fromFireStore(documentSnapshot));
                        bool isDeletedPost = clickedPostData.deleted;
                        if (!isDeletedPost) {
                          Navigator.of(context).pushNamed("/PostContent",
                              arguments: {
                                "CURRENTBOARDDATA": clickedPostData
                              }).then((value) {});
                        } else {
                          snackBarCallback(Text("이미 삭제된 게시글입니다."));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: OnestepColors().mainColor,
                              width: 0.5,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: !isDeleted
                            ? commentListSwipeMenu(
                                currentIndexCommentData,
                                context,
                                currentUserModel.uid,
                                slidableKey:
                                    Key(currentIndexCommentData.commentId),
                                child: commentBoxDesignMethod(
                                    index,
                                    currentIndexCommentData,
                                    deviceWidth,
                                    deviceHeight),
                              )
                            : commentBoxDesignMethod(
                                index,
                                currentIndexCommentData,
                                deviceWidth,
                                deviceHeight),
                      ),
                    ),
                    // coCommentWidget(currentIndexCommentData.haveChildComment,
                    //     currentIndexCommentData)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget commentBoxDesignMethod(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    return commentWidget(index, comment, deviceWidth, deviceHeight);
  }

  @override
  commentListEmptyWidget({double deviceHeight, double deviceWidth}) {
    return Container(
      height: deviceHeight / 2,
      width: deviceWidth,
      child: Center(
        child: ShowUp(
          delay: 300,
          child: Text("작성된 댓글이 없습니다."),
        ),
      ),
    );
  }

  @override
  commentName(commentUID, postWriterUid, commentList, {bool isDeleted}) {
    return "나";
  }

  @override
  commentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    DateTime uploadTime =
        DateTime.fromMillisecondsSinceEpoch(comment.uploadTime);

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child:
                        // child: commentName(comment.uid, postWriterUID, commentList),

                        Text(
                            commentName(
                              comment.uid,
                              null,
                              null,
                            ),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: OnestepColors().mainColor))),
                comment.deleted
                    ? Text(" (삭제됨)",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red))
                    : Container(),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                left: 8,
                top: 10,
              ),
              alignment: Alignment.centerLeft,
              child: Text(comment.textContent ?? "NO"),
            ),
            Container(
              // margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${TimeUtil.timeAgo(date: uploadTime)}",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  deletedCommentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    return Container();
  }
}
