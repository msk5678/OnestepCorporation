import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:like_button/like_button.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postCoComment.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postComment.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postCommentSidingPanel.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/board/declareData/commentData.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';
import 'dart:io' show Platform;

import 'package:sliding_up_panel/sliding_up_panel.dart';

class PostContent extends StatefulWidget {
  final PostData postData;
  PostContent({Key key, this.postData});

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  final String currentUid = currentUserModel.uid;
  double deviceHeight;
  double deviceWidth;
  PanelController panelController = PanelController();
  TextEditingController textEditingControllerComment = TextEditingController();
  PostData currentPostData;

  bool flag = false; //Distint about upload comment or coComment
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
      final db = FirebaseFirestore.instance;
      Map<String, dynamic> updatedViews = currentPostData.views
        ..addAll({uid: true});
      db
          .collection('university')
          .doc(currentUserModel.university)
          .collection('board')
          .doc(currentPostData.boardId)
          .collection(currentPostData.boardId)
          .doc(currentPostData.documentId)
          .update({"views": updatedViews});
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: appBar(),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: SingleChildScrollView(
                child: Container(
                  width: deviceWidth,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          currentPostData.textContent,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight / 50,
                      )
                    ]
                      ..addAll(imageCommentContainer(
                          deviceWidth * 0.9, deviceHeight))
                      ..add(Container(
                        width: deviceWidth / 2,
                        margin:
                            EdgeInsets.symmetric(vertical: deviceHeight / 50),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: OnestepColors().thirdColor,
                                    width: 2.0))),
                      ))
                      ..add(CommentWidget(
                        boardId: currentPostData.boardId,
                        postId: currentPostData.documentId,
                        commentList: currentPostData.commentUserList,
                        postWriterUID: currentPostData.uid,
                        openSlidingPanelCallback: slidingUpDownMethod,
                        coCommentCallback: coCommentCallback,
                      ))
                      ..add(SizedBox(
                        height: deviceHeight / 10,
                      )),
                  ),
                ),
              ),
            ),
            commentSlidingPanel(currentUid, currentPostData.uid,
                currentPostData.commentUserList),
            TipDialogContainer(duration: const Duration(seconds: 2))
          ],
        ),
      ),
    );
  }

  Widget commentSlidingPanel(String wirtterName, String currentPostUid,
      Map<String, dynamic> commentList,
      {String commName, String commentContext}) {
    return SlidingUpPanel(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      minHeight: deviceWidth / 10,
      maxHeight: deviceHeight / 3.5,
      controller: panelController,
      panel: Column(
        children: [
          //Sliding Button
          Center(
              child: Container(
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  height: deviceHeight / 130,
                  width: deviceWidth / 10,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(5))))),
          Container(
            child: Text("SHOW WHERE COMMENT"),
          ),

          Center(
            child: Container(
              margin: EdgeInsets.all(5),
              height: deviceHeight / 8,
              child: TextField(
                controller: textEditingControllerComment,
                // onChanged: (value) => saveCommentCallback(value),
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '댓글을 입력하세요.',
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (flag) {
                      await saveCoComment(
                          textEditingControllerComment.text, aboutCoComment);
                    } else
                      await saveComment(
                          textEditingControllerComment.text, currentPostData);
                  },
                  label: Text(
                    "저장",
                  ),
                  icon: Icon(
                    Icons.comment,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: OnestepColors().secondColor),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(left: 5),
                child: Text("'"
                    '${commentName(wirtterName, currentPostUid, commentList)}'
                    "'로 댓글이 작성됩니다."),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(
        currentPostData.title,
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      brightness: Brightness.light, // this makes status bar text color black
      actions: <Widget>[],
    );
  }

  List<Widget> imageCommentContainer(double width, double height) {
    List imageList = currentPostData.imageCommentMap["IMAGE"] ?? [];
    List commentList = currentPostData.imageCommentMap["COMMENT"] ?? [];
    return List<Widget>.generate(imageList.length, (index) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {},
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
    });
  }

  void slidingUpDownMethod() {
    if (panelController != null) if (panelController
        .isAttached) if (panelController.isPanelOpen)
      panelController.close();
    else
      panelController.open();
  }

  saveComment(String comment, PostData postData) async {
    if (comment != "") {
      loadingDialogTipDialog(
          CommentData.toRealtimeDataWithPostData(postData).toRealtimeDatabase(
              textContent: comment.trimRight(),
              commentList: postData.commentUserList), thenFunction: (value) {
        panelController.close();
        textEditingControllerComment.clear();
        context
            .read(commentProvider)
            .refresh(currentPostData.boardId, currentPostData.documentId);
      }, errorFunction: () {
        Navigator.pop(context, true);
      }, unFocusing: true);
    }
  }

  commentName(String uid, String thisPostUID, commentList) {
    Map<String, dynamic> commentUserMap = commentList ?? {};
    List commentUserList = commentUserMap.keys.toList();
    if (uid == thisPostUID) {
      return "작성자";
    } else {
      for (int i = 0; i < commentUserList.length; i++) {
        if (commentUserList[i].toString() == uid) {
          return "익명 ${i + 1}";
        } else {
          return "ERROR";
        }
      }
    }
  }

  coCommentCallback(CommentData commentData) async {
    aboutCoComment = commentData;
    panelController.open();
    switchingFlag();
    // saveCoComment(textEditingControllerComment.text, commentData);
  }

  void switchingFlag() {
    flag = !flag;
  }

  saveCoComment(String comment, CommentData commentData) async {
    if (comment != "") {
      loadingDialogTipDialog(commentData.addCoComment(comment),
          thenFunction: (value) {
        panelController.close();
        textEditingControllerComment.clear();
        context
            .read(commentProvider)
            .refresh(currentPostData.boardId, currentPostData.documentId);
        switchingFlag();
        aboutCoComment = null;
      }, errorFunction: () {
        Navigator.pop(context, true);
      }, unFocusing: true);
    }
  }

  loadingDialogTipDialog(Future futureFunction,
      {bool unFocusing, Function thenFunction, Function errorFunction}) async {
    unFocusing = unFocusing ?? false;
    if (unFocusing) FocusScope.of(context).unfocus();
    bool result = await futureFunction ?? false;
    if (result) {
      TipDialogHelper.dismiss();
      TipDialogHelper.success("저장 완료!");
      Future.delayed(Duration(seconds: 2)).then((value) => thenFunction(value));
    } else {
      TipDialogHelper.dismiss();
      TipDialogHelper.fail("저장 실패\n Error : CANNOT UPLOAD COMMENT");
      Future.delayed(Duration(seconds: 2)).then((value) => errorFunction);
    }
  }
}

// class PostContent extends StatefulWidget {
//   final PostData postData;
//   PostContent({this.postData});

//   @override
//   _Post createState() => new _Post();
// }

// class _Post extends _PostParent<PostContent> {
//   @override
//   setPostData() {
//     postData = widget.postData;
//   }
// }

// abstract class _PostParent<T extends StatefulWidget> extends State<T>
//     with SingleTickerProviderStateMixin
// // with TickerProviderStateMixin
// {
//   final refreshComment = "COMMENT";
//   final refreshImage = "IMAGE";
//   final refreshLikeButton = "LIKEBUTTON";
//   final commentCollectionName = "Comment";
//   final refreshUnderComment = "UNDERCOMMENT";
//   final _scrollController = ScrollController(keepScrollOffset: true);
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   FutureProvider<DataSnapshot> futureProviderComment;
//   var boardContentSnapshot;
//   setPostData();
//   AnimationController _animationController;
//   //Control FutureBuilder Cache Memory
//   AsyncMemoizer _imageMemoizer = AsyncMemoizer();
//   AsyncMemoizer _likeButtonMemoizer = AsyncMemoizer();
//   AsyncMemoizer _commentMemoizer = AsyncMemoizer();
//   Map<String, dynamic> _commentMemoizerMapping;
//   List<CommentData> commentList = [];

//   double device_width;
//   double device_height;

//   PostData postData;
//   var _onFavoriteClicked;
//   Map favorite_data;
//   //If clicked favorite button, activate this animation
//   AnimationController _favoriteAnimationController;
//   TextEditingController _textEditingControllerComment;

//   String currentBoardId;
//   String currentBoardName;
//   String currentPostId;
//   String currentUID;

//   bool isImageRefresh;
//   bool isLikeButtonRefresh;
//   bool isCommentRefresh;
//   bool isUnderCommentRefresh;
//   bool isWritter;

//   ClickedCommentData _clickedCommentData;
//   Map<String, dynamic> _imageMap = {};
//   List<dynamic> _imageList = [];
//   bool isCommentBoxVisible;
//   @override
//   void initState() {
//     super.initState();
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(seconds: 1));
//     _clickedCommentData = new ClickedCommentData(
//         commentDocumentId: null, isCommentClicked: false);
//     _textEditingControllerComment = TextEditingController();
//     setPostData();
//     setInitialPostData();
//     isCommentBoxVisible = false;
//     isImageRefresh =
//         isLikeButtonRefresh = isCommentRefresh = isUnderCommentRefresh = true;
//     _commentMemoizerMapping = {};
//     _onFavoriteClicked = false;
//     isWritter = googleSignIn.currentUser.id == postData.uid;

//     watchCountUpdate();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     device_width = MediaQuery.of(context).size.width;
//     device_height = MediaQuery.of(context).size.height;
//   }

//   setInitialPostData() {
//     currentUID = googleSignIn.currentUser.id;
//     currentBoardId = postData.boardId;
//     currentBoardName = postData.boardName;
//     currentPostId = postData.documentId;
//   }

//   setPopupMenuButton(bool isItself) {
//     return isItself
//         ? [
//             PopupMenuItem(child: Text("수정하기"), value: "Alter"),
//             PopupMenuItem(
//                 child: Text(
//                   "삭제",
//                   style: TextStyle(color: Colors.redAccent),
//                 ),
//                 value: "Delete")
//           ]
//         : [
//             PopupMenuItem(
//                 child: GestureDetector(
//                   child: Text(
//                     "신고하기",
//                     style: TextStyle(color: Colors.redAccent),
//                   ),
//                 ),
//                 value: "Report"),
//             PopupMenuItem(
//                 child: GestureDetector(
//                   child: Text(
//                     "공유하기",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 value: "Share")
//           ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(device_height / 15),
//           child: AppBar(
//             iconTheme: IconThemeData(color: Colors.black),
//             backgroundColor: Colors.white,
//             brightness: Brightness.dark,
//             title: setTitle(postData.title),
//             actions: [
//               PopupMenuButton(
//                   onSelected: (route) async {
//                     if (route == "Delete") {
//                       TipDialogHelper.loading("삭제중입니다.");
//                       await FirebaseFirestore.instance
//                           .collection("Board")
//                           .doc(currentBoardId)
//                           .collection(currentBoardId)
//                           .doc(currentPostId)
//                           .update({
//                         "deleted": true,
//                         "deletedTime":
//                             DateTime.now().millisecondsSinceEpoch.toString()
//                       }).then((value) {
//                         TipDialogHelper.dismiss();
//                         TipDialogHelper.success("삭제 완료!");
//                         Future.delayed(Duration(seconds: 2))
//                             .then((value) => Navigator.popUntil(
//                                 context, ModalRoute.withName('/PostList')))
//                             .whenComplete(() {});
//                       });
//                     } else {}
//                   },
//                   itemBuilder: (BuildContext bc) =>
//                       setPopupMenuButton(isWritter))
//             ],
//           ),
//         ),
//         key: _scaffoldKey,
//         body: SafeArea(
//           child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
//             Container(
//               //Dynamic height Size
//               height: device_height,
//               // alignment: AlignmentA,
//               child: SingleChildScrollView(
//                   controller: _scrollController,
//                   // child: Expanded(
//                   // height: MediaQuery.of(context).size.height,
//                   child:
//                       Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                     // Title Container
//                     // setTitle(boardData.title),
//                     //Date Container
//                     // setDateNVisitor(postData.uploadTime, postData.views),
//                     setBoardContent(),
//                     // imageContent(),

//                     createCommentListMethod(),
//                     ElevatedButton(
//                         onPressed: () {
//                           context
//                               .read(commentProvider)
//                               .refresh(currentBoardId, currentPostId);
//                         },
//                         child: Text("")),
//                     CommentWidget(
//                       boardId: currentBoardId,
//                       postId: currentPostId,
//                     ),

//                     // commentBoxExpanded(isCommentBoxVisible),
//                   ])),
//             ),

//             commentBoxContainer(),
//             TipDialogContainer(
//               duration: const Duration(seconds: 2),
//             ),
//             // )
//           ]),
//         ));
//   }

//   Future<void> watchCountUpdate() async {
//     if (!isWritter) {
//       if (!postData.views.containsKey(currentUID)) {
//         final FirebaseFirestore _db = FirebaseFirestore.instance;
//         String _boardID = postData.boardId.toString();
//         String _documentID = postData.documentId.toString();
//         _db
//             .collection("board")
//             .doc(currentBoardId)
//             .collection(currentBoardId)
//             .doc(currentPostId)
//             .update({
//           "view": postData.views..addAll({currentUID: true})
//         });
//       }
//     }
//   }

//   _setImageContent(DocumentSnapshot snapshot) {
//     boardContentSnapshot = snapshot.data();
//     _imageMap = boardContentSnapshot["imageCommentList"];
//     List<dynamic> _commentList = _imageMap["COMMENT"];
//     List<dynamic> _imageURi = _imageMap["IMAGE"];
//     // _imageURi.forEach((element) {})
//     List<Widget> _imageContainer = [];
//     // _commentList.forEach((element) {
//     //   print(element);
//     // });

//     _imageURi.asMap().forEach((index, element) async {
//       _imageList.add(
//         CachedNetworkImage(
//           imageUrl: element.toString(),
//           placeholder: (context, url) => CupertinoActivityIndicator(),
//           errorWidget: (context, url, error) => Icon(Icons.error),
//         ),
//       );
//       _imageContainer.add(GestureDetector(
//           onTap: () {
//             Navigator.of(context).pushNamed('/CustomFullViewer',
//                 arguments: {"INDEX": index, "IMAGES": _imageURi});
//           },
//           child: Container(
//             margin: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(5)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 5,
//                   blurRadius: 7,
//                   offset: Offset(0, 3), // changes position of shadow
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     margin: EdgeInsets.all(10.0), child: _imageList[index]),
//                 Container(
//                     margin: EdgeInsets.only(left: 10, bottom: 5),
//                     child: Text(
//                       _commentList[index],
//                       style: TextStyle(fontSize: 15),
//                     ))
//               ],
//             ),
//           )));
//     });
//     return Column(
//       children: _imageContainer,
//     );
//   }

//   Widget setTitle(String title) {
//     return GestureDetector(
//       onTap: () {
//         _scrollController.position
//             .moveTo(0.5, duration: Duration(milliseconds: 500));
//       },
//       child: Container(
//         margin: EdgeInsets.only(left: 5),
//         width: device_width,
//         child: Text(
//           title,
//           style: new TextStyle(
//               color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
//           maxLines: 1,
//         ),
//       ),
//     );
//   }

//   Widget setDateNVisitor(DateTime uploadTime, Map<String, dynamic> watch) {
//     String _dateTime =
//         uploadTime.add(Duration(hours: 9)).toString().split('.')[0];
//     return Container(
//       child: Container(
//           margin: EdgeInsets.only(top: 5, right: 5),
//           // alignment: Alignment.centerRight,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end, //Start from Right
//             children: <Widget>[
//               IconTheme(
//                 child: Icon(Icons.access_time, size: 20),
//                 data: new IconThemeData(color: Colors.grey),
//               ),
//               Text(
//                 _dateTime,
//                 style: new TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey),
//               ),
//               Text(
//                 ' | ',
//                 style: new TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey),
//               ),
//               IconTheme(
//                 child: Icon(
//                   Icons.remove_red_eye,
//                   size: 20,
//                 ),
//                 data: new IconThemeData(color: Colors.grey),
//               ),
//               Text(
//                 watch.length.toString(),
//                 style: new TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey),
//               ),
//             ],
//           )),
//     );
//   }

//   Widget setBoardContent() {
//     return Container(
//       margin: EdgeInsets.only(
//         left: 10,
//         right: 10,
//         top: 10,
//       ),
//       padding: EdgeInsets.all(5),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: Offset(0, 3), // changes position of shadow
//           ),
//         ],
//       ),
//       child:
//           Text(postData.textContent.toString(), style: TextStyle(fontSize: 15)),
//     );
//   }

//   // _scrollPosition(bool isLiked) async {
//   //   _scrollController.attach(_scrollController.position);

//   //   // return !isLiked;
//   // }

//   Widget setScrapAndFavoriteButton(DocumentSnapshot snapshot) {
//     favorite_data = snapshot.data();
//     // AnimationController _favoriteAnimationController =
//     //     AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     return favorite_data.runtimeType != null
//         ? Container(
//             margin: EdgeInsets.only(bottom: 10, top: 5),
//             // padding: EdgeInsets.only(top: 5),
//             decoration: BoxDecoration(
//                 border:
//                     Border(top: BorderSide(width: 0.5, color: Colors.grey))),
//             height: 30,
//             // padding: EdgeInsets.only(left: 7.0),
//             child: Stack(
//               children: <Widget>[
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.start,
//                 //   children: <Widget>[
//                 //     //Set Favorite Button
//                 Positioned(
//                   left: device_width / 40,
//                   child: LikeButton(
//                     isLiked: favorite_data["favoriteUserList"]
//                             .containsKey(currentUID) ||
//                         isWritter,
//                     onTap: _clickedFavoriteButton,
//                     size: 30,
//                     circleColor:
//                         CircleColor(start: Colors.grey, end: Colors.red),
//                     bubblesColor: BubblesColor(
//                       dotPrimaryColor: Colors.red,
//                       dotSecondaryColor: Colors.orange,
//                     ),
//                     likeBuilder: (bool isLiked) {
//                       return Icon(
//                         Icons.favorite,
//                         color: isWritter
//                             ? Colors.green[100]
//                             : favorite_data["favoriteUserList"]
//                                     .containsKey(currentUID)
//                                 ? Colors.red
//                                 : Colors.grey,
//                         size: 30,
//                       );
//                     },
//                     likeCount: favorite_data["favoriteUserList"].length,
//                     countBuilder: (int count, bool isLiked, String text) {
//                       var color = isLiked ? Colors.red[900] : Colors.grey;
//                       Widget result;
//                       if (count == 0) {
//                         result = Text(
//                           "Love",
//                           style: TextStyle(color: color),
//                         );
//                       } else
//                         result = Text(
//                           text,
//                           style: TextStyle(color: color),
//                         );
//                       return result;
//                     },
//                   ),
//                 ),

//                 //CommentButton
//                 Positioned(
//                   left: device_width * (2 / 5),
//                   child: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         isCommentBoxVisible = !isCommentBoxVisible;
//                         if (!isCommentBoxVisible)
//                           _clickedCommentData.isCommentClicked = false;
//                       });
//                       _scrollController.position.moveTo(double.infinity,
//                           duration: Duration(milliseconds: 500));
//                     },
//                     padding: EdgeInsets.only(bottom: 0),
//                     alignment: Alignment.topCenter,
//                     icon: Icon(
//                       Icons.add_comment_rounded,
//                       color: Colors.yellow,
//                       size: 33,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   left: device_width * (3 / 5),
//                   child: IconButton(
//                       padding: EdgeInsets.only(bottom: 0),
//                       alignment: Alignment.topCenter,
//                       icon: Icon(
//                         Icons.near_me_outlined,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         // NotificationManager.navigateToBoardChattingRoom(
//                         //   context,
//                         //   UserUID.getId(),
//                         //   boardData.uid,
//                         //   boardData.boardId, //게시판id
//                         //   boardData.documentId, //게시글id
//                         // );
//                       }),
//                 ),
//                 //Set Scrap Button
//                 Positioned(
//                   left: device_width * (13 / 17),
//                   child: LikeButton(
//                     isLiked: favorite_data["scrabUserList"]
//                             .containsKey(currentUID) ||
//                         isWritter,
//                     onTap: _clickedScrabButton,
//                     size: 30,
//                     circleColor:
//                         CircleColor(start: Colors.grey, end: Colors.yellow),
//                     bubblesColor: BubblesColor(
//                       dotPrimaryColor: Colors.yellow,
//                       dotSecondaryColor: Colors.yellow,
//                     ),
//                     likeBuilder: (bool isLiked) {
//                       return Icon(
//                         Icons.bookmark,
//                         color: isWritter
//                             ? Colors.green[100]
//                             : isLiked
//                                 ? Colors.yellow
//                                 : Colors.grey,
//                         size: 30,
//                       );
//                     },
//                     likeCount: favorite_data["scrabUserList"].length,
//                     countBuilder: (int count, bool isLiked, String text) {
//                       var color = isWritter
//                           ? Colors.green[900]
//                           : isLiked
//                               ? Colors.yellow[900]
//                               : Colors.grey;
//                       Widget result;
//                       if (count == 0) {
//                         result = Text(
//                           "저장",
//                           style: TextStyle(color: color),
//                         );
//                       } else
//                         result = Text(
//                           text,
//                           style: TextStyle(color: color),
//                         );
//                       return result;
//                     },
//                   ),
//                 ),
//               ],
//             )
//             // ]
//             // )

//             )
//         : CupertinoActivityIndicator();
//   }

//   Future<bool> _clickedScrabButton(bool isLike) async {
//     if (!isWritter) {
//       final FirebaseFirestore _db = FirebaseFirestore.instance;
//       Map<String, dynamic> scrabList = favorite_data["scrabUserList"];
//       if (!isLike) {
//         // print("Like");
//         _db
//             .collection("Board")
//             .doc(currentBoardId)
//             .collection(currentBoardId)
//             .doc(currentPostId)
//             .update({
//           "favoriteUserList": scrabList..addAll({currentUID: true})
//         });
//       } else {
//         _db
//             .collection("Board")
//             .doc(currentBoardId)
//             .collection(currentBoardId)
//             .doc(currentPostId)
//             .update({"favoriteUserList": scrabList..remove(currentUID)});
//       }
//       return !isLike;
//     }
//     return null;
//   }

//   Future<bool> _clickedFavoriteButton(bool isLike) async {
//     if (!isWritter) {
//       final FirebaseFirestore _db = FirebaseFirestore.instance;
//       Map<String, dynamic> favoriteList = favorite_data["favoriteUserList"];
//       if (!isLike) {
//         // print("Like");
//         _db
//             .collection("Board")
//             .doc(currentBoardId)
//             .collection(currentBoardId)
//             .doc(currentPostId)
//             .update({
//           "favoriteUserList": favoriteList..addAll({currentUID: true})
//         });
//       } else {
//         _db
//             .collection("Board")
//             .doc(currentBoardId)
//             .collection(currentBoardId)
//             .doc(currentPostId)
//             .update({"favoriteUserList": favoriteList..remove(currentUID)});
//       }
//       return !isLike;
//     }
//     return null;
//   }

//   commentBoxContainer() {
//     return Visibility(
//       visible: isCommentBoxVisible,
//       child: Container(
//         margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                         blurRadius: 10,
//                         color: Colors.grey[300],
//                         spreadRadius: 5)
//                   ]),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.cancel),
//                         onPressed: () {
//                           commentBoxHideMethod();
//                           _clickedCommentData.isCommentClicked = false;
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.send),
//                         onPressed: () {
//                           if (_textEditingControllerComment.text == null ||
//                               _textEditingControllerComment.text == '') {
//                             _scaffoldKey.currentState.showSnackBar(new SnackBar(
//                               content: Text("댓글 작성내용이 없습니다."),
//                               duration: Duration(seconds: 1),
//                             ));
//                           } else {
//                             commentSaveMethod();
//                             // if (!_clickedCommentData.isCommentClicked) {
//                             //   commentSaveMethod();
//                             // } else {
//                             //   _clickedCommentData.isCommentClicked = false;
//                             //   commentSaveMethod(isUnderCommentSave: true);
//                             // }
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   ConstrainedBox(
//                     constraints: BoxConstraints(maxHeight: 100, minHeight: 50),
//                     child: Container(
//                       alignment: Alignment.center,
//                       padding: const EdgeInsets.only(left: 10, right: 5),
//                       margin: const EdgeInsets.only(
//                           bottom: 10, left: 10, right: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: TextField(
//                         maxLines: null,
//                         controller: _textEditingControllerComment,
//                         decoration: InputDecoration.collapsed(
//                             hintText: setCommentHintText(false)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Future setCommentList() async {
//   //   final firebaseRealtimeDb = FirebaseDatabase.instance.reference();
//   //   firebaseRealtimeDb
//   //       .child('board')
//   //       .child(postData.boardId)
//   //       .child(postData.documentId)
//   //       .once()
//   //       .then((DataSnapshot snapshot) {
//   //     if (snapshot.value != null) {
//   //       commentList = Comment().fromFirebaseReference(snapshot);
//   //       print(2);
//   //       // print("commentList : " + commentList.length.toString());
//   //     }
//   //   });
//   // }

//   Widget createCommentListMethod() {
//     final firebaseRealtimeDb = FirebaseDatabase.instance.reference();
//     print("commentList : " + commentList.length.toString());
//     return FutureBuilder(
//       future: firebaseRealtimeDb
//           .child('board')
//           .child(postData.boardId)
//           .child(postData.documentId)
//           .once(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//           case ConnectionState.waiting:
//             return CupertinoActivityIndicator();
//           default:
//             if (snapshot.hasError) {
//               return Center(
//                   child: IconButton(
//                 icon: Icon(Icons.refresh),
//                 onPressed: () {},
//               ));
//             } else {}
//         }
//         print("SNAPSHOT : " + snapshot.data.runtimeType.toString());
//         commentList = CommentData().fromFirebaseReference(snapshot.data);
//         return Container(
//           child: AnimationLimiter(
//             child: ListView.builder(
//               key: PageStorageKey<String>("commentList"),
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: commentList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return AnimationConfiguration.staggeredList(
//                   position: index,
//                   duration: const Duration(milliseconds: 375),
//                   child: SlideAnimation(
//                     verticalOffset: 50.0,
//                     child: FadeInAnimation(
//                       child: commentBoxDesignMethod(index, commentList[index]),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget commentBoxDesignMethod(int index, CommentData comment) {
//     return Container(
//       child: Column(
//         children: [
//           Container(
//             child: Text(comment.textContent ?? "NO"),
//           )
//         ],
//       ),
//     );
//   }

//   String _commentNameMethod(var snapshot) {}

//   String _commentCreateTimeMethod(var createTimeStamp) {
//     DateTime _convertDateTime = DateTime.fromMicrosecondsSinceEpoch(
//         createTimeStamp.microsecondsSinceEpoch);
//     int dayOfToday = DateTime.now().day;
//     String _hhmmss = _convertDateTime.toString().split(' ')[1].split('.')[0];
//     String _days;
//     if (_convertDateTime.day == dayOfToday) {
//       _days = " 오늘 ";
//     } else if (dayOfToday - _convertDateTime.day == 1) {
//       _days = " 어제 ";
//     } else {
//       _days = DateTime(_convertDateTime.year, _convertDateTime.month,
//                   _convertDateTime.day)
//               .toString()
//               .split(' ')[0] +
//           ' ';
//     }
//     return _days + _hhmmss;
//   }

//   String setCommentHintText(bool isUnderComment, {String who}) {
//     return isUnderComment ? who + "의 댓글달기" : "이 글에 댓글달기";
//   }

// commentSaveMethod() async {
//   // postData.comm
//   //////
//   ////
//   ////
//   ////
//   ////
//   ////
//   ////
//   ////
//   ////
//   ////
//   ////
//   ////
//   ///

//   CommentData.toRealtimeDataWithPostData(postData)
//       .toRealtimeDatabase(
//           textContent: _textEditingControllerComment.text.trimRight(),
//           commentList: postData.commentUserList)
//       .then((value) {
//     print("DONE");
//   });

//   // await Comment(
//   //     uid: currentUID,
//   //     boardId: currentBoardId,
//   //     boardName: currentBoardName,
//   //     postId: currentPostId,
//   //     textContent: _textEditingControllerComment.text.trimRight(),userName: );
//   // databaseRef.push().set({'name': 'hi', 'comment': 'A good season'});
// }

//   commentBoxHideMethod() {
//     if (_textEditingControllerComment.text != '') {
//       showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('작성 중'),
//             content: Text("작성된 내용은 저장이 되지 않습니다."),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('나가기'),
//                 onPressed: () {
//                   setState(() {
//                     Navigator.pop(context);
//                     isCommentBoxVisible = false;
//                     _textEditingControllerComment.clear();
//                   });
//                 },
//               ),
//               FlatButton(
//                 child: Text('유지'),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       setState(() {
//         isCommentBoxVisible = false;
//       });
//     }
//   }

//   commentBoxExpanded(bool isCommentBoxVisible) {
//     return isCommentBoxVisible
//         ? SizedBox(
//             child: Container(),
//             height: device_height * (1 / 4),
//           )
//         : SizedBox(height: device_height / 20);
//   }

//   _commentContainerMethod(QuerySnapshot snapshot,
//       {bool isUnderComment, String parentCommentId}) {
//     isUnderComment = isUnderComment ?? false;
//     int _commentLength = snapshot.size;

//     Widget _commentWidget;
//     List<Widget> _commentContainerList = [];
//     List widgetList = [];
//     if (snapshot != null) {
//       //Create Comment Widget

//       for (int i = 0; i < _commentLength; i++) {
//         var _commentData = snapshot.docs[i];
//         widgetList.add(ObjectKey(i));
//         bool wasClickedLikeButton = false;
//         String _commentName = _commentNameMethod(_commentData);
//         bool isDeleted = _commentData["isDelete"] ?? false;
//         bool deletedWithInDay;
//         if (_commentData["favoriteUserList"] !=
//             null) if (_commentData["favoriteUserList"].contains(currentUID)) {
//           wasClickedLikeButton = true;
//         }
//         //댓삭튀 방지
//         //show Delete Comment if deleted date within today
//         //Check deleted date
//         if (isDeleted) {
//           DateTime _deletedDate = _commentData["deleteDate"].toDate();
//           var diffToNow = DateTime.now().difference(_deletedDate);
//           deletedWithInDay = diffToNow.inDays < 1;
//         }

//         bool isItSelf = _commentData["uid"] == googleSignIn.currentUser.id;
//         String _createDate =
//             _commentCreateTimeMethod(_commentData["createDate"]);

//         bool _clickHighlight = _clickedCommentData.clickedMethod(
//               _commentData.id,
//             ) ??
//             false;
//         _commentWidget = GestureDetector(
//           onDoubleTap: () {
//             setState(() {
//               if (!isDeleted) if (isUnderComment) {
//                 _commentDataUpdateMethod(_commentData, _commentData.id,
//                     isLiked: true,
//                     isUndo: false,
//                     underComment: true,
//                     parentCommentId: parentCommentId);
//               } else {
//                 _commentDataUpdateMethod(_commentData, _commentData.id,
//                     isLiked: true, isUndo: false, underComment: false);
//               }
//             });
//           },
//           onLongPress: isDeleted
//               ? () {
//                   //Show Deleted Comment Text
//                   DateTime _deletedDate = _commentData["deleteDate"].toDate();
//                   var diffToNow = DateTime.now().difference(_deletedDate);
//                   print(diffToNow.inDays);
//                   if (deletedWithInDay)
//                     showGeneralDialog(
//                         barrierColor: Colors.black.withOpacity(0.5),
//                         transitionBuilder: (context, a1, a2, widget) {
//                           return Transform.scale(
//                             scale: a1.value,
//                             child: Opacity(
//                               opacity: a1.value,
//                               child: AlertDialog(
//                                 shape: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(16.0)),
//                                 content: Text(_commentData["text"]),
//                               ),
//                             ),
//                           );
//                         },
//                         transitionDuration: Duration(milliseconds: 200),
//                         barrierDismissible: true,
//                         barrierLabel: '',
//                         context: context,
//                         pageBuilder: (context, animation1, animation2) {});
//                 }
//               : null,
//           onTap: () {
//             // setState(() {
//             //   _clickedCommentData.commentDocumentId = _commentData.id;
//             //   _clickedCommentData.isCommentClicked = true;
//             // });

//             // bool isClicked = false;

//             // //Set BottomSheet
//             // if (Platform.isAndroid) {
//             //   //Color Change when you click the comment
//             //   setState(() {
//             //     _clickedCommentData.isCommentClicked = true;
//             //   });
//             //   showMaterialModalBottomSheet(
//             //     context: context,
//             //     shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.only(
//             //             topLeft: Radius.circular(20),
//             //             topRight: Radius.circular(20))),
//             //     builder: (context) => Container(
//             //       margin: EdgeInsets.only(left: 5, right: 5),
//             //       height: device_height / 3,
//             //       child: Column(children: [
//             //         Container(
//             //           key: ObjectKey(i),
//             //           margin: EdgeInsets.only(top: 10, bottom: 20),
//             //           child: SizedBox(
//             //             width: device_width / 7,
//             //             height: device_height / 100,
//             //             child: DecoratedBox(
//             //               decoration: BoxDecoration(
//             //                   borderRadius: BorderRadius.circular(30),
//             //                   color: Colors.grey[400]),
//             //             ),
//             //           ),
//             //         ),
//             //         //set BottomSheet Button
//             //         _setCommentButtonMethod(
//             //             onTap: () {
//             //               isClicked = true;
//             //               Navigator.pop(context);
//             //               setState(() {
//             //                 _clickedCommentData.commentDocumentId =
//             //                     _commentData.id;
//             //                 _clickedCommentData.isCommentClicked = true;
//             //                 isCommentBoxVisible = true;
//             //               });
//             //             },
//             //             text: Text(
//             //               "댓글 달기",
//             //               style: TextStyle(color: Colors.red, fontSize: 18),
//             //             )),
//             //         _setCommentButtonMethod(
//             //           text: Text(
//             //             "채팅 시작하기",
//             //             style: TextStyle(color: Colors.red, fontSize: 18),
//             //           ),
//             //         ),
//             //         _setCommentButtonMethod(
//             //           onTap: isItSelf
//             //               ? () {
//             //                   if (!isDeleted) {
//             //                     if (!isUnderComment) {
//             //                       setState(() {
//             //                         isCommentRefresh = true;
//             //                         Navigator.pop(context);
//             //                         _commentDataUpdateMethod(
//             //                             _commentData, _commentData.id);
//             //                       });
//             //                     } else {
//             //                       setState(() {
//             //                         isCommentRefresh = true;
//             //                         Navigator.pop(context);
//             //                         _commentDataUpdateMethod(
//             //                             _commentData, _commentData.id,
//             //                             underComment: true,
//             //                             parentCommentId: parentCommentId,
//             //                             isUndo: false);
//             //                       });
//             //                     }
//             //                     //Delete

//             //                   } else {
//             //                     //Already Deleted
//             //                     Navigator.pop(context);
//             //                     Future.delayed(Duration(milliseconds: 1000));
//             //                     _scaffoldKey.currentState
//             //                         .showSnackBar(new SnackBar(
//             //                       content: Text("이미 삭제된 댓글입니다!"),
//             //                       duration: Duration(seconds: 1),
//             //                     ));
//             //                   }
//             //                 }
//             //               : null,
//             //           text: Text(
//             //             isItSelf ? "삭제하기" : "신고하기",
//             //             style: TextStyle(color: Colors.red, fontSize: 18),
//             //           ),
//             //         ),
//             //       ]),
//             //     ),
//             //   ).then((value) {
//             //     setState(() {
//             //       if (!isClicked) _clickedCommentData.isCommentClicked = false;
//             //     });
//             //   });
//             // } else if (Platform.isIOS) {
//             //   // showCupertinoModalBottomSheet(
//             //   //     context: context, builder: (context) => Container());
//             // }
//           },
//           child: Container(
//             padding: EdgeInsets.all(5),
//             margin: !isUnderComment
//                 ? EdgeInsets.only(top: 5.0, left: 10, right: 5)
//                 : EdgeInsets.only(top: 5.0, left: 30, right: 5),
//             decoration: BoxDecoration(
//               color: _clickHighlight ? Colors.yellowAccent : Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(5)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 5,
//                   blurRadius: 7,
//                   offset: Offset(0, 3), // changes position of shadow
//                 ),
//               ],
//             ),
//             width: device_width,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                             child: Text(
//                           _commentName,
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         )),
//                         !isDeleted
//                             ? Row(children: [
//                                 Container(
//                                   margin: EdgeInsets.only(left: 5),
//                                   child: Icon(
//                                     wasClickedLikeButton
//                                         ? Icons.favorite
//                                         : Icons.favorite_border,
//                                     color: Colors.redAccent,
//                                     size: 15,
//                                   ),
//                                 ),
//                                 Text(_commentData["favoriteCount"].toString())
//                               ])
//                             : Container()
//                       ],
//                     ),
//                     //Show Comment anonymous name
//                     Container(
//                       // child: Text(_commentData["createDate"].runtimeType.toString())
//                       child: Text(
//                         _createDate,
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                     )
//                   ],
//                 ),
//                 //Show Comment Text
//                 Container(
//                   margin: EdgeInsets.only(left: 5),
//                   child: !isDeleted
//                       ? Text(_commentData["text"])
//                       : Text(
//                           "삭제 된 댓글입니다.",
//                           style: TextStyle(
//                               //Can See deleted text => blueAccent
//                               color: deletedWithInDay
//                                   ? Colors.blueAccent
//                                   : Colors.redAccent,
//                               fontWeight: FontWeight.bold),
//                         ),
//                 )
//               ],
//             ),
//           ),
//         );

//         _commentContainerList.add(Column(
//           children: [
//             _commentWidget,
//           ],
//         ));
//       }
//     }
//     return Container(
//       child: Column(
//         children: _commentContainerList,
//       ),
//     );
//   }

//   //Comment Alter Method
//   _commentDataUpdateMethod(var commentData, String documentId,
//       {bool isUndo, bool underComment, String parentCommentId, bool isLiked}) {
//     underComment = underComment ?? false;
//     isUndo = isUndo ?? false;
//     isLiked = isLiked ?? false;
//     String _postId = postData.boardId.toString();
//     String _documentID = postData.documentId.toString();
//     if (!isLiked) {
//       if (!underComment) {
//         //If NOT underComment
//         FirebaseFirestore.instance
//             .collection("Board")
//             .doc(_postId)
//             .collection(_postId)
//             .doc(_documentID)
//             .collection(commentCollectionName)
//             .doc(documentId)
//             .update({
//           "isDelete": !isUndo ? true : false,
//           "deleteDate": Timestamp.fromDate(DateTime.now())
//         });
//       } else {
//         //If underComment
//         FirebaseFirestore.instance
//             .collection("Board")
//             .doc(_postId)
//             .collection(_postId)
//             .doc(_documentID)
//             .collection(commentCollectionName)
//             .doc(parentCommentId)
//             .collection(commentCollectionName)
//             .doc(documentId)
//             .update({
//           "isDelete": !isUndo ? true : false,
//           "deleteDate": Timestamp.fromDate(DateTime.now())
//         });
//       }
//       _scaffoldKey.currentState.showSnackBar(new SnackBar(
//         content: !isUndo ? Text("댓글이 삭제되었습니다.") : Text("되돌리기!"),
//         action: !isUndo
//             ? SnackBarAction(
//                 label: "되돌리기",
//                 onPressed: () {
//                   if (!underComment) {
//                     _commentDataUpdateMethod(commentData, documentId,
//                         isUndo: true);
//                     setState(() {
//                       isCommentRefresh = true;
//                     });
//                   } else {
//                     _commentDataUpdateMethod(commentData, documentId,
//                         isUndo: true,
//                         underComment: true,
//                         // commentDocumentId: commentDocumentId,
//                         parentCommentId: parentCommentId);
//                     setState(() {
//                       isCommentRefresh = true;
//                     });
//                   }
//                 })
//             : null,
//         duration: Duration(milliseconds: 1500),
//       ));
//     } else {
//       print(commentData["favoriteUserList"].add(currentUID));
//       if (!underComment) {
//         //If NOT underComment
//         FirebaseFirestore.instance
//             .collection("Board")
//             .doc(_postId)
//             .collection(_postId)
//             .doc(_documentID)
//             .collection(commentCollectionName)
//             .doc(documentId)
//             .update({
//           "favoriteCount": commentData["favoriteCount"] + 1,
//           "favoriteUserList": commentData["favoriteUserList"]..add(currentUID)
//         });
//         setState(() {});
//       } else {
//         //If underComment
//         FirebaseFirestore.instance
//             .collection("Board")
//             .doc(_postId)
//             .collection(_postId)
//             .doc(_documentID)
//             .collection(commentCollectionName)
//             .doc(parentCommentId)
//             .collection(commentCollectionName)
//             .doc(documentId)
//             .update({
//           "favoriteCount": commentData["favoriteCount"] + 1,
//           "favoriteUserList": commentData["favoriteUserList"]..add(currentUID)
//         });
//         setState(() {});
//       }
//     }
//   }

//   _setCommentButtonMethod({
//     Text text,
//     Function onTap,
//   }) {
//     return GestureDetector(
//         onTap: onTap,
//         child: Container(
//           // margin: EdgeInsets.only(top: 10,bottom: 10),
//           width: device_width,
//           decoration: BoxDecoration(
//               border: Border(
//                   top: BorderSide(
//             color: Colors.grey,
//             width: 1,
//           ))),
//           child: Container(
//             margin: EdgeInsets.only(top: 10, bottom: 10),
//             child: Center(child: text ?? Text("")
//                 // Text(
//                 //   text ?? "",
//                 //   style: TextStyle(color: Colors.red, fontSize: 18),
//                 ),
//           ),
//         ));
//   }

//   Future _setPopUpFavoriteIcon() async {
//     TipDialogHelper.show(
//         tipDialog: new TipDialog.builder(bodyBuilder: (context) {
//       return Opacity(
//         opacity: 0.9,
//         child: new Container(
//             color: Colors.white,
//             width: 90,
//             height: 90,
//             alignment: Alignment.center,
//             child: Icon(
//               Icons.favorite,
//               size: 90,
//               color: Colors.red,
//             )),
//       );
//     }));
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _animationController.dispose();
//     _favoriteAnimationController?.dispose();
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(StringProperty('REFRESH_COMMENT', refreshComment));
//   }
// }

// class ClickedCommentData {
//   String commentDocumentId;
//   bool isCommentClicked = false;
//   ClickedCommentData({this.commentDocumentId, this.isCommentClicked});
//   bool clickedMethod(String clickedCommentId) {
//     if (isCommentClicked != null) if (isCommentClicked) {
//       if (commentDocumentId != null) if (commentDocumentId == clickedCommentId)
//         return true;
//     }
//     return false;
//   }
// }
