import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/commentTextField.dart';

import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:onestep_rezero/board/StateManage/Provider/postProvider.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/favoriteCommentWidget.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/report/pages/Deal/boardReport/reportBoardPage.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/utils/timeUtil.dart';

final postProvider =
    ChangeNotifierProvider<PostProvider>((ref) => PostProvider());

class PostContentRiverPod extends ConsumerWidget {
  final PostData currentPostData;
  final Widget postStatusbar;
  final Widget favoriteButton;
  PostContentRiverPod(
      {this.currentPostData, this.postStatusbar, this.favoriteButton});
  @override
  Widget build(BuildContext context, watch) {
    final postRiverPod = watch(postProvider);
    final currentUid = currentUserModel.uid;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    PostData riverpodPostData = postRiverPod.latestPostData;
    PostData currentPost;
    if (riverpodPostData.uid != "" &&
        riverpodPostData.documentId == currentPostData.documentId) {
      currentPost = riverpodPostData;
    } else {
      currentPost = currentPostData;
    }

    if (!postRiverPod.isFetching)
      return Column(
          children: <Widget>[
        postTopStatusBar(currentPost, currentUid, postStatusbar),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            currentPost.textContent ?? "",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: deviceHeight / 50,
        )
      ]..addAll(imageCommentContainer(
              context,
              Map<String, List<dynamic>>.from(currentPost.imageCommentMap),
              deviceWidth * 0.9,
              deviceHeight)));
    else
      return Container(
        height: deviceHeight / 2,
        width: deviceWidth,
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
  }

  List<Widget> imageCommentContainer(BuildContext context,
      Map<String, List<dynamic>> imageCommentMap, double width, double height) {
    List imageList = imageCommentMap["IMAGE"] ?? [];
    List commentList = imageCommentMap["COMMENT"] ?? [];
    return List<Widget>.generate(imageList.length, (index) {
      if (imageList[index].runtimeType == String) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/ImagesFullViewer",
                    arguments: {"IMAGESURL": imageList, "INDEX": index});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: CachedNetworkImage(
                  imageUrl: imageList[index].toString(),
                  width: width,
                  height: height,
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error), // 로딩 오류 시 이미지

                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              alignment: Alignment.centerLeft,
              child: Text(commentList[index], style: TextStyle(fontSize: 16)),
            )
          ],
        );
      } else {
        return Container();
      }
    });
  }

  postTopStatusBar(PostData currentPost, String uid, Widget status) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("익명"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Icon(
                  //   Icons.watch_later_outlined,
                  //   size: 20,
                  //   color: OnestepColors().mainColor,
                  // ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Text(
                      "${PostTime(dateTime: currentPost.uploadTime).dateToString()}",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ],
              ),
              favoriteButton
              // Row(
              //   children: [
              //     Icon(
              //       //foot icon
              //       Icons.remove_red_eye,
              //       size: 20,
              //       color: OnestepColors().mainColor,
              //     ),
              //     Container(
              //       margin: EdgeInsets.only(right: 5),
              //       child: Text("${currentPost.views.keys.length}",
              //           style: TextStyle(color: Colors.grey, fontSize: 10)),
              //     ),
              //     status
              //   ],
              // )
            ],
          ),
        ],
      ),
    );
  }
}

class PostContent extends StatefulWidget {
  final PostData postData;

  PostContent({Key key, this.postData});

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent>
    with TickerProviderStateMixin {
  final String currentUid = currentUserModel.uid;
  double deviceHeight;
  double deviceWidth;

  TextEditingController textEditingControllerComment = TextEditingController();
  ScrollController postScrollController = ScrollController();
  PostData currentPostData;

  //Distint about upload comment or coComment
  bool commentFlag = false;

  CommentData aboutCoComment;

  @override
  void initState() {
    currentPostData = widget.postData;

    updateViewers(currentUserModel.uid);
    context
        .read(commentProvider)
        .fetchData(currentPostData.boardId, currentPostData.documentId);

    super.initState();
  }

  updateViewers(String uid) {
    if (!currentPostData.views.containsKey(uid)) {
      FirebaseFirestore.instance
          .collection('university')
          .doc(currentUserModel.university)
          .collection('board')
          .doc(currentPostData.boardId)
          .collection(currentPostData.boardId)
          .doc(currentPostData.documentId)
          .update({"views." + uid: true});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  setPostData(PostData postData) {
    currentPostData = postData;
  }

  @override
  Widget build(BuildContext context) {
    currentPostData = widget.postData;
    return WillPopScope(
      onWillPop: () async {
        // if (panelController.isPanelOpen) {
        //   panelController.close();
        // } else
        if (textEditingControllerComment.text != "") {
          if (await navigatorPopAlertDialog()) Navigator.of(context).pop(false);
        } else {
          Navigator.of(context).pop(false);
        }

        return Future(() => false);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          children: [
            Scaffold(
              appBar: appBar(currentPostData, currentUid),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: SingleChildScrollView(
                      controller: postScrollController,
                      child: Container(
                        width: deviceWidth,
                        child: Column(
                          children: <Widget>[
                            PostContentRiverPod(
                                currentPostData: currentPostData,
                                favoriteButton:
                                    favoriteButton(currentPostData)),
                            bottomStatusBar(currentPostData),
                            // favoriteCountWidget(currentPostData, currentUid),

                            // child: postTopStatusBar(
                            //       currentPostData,
                            //       currentUid,
                            //       commentStatusWidget(currentPostData)),
                            Container(
                              width: deviceWidth / 2,
                              margin: EdgeInsets.only(
                                  bottom: deviceHeight / 50, top: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: OnestepColors().thirdColor,
                                          width: 2.0))),
                            ),
                          ]
                            ..add(CommentWidget(
                              boardId: currentPostData.boardId,
                              postId: currentPostData.documentId,
                              commentMap: currentPostData.commentUserList,
                              postWriterUID: currentPostData.uid,
                              // openSlidingPanelCallback: slidingUpDownMethod,
                              coCommentCallback: coCommentCallback,
                              showDialogCallback: showingDismissCommentCallback,
                            ))
                            ..add(SizedBox(
                              height: deviceHeight / 5,
                            )),
                        ),
                      ),
                    ),
                  ),

                  // commentSlidingPanel(currentUid, currentPostData.uid,
                  //     currentPostData.commentUserList),

                  commentTextFieldStack(
                      commentFlag, deviceWidth, currentPostData.uid,
                      commentData: aboutCoComment),
                ],
              ),
            ),
            TipDialogContainer(duration: const Duration(seconds: 1))
          ],
        ),
      ),
    );
  }

  postTopStatusBar(PostData currentPost, String uid, Widget status) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row(
          //   children: [
          //     Icon(
          //       //foot icon
          //       Icons.remove_red_eye,
          //       size: 20,
          //       color: OnestepColors().mainColor,
          //     ),
          //     Container(
          //       margin: EdgeInsets.only(right: 5),
          //       child: Text("${currentPost.views.keys.length}",
          //           style: TextStyle(color: Colors.grey, fontSize: 10)),
          //     ),
          //     status
          //   ],
          // ),
          Row(
            children: [
              Icon(
                Icons.watch_later_outlined,
                size: 20,
                color: OnestepColors().mainColor,
              ),
              Container(
                margin: EdgeInsets.only(right: 5),
                child: Text(
                  "${TimeUtil.timeAgo(date: currentPost.uploadTime)}",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  commentTextFieldStack(
      bool commentFlag, double deviceWidth, String postDataUid,
      {CommentData commentData}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        constraints: BoxConstraints(
            minHeight: 70, minWidth: double.infinity, maxHeight: 400),
        margin: EdgeInsets.only(bottom: 50),
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        color: Colors.white,
        child: IntrinsicHeight(
          child: Column(
            children: [
              commentFlag ? whereSaveComment(commentData) : Container(),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                      child: CustomCommentTextField(
                          iconOnPressCallback: saveCommentCallbackFunction,
                          hintText: commentName(currentUid, postDataUid, []))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  favoriteClickCallback(bool isClicked) {
    setState(() {
      if (!isClicked)
        ++currentPostData.favoriteCount;
      else
        --currentPostData.favoriteCount;
    });
  }

  commentWrittemCallback() {
    setState(() {
      ++currentPostData.commentCount;
    });
  }

  commentStatusWidget(
    PostData currentPost,
  ) {
    int commentCount = currentPost.commentCount;
    return Container(
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                //foot icon
                Icons.comment,
                size: 18,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.only(right: 5),
                child: Text("$commentCount",
                    style: TextStyle(color: Colors.grey, fontSize: 10)),
              ),
            ],
          )
        ],
      ),
    );
  }

  favoriteButton(PostData currentPost) {
    return FavoriteButton(
      currentPost: currentPostData,
      clickCallback: favoriteClickCallback,
    );
  }

  favoriteCountWidget(PostData currentPost, String uid) {
    int favoriteCount = currentPost.favoriteCount;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(right: 5),
          child: Text(
            "좋아요 : $favoriteCount",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        postTopStatusBar(currentPost, uid, commentStatusWidget(currentPost))
      ],
    );
  }

  bottomStatusBar(PostData currentPost) {
    int favoriteCount = currentPost.favoriteCount;
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Icon(
            //foot icon
            Icons.favorite,
            size: 20,
            color: OnestepColors().mainColor,
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text("$favoriteCount",
                style: TextStyle(color: Colors.grey, fontSize: 10)),
          ),
          commentStatusWidget(currentPostData)
        ],
      ),
    );
    // return Container();
    // return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    //   FavoriteButton(
    //     currentPost: currentPostData,
    //     clickCallback: favoriteClickCallback,
    //   ),
    //   Container(
    //     margin: EdgeInsets.only(top: 10, left: 10),
    //     alignment: Alignment.centerLeft,
    //     child: IconButton(
    //       icon: Icon(
    //         Icons.send_rounded,
    //         color: OnestepColors().mainColor,
    //       ),
    //       onPressed: () {},
    //     ),
    //   )
    // ]);
  }

  updatePostDataCallback(PostData latestData) {
    currentPostData = latestData;
  }

  Widget likeScrabButton(double deviceWidth, double deviceHeight,
      PostData currentPost, String uid) {
    return Container(
      width: deviceWidth,
      height: deviceHeight / 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            // onTap: () async => await currentPost.updateFavorite(uid),
            child: Container(
              width: deviceWidth / 2.5,
              color: Colors.grey,
              child: Center(
                  child: IconButton(
                      icon: Icon(Icons.favorite_border), onPressed: () {})),
            ),
          ),
          Container(
            width: deviceWidth / 2.5,
            color: Colors.white70,
            child: Center(
                child: IconButton(
                    icon: Icon(Icons.bookmark_border), onPressed: () {})),
          )
        ],
      ),
    );
  }

  navigatorPopAlertDialog() async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
              title: Text('댓글 중'),
              content: Text("작성중인 내용은 저장이 되지 않습니다."),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, primary: OnestepColors().secondColor),
                    child: Text('나가기'),
                    onPressed: () => Navigator.of(context).pop(true)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, primary: OnestepColors().secondColor),
                    child: Text('유지'),
                    onPressed: () => Navigator.of(context).pop(false)),
              ],
            ));
  }

  PreferredSizeWidget appBar(PostData currentPost, String uid) {
    bool isWritter = currentPost.uid == uid;
    return AppBar(
      iconTheme: IconThemeData(color: OnestepColors().mainColor),
      title: GestureDetector(
        onTap: () {
          postScrollController.position
              .moveTo(0.5, duration: Duration(milliseconds: 200));
        },
        child: Container(
          width: double.infinity,
          child: Text(
            currentPost.title ?? "",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      brightness: Brightness.light, // this makes status bar text color black
      actions: <Widget>[
        PopupMenuButton(
            icon: Icon(Icons.settings, color: OnestepColors().mainColor),
            offset: Offset(0, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (route) async {
              if (route == "Delete") {
                TipDialogHelper.loading("삭제중입니다.");
                bool result = await currentPost.dismissPostData() ?? false;
                if (result) {
                  TipDialogHelper.dismiss();
                  TipDialogHelper.success("삭제 완료!");
                  Future.delayed(Duration(seconds: 1))
                      .then((value) => Navigator.popUntil(
                          context, ModalRoute.withName('/PostList')))
                      .whenComplete(() {});
                } else {
                  TipDialogHelper.fail("Error \n Dismiss Error!");
                  Future.delayed(Duration(seconds: 1))
                      .then((value) => null)
                      .whenComplete(() {});
                }
              } else if (route == "Alter") {
                context.read(postProvider).getLatestPostData(currentPostData);
                await Navigator.of(context).pushNamed('/AlterPost',
                    arguments: {"POSTDATA": currentPostData}).then((value) {
                  bool result = value ?? false;

                  if (result) {
                    context
                        .read(postProvider)
                        .getLatestPostData(currentPostData);
                  }
                });
              }
            },
            itemBuilder: (BuildContext bc) =>
                setPopupMenuButton(isWritter, currentPost, currentUid))
      ],
    );
  }

  setPopupMenuButton(bool isWritter, PostData currentPost, String currentUID) {
    String currentBoardId = currentPost.boardId;
    String currentPostId = currentPost.documentId;
    String currentUid = currentUID;
    return isWritter
        ? [
            PopupMenuItem(child: Text("수정하기"), value: "Alter"),
            PopupMenuItem(
                child: Text(
                  "삭제",
                  style: TextStyle(color: Colors.redAccent),
                ),
                value: "Delete")
          ]
        : [
            PopupMenuItem(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReportBoardPage(
                          currentBoardId, currentPostId, currentUid))),
                  child: Text(
                    "신고하기",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                value: "Report"),
            PopupMenuItem(
                child: GestureDetector(
                  child: Text(
                    "공유하기",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                value: "Share")
          ];
  }

  saveCommentCallbackFunction(String commentText) async {
    if (commentFlag)
      await saveComment(commentText, currentPostData,
          commentData: aboutCoComment);
    else
      await saveComment(commentText, currentPostData);
  }

  saveComment(String comment, PostData postData,
      {CommentData commentData}) async {
    if (comment != "") if (!commentFlag) {
      textEditingControllerComment.clear();
      loadingDialogTipDialog(
          CommentData.toRealtimeDataWithPostData(postData).toRealtimeDatabase(
              comment.trimRight(), currentUid), thenFunction: (value) {
        // _panelOpen(false);
        context
            .read(commentProvider)
            .refresh(currentPostData.boardId, currentPostData.documentId);
        commentWrittemCallback();
      }, errorFunction: () {
        Navigator.pop(context, true);
      }, unFocusing: true);
    } else {
      if (!commentData.isUnderComment) {
        textEditingControllerComment.clear();
        loadingDialogTipDialog(commentData.addchildComment(comment, currentUid),
            thenFunction: (value) {
          // _panelOpen(false);
          context
              .read(commentProvider)
              .refresh(currentPostData.boardId, currentPostData.documentId);
          switchingFlag();
          aboutCoComment = null;
          commentWrittemCallback();
        }, errorFunction: () {
          Navigator.pop(context, true);
        }, unFocusing: true);
      } else {
        textEditingControllerComment.clear();
        loadingDialogTipDialog(
            CommentData.toRealtimeDataWithPostData(postData)
                .addChildchildComment(comment, commentData, currentUid),
            thenFunction: (value) {
          // _panelOpen(false);
          context
              .read(commentProvider)
              .refresh(currentPostData.boardId, currentPostData.documentId);
          switchingFlag();
          commentWrittemCallback();
          aboutCoComment = null;
        }, errorFunction: () {
          Navigator.pop(context, true);
        }, unFocusing: true);
      }
    }
  }

  Widget whereSaveComment(CommentData commentData) {
    return Row(
      children: [
        commentFlag
            ? IconButton(
                icon: Icon(
                  Icons.cancel_presentation,
                  color: OnestepColors().secondColor,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    commentFlag = false;
                    aboutCoComment = null;
                  });
                })
            : Container(),
        commentFlag ? Text("${commentData.userName}에 댓글달기") : Container(),
      ],
    );
  }

  commentName(commentUID, postWriterUid, commentList) {
    // Map<String, dynamic> commentUserMap = commentList ?? {};
    // List commentUserList = commentUserMap.keys.toList();
    if (commentUID.toString() == postWriterUid) {
      return "'" '작성자' "'로 댓글이 작성됩니다." "";
    } else {
      //   for (int i = 0; i < commentUserList.length; i++) {
      //     if (commentUserList[i].toString() == commentUID) {
      //       return Text(" '" '익명 ${i + 1}' "'로 댓글이 작성됩니다." "",
      //           style:
      //               TextStyle(color: OnestepColors().secondColor, fontSize: 13));
      //     }
      //   }
      // return Text(" '" '익명 ${commentUserList.length + 1}' "' 로 댓글이 작성됩니다.",
      //     style: TextStyle(color: OnestepColors().secondColor, fontSize: 13));
      // }
      return " '" '익명' "' 로 댓글이 작성됩니다.";
    }
  }

  coCommentCallback(CommentData commentData) async {
    switchingFlag(to: true);
    setState(() {
      aboutCoComment = commentData;
    });
  }

  void switchingFlag({bool to}) {
    to = to ?? false;
    if (to) {
      commentFlag = to;
    } else
      commentFlag = !commentFlag;
  }

  loadingDialogTipDialog(Future futureFunction,
      {bool unFocusing, Function thenFunction, Function errorFunction}) async {
    TipDialogHelper.loading("저장 중입니다.\n 잠시만 기다려주세요.");
    unFocusing = unFocusing ?? false;
    if (unFocusing) FocusScope.of(context).unfocus();
    bool result = await futureFunction ?? false;
    if (result) {
      TipDialogHelper.dismiss();
      TipDialogHelper.success("저장 완료!");
      Future.delayed(Duration(milliseconds: 500))
          .then((value) => thenFunction(value));
    } else {
      TipDialogHelper.dismiss();
      TipDialogHelper.fail("저장 실패\n Error : CANNOT UPLOAD COMMENT");
      Future.delayed(Duration(seconds: 1)).then((value) => errorFunction);
    }
  }

  showingDismissCommentCallback(CommentData comment) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("${comment.userName}"),
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text("${comment.textContent}"))
          ],
        );
      },
    );
  }
}

class PostTime {
  final int timeStamp;
  final DateTime dateTime;
  PostTime({this.timeStamp, this.dateTime});

  String dateToString() {
    DateTime now = new DateTime.now();
    if (now.year == dateTime.year)
      return DateFormat('MM-dd HH:mm').format(dateTime);
    else
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  String timeStapToString() {
    final f = new DateFormat('yyyy-MM-dd HH:mm');
    return f.format(new DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000));
  }
}
