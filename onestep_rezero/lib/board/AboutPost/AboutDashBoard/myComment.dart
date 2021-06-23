import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/StateManage/Provider/commentProvider.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/timeUtil.dart';
// class UserWritenCommentList extends CommentWidget{

// }

final writtenCommentProvider =
    ChangeNotifierProvider<CommentProvider>((ref) => CommentProvider());

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
    dashBoardIcon = widget.dashBoardIconData;
    context
        .read(writtenCommentProvider)
        .fetchUserWrittenComment(currentUserModel.uid);
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
                    child: Container(child: UserWrittenCommentListWidget())))));
  }
}

class UserWrittenCommentListWidget extends ConsumerWidget implements Comment {
  @override
  Widget build(BuildContext context, watch) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final commentprovider = watch(writtenCommentProvider);
    bool isFetch = commentprovider.isFetching;

    bool isEmpty = commentprovider.comments.length == 0 ? true : false;
    if (!isEmpty)
      return Column(
        children: [
          Container(
              child: animationLimiterListView(
                  commentprovider.comments, deviceWidth, deviceHeight)),
          isFetch ? Center(child: CupertinoActivityIndicator()) : Container()
        ],
      );
    else
      return Container(
          child:
              !isFetch ? Center(child: commentListEmptyWidget()) : Container());
  }

  @override
  commentListSwipeMenu(comment, BuildContext context, currentLogInUid,
      {Widget child, Key slidableKey}) {
    return GestureDetector(
        onTap: () async {
          PostData clickedPostData = await FirebaseFirestore.instance
              .collection('university')
              .doc(currentUserModel.university)
              .collection("board")
              .doc(comment.boardId)
              .collection(comment.boardId)
              .doc(comment.postId)
              .get()
              .then((DocumentSnapshot documentSnapshot) =>
                  PostData.fromFireStore(documentSnapshot));
          Navigator.of(context).pushNamed("/PostContent",
              arguments: {"CURRENTBOARDDATA": clickedPostData}).then((value) {
            // context
            //     .read(writtenCommentProvider)
            //     .fetchUserWrittenComment(currentUserModel.uid);
          });
        },
        child: child);
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
                        Navigator.of(context).pushNamed("/PostContent",
                            arguments: {
                              "CURRENTBOARDDATA": clickedPostData
                            }).then((value) {});
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
                        padding: EdgeInsets.symmetric(vertical: 15),
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
  commentListEmptyWidget() {
    return Column(
      children: [
        ShowUp(
          delay: 300,
          child: Text("작성된 댓글이 없습니다."),
        ),
        // ShowUp(
        //     delay: 350,
        //     child: ElevatedButton.icon(
        //         style: ElevatedButton.styleFrom(
        //             elevation: 0, primary: OnestepColors().secondColor),
        //         onPressed: () => openSlidingPanelCallback(),
        //         // onPressed: () {
        //         // context.read(commentProvider).refresh(boardId, postId);
        //         // },
        //         icon: Icon(Icons.add_comment_rounded),
        //         label: Text("작성하기"))),
      ],
    );
  }

  @override
  commentName(commentUID, postWriterUid, commentList) {
    return "나";
  }

  @override
  commentWidget(
      int index, CommentData comment, double deviceWidth, double deviceHeight) {
    DateTime uploadTime = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(comment.uploadTime ?? 0) ?? 0);

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child:
                    // child: commentName(comment.uid, postWriterUID, commentList),

                    Text(commentName(comment.uid, null, null),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: OnestepColors().mainColor))),
            Container(
              padding: EdgeInsets.only(
                left: 8,
                top: 10,
              ),
              alignment: Alignment.centerLeft,
              child: Text(comment.textContent ?? "NO"),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
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
    // TODO: implement deletedCommentWidget
    return Container();
  }

  // @override
  // Widget commentBoxDesignMethod(
  //     int index, CommentData comment, double deviceWidth, double deviceHeight) {
  //   return commentWidget(index, comment, deviceWidth, deviceHeight);
  // }
}
