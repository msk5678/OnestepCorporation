import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/boardMain.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/utils/floatingSnackBar.dart';
import 'package:onestep_rezero/utils/timeUtil.dart';

class UserWrittenCommentList extends StatefulWidget {
  final dashBoardIconData;
  UserWrittenCommentList({Key key, this.dashBoardIconData}) : super(key: key);

  @override
  _UserWrittenCommentListState createState() => _UserWrittenCommentListState();
}

class _UserWrittenCommentListState extends State<UserWrittenCommentList> {
  final currentUid = currentUserModel.uid;
  double deviceWidth;
  BoardInitData dashBoardIcon;
  @override
  void initState() {
    context.read(userBoardDataProvider).getUserCommentList(currentUid);
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
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text(
                dashBoardIcon.explain,
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 5.h, bottom: 15.h, left: 15.w, right: 15.w),
                    child: Container(
                        child: UserWrittenCommentListWidget(
                      snackBarCallback: showSnackBar,
                    ))))));
  }

  showSnackBar(String textMessage,
      {SnackBarAction snackBarAction, Duration duration}) {
    FloatingSnackBar.show(context, textMessage,
        duration: duration ?? Duration(milliseconds: 500));
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: textMessage,
    //   duration: duration ?? Duration(milliseconds: 500),
    //   action: snackBarAction ?? null,
    // ));
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
    List<CommentData> commentList = userProvider.userCommentList ?? [];

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
          bool isFirstComment = index == 0;
          CommentData currentIndexCommentData = comment[index];
          PostData currentPostData;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('university')
                .doc(currentUserModel.university)
                .collection("board")
                .doc(currentIndexCommentData.boardId)
                .collection(currentIndexCommentData.boardId)
                .doc(currentIndexCommentData.postId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Container();
              }
              //error가 발생하게 될 경우 반환하게 되는 부분
              else if (snapshot.hasError) {
                return Container(
                  child: Text(
                    '댓글에 대한 게시글을 가져오지 못했습니다.: ${snapshot.error}',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                );
              }
              // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
              else {
                currentPostData = PostData.fromFireStore(snapshot.data);
                bool wasCommentDeleted = currentIndexCommentData.deleted;

                currentIndexCommentData
                  ..userName = commentNickName(currentIndexCommentData.uid);

                return !wasCommentDeleted
                    ? AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 0),
                        child: SlideAnimation(
                          verticalOffset: 50.0.h,
                          child: FadeInAnimation(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    bool isDeletedPost =
                                        currentPostData.deleted ||
                                            currentPostData.reported;
                                    if (!isDeletedPost) {
                                      Navigator.of(context).pushNamed(
                                          "/PostContent",
                                          arguments: {
                                            "CURRENTBOARDDATA": currentPostData
                                          }).then((value) {});
                                    } else {
                                      snackBarCallback("이미 삭제된 게시글입니다.");
                                    }
                                  },
                                  child: Container(
                                      decoration: !isFirstComment
                                          ? BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color:
                                                      OnestepColors().mainColor,
                                                  width: 0.5.w,
                                                ),
                                              ),
                                            )
                                          : BoxDecoration(),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: commentListSwipeMenu(
                                        currentIndexCommentData,
                                        context,
                                        currentUserModel.uid,
                                        slidableKey: Key(
                                            currentIndexCommentData.commentId),
                                        child: commentBoxDesignMethod(
                                            context,
                                            index,
                                            currentIndexCommentData,
                                            deviceWidth,
                                            deviceHeight,
                                            postData: currentPostData),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container();
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget commentBoxDesignMethod(BuildContext context, int index,
      CommentData comment, double deviceWidth, double deviceHeight,
      {PostData postData}) {
    return commentWidget(context, index, comment, currentUserModel.uid,
        deviceWidth, deviceHeight,
        postData: postData);
  }

  @override
  commentListEmptyWidget({double deviceHeight, double deviceWidth}) {
    return Container(
      height: deviceHeight / 2.h,
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
  commentWidget(BuildContext context, int index, CommentData comment,
      String uid, double deviceWidth, double deviceHeight,
      {PostData postData}) {
    DateTime uploadTime =
        DateTime.fromMillisecondsSinceEpoch(comment.uploadTime);

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                    commentNickName(
                      "null",
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: OnestepColors().mainColor))),
            Container(
              padding: EdgeInsets.only(
                left: 8.w,
                top: 10.h,
              ),
              alignment: Alignment.centerLeft,
              child: Text(comment.textContent ?? "NO"),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: deviceWidth / 2,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "글 : ${postData.title ?? ""}",
                      style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${TimeUtil.timeAgo(date: uploadTime)}",
                      style: TextStyle(color: Colors.grey, fontSize: 10.sp),
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

  @override
  commentNickName(String uid) {
    return "나";
  }
}
