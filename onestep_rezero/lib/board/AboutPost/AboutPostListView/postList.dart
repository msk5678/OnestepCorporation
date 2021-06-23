import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/listRiverpod.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/timeUtil.dart';

class PostList extends ConsumerWidget {
  final List<PostData> postList;
  final customPostListCallback;
  PostList({this.postList, this.customPostListCallback});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final String currentUid = currentUserModel.uid;
    return Container(
      child: AnimationLimiter(
        child: ListView.builder(
          key: PageStorageKey<String>("commentList"),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: postList.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildListCard(context, index, postList[index],
                      deviceHeight, deviceWidth, currentUid),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  postClickEvent(BuildContext context, PostData postData) async {
    await Navigator.of(context).pushNamed('/PostContent', arguments: {
      "CURRENTBOARDDATA": postData
    }).then((value) => context.read(listProvider).fetchPosts(postData.boardId));
  }

  Widget _buildListCard(BuildContext context, int index, var postData,
      double deviceHeight, double deviceWidth, String currentUid) {
    bool isDeleted = postData.deleted ?? false;
    if (!isDeleted)
      return SizedBox(
        height: deviceHeight / 9.2,
        width: deviceWidth * 0.9,
        child: Card(
          elevation: 0,
          child: Padding(
              padding: EdgeInsets.all(deviceHeight / 200),
              //Click Animation
              child: InkWell(
                  // Set Click Color
                  splashColor: Colors.grey,
                  //Click Event
                  onTap: () async {
                    if (customPostListCallback == null)
                      postClickEvent(context, postData);
                    else
                      customPostListCallback(
                          context, postData, currentUserModel.uid);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      firstColumnLine(postData, deviceHeight, deviceWidth),
                      secondColumnLine(postData, deviceHeight, deviceWidth),
                      thirdColumnLine(
                          postData, deviceHeight, deviceWidth, currentUid)
                    ],
                  ))),
        ),
      );
    else
      return Container();
  }

  firstColumnLine(postData, double deviceHeight, double deviceWidth) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        //Title Container
        Container(
            margin: EdgeInsets.only(left: deviceWidth / 50),
            width: deviceWidth * 0.9,
            child: Text(
              postData.title ?? "",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            )),
        // titleContainerMethod(title: postData.title ?? ""),
        // _commentCountMethod(index)
      ],
    ));
  }

  secondColumnLine(postData, double deviceHeight, double deviceWidth) {
    String _checkCate = postData.contentCategory.split('.')[1];
    String category;
    if (_checkCate == ContentCategory.QUESTION.toString().split('.')[1]) {
      category = ContentCategory.QUESTION.categoryData.title;
    } else if (_checkCate ==
        ContentCategory.SMALLTALK.toString().split('.')[1]) {
      category = ContentCategory.SMALLTALK.categoryData.title;
    }
    // else if (kReleaseMode) {
    //   throw new CategoryException(
    //       "Does not match category. Please Update Enum in parentSate.dart Or If statement in boardListView.dart secondColumnLine");
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            // padding: EdgeInsets.only(left: deviceWidth / 50),
            ),
        // Container(
        //     height: deviceHeight / 27 * 0.6,
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //         color: Colors.grey[200],
        //         borderRadius: BorderRadius.all(Radius.circular(3.0))),
        //     child: Center(
        //       child: Text(
        //         category ?? "",
        //         style: TextStyle(
        //           fontSize: 13,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     )),
        Container(
            height: deviceHeight / 27 * 0.6,
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: deviceWidth / 50),
              width: deviceWidth * 0.8,
              child: Text(postData.textContent ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 13)),
            )),
      ],
    );
  }

  thirdColumnLine(
      PostData postData, double deviceHeight, double deviceWidth, String uid) {
    bool clickedFavorite = postData.favoriteUserList.containsKey(uid);
    bool havePicture = postData.imageCommentMap["IMAGE"].length != 0;
    return Container(
        padding: EdgeInsets.only(left: deviceWidth / 50),
        child: Row(children: <Widget>[
          Expanded(
              child: Row(
            children: <Widget>[
              IconTheme(
                  child: Icon(
                      clickedFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 14),
                  data: new IconThemeData(color: OnestepColors().mainColor)),
              // Icon(Icons.favorite),
              Container(
                padding: EdgeInsets.only(left: 3, right: 5),
                child: Text(
                  postData.favoriteCount.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),

              IconTheme(
                  child: havePicture
                      ? Icon(
                          Icons.photo_rounded,
                          size: 14,
                          color: OnestepColors().mainColor,
                        )
                      : Icon(Icons.photo_outlined,
                          color: Colors.grey, size: 14),
                  data: new IconThemeData(color: Colors.red)),
              // Icon(Icons.favorite),

              Text(
                ' | ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                child: Text('${TimeUtil.timeAgo(date: postData.uploadTime)}'),
              ),
              Spacer(),

              Container(
                  child: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
                size: 14,
              )),
              Container(
                padding: EdgeInsets.only(left: 3),
                margin: EdgeInsets.only(right: 3),
                child: Text(postData.views.length.toString()),
              )
            ],
            // Icon(Icons.favorite), child: Text('Date')
          )),
        ]));
  }
}
