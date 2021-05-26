import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/listRiverpod.dart';

// import 'package:onestep_rezero/board/StateManage/Provider/postListProvider.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';

abstract class AbstractPostListView extends ConsumerWidget {
  AbstractPostListView({this.postList});
  final List<PostData> postList;

  // firstColumnLine(postData);
  // secondColumnLine(postData);
  // thirdColumnLine(postData);

}

// ignore: must_be_immutable
class PostList extends ConsumerWidget {
  final List<PostData> postList;
  PostList({this.postList});
  double deviceHeight;
  double deviceWidth;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
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
                  child: _buildListCard(context, index, postList[index]),
                ),
              ),
            );
          },
        ),
      ),
    );

    // setDeviceHeightWidth(context);
    // setPostList();
    // Widget scaffoldBody;
    // if (postList != null) {
    //   if (postList.isNotEmpty) {
    //     scaffoldBody = Container(
    //         child: ListView.builder(
    // physics: NeverScrollableScrollPhysics(),
    // shrinkWrap: true,
    //             //PageStorageKey is Keepping ListView scroll position when switching pageview
    //             key: PageStorageKey<String>("value"),
    //             //Bottom Padding
    //             padding: const EdgeInsets.only(
    //                 bottom: kFloatingActionButtonMargin + 60),
    // itemCount: postList.length,
    //             itemBuilder: (context, index) {
    //               // final currentRow = (index + 1) ~/ FETCH_ROW;
    //               // if (_lastRow != currentRow) {
    //               //   _lastRow = currentRow;
    //               // }
    //               return _buildListCard(context, index, postList[index]);
    //             }));
    //   } else {
    //     return Center(child: CupertinoActivityIndicator());
    //   }
    //   //This part setting
    //   // scaffoldBody = Center(child: Text("새 게시글로 시작해보세요!"));
    // } else {
    //   scaffoldBody = Center(child: Text(PostListProvider().errorMessage));
    // }
    // return scaffoldBody;
  }

  Widget _buildListCard(BuildContext context, int index, var postData) {
    bool isDeleted = postData.deleted ?? false;
    if (!isDeleted)
      return SizedBox(
        height: deviceHeight / 9.2,
        width: deviceWidth * 0.9,
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(deviceHeight / 200),
              //Click Animation
              child: InkWell(
                  // Set Click Color
                  splashColor: Colors.grey,
                  //Click Event
                  onTap: () async {
                    await Navigator.of(context).pushNamed('/PostContent',
                        arguments: {
                          "CURRENTBOARDDATA": postData
                        }).then((value) => context
                        .read(listProvider)
                        .fetchPosts(postData.boardId));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      firstColumnLine(postData),
                      secondColumnLine(postData),
                      thirdColumnLine(postData)
                    ],
                  ))),
        ),
      );
    else
      return Container();
  }

  firstColumnLine(postData) {
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            )),
        // titleContainerMethod(title: postData.title ?? ""),
        // _commentCountMethod(index)
      ],
    ));
  }

  secondColumnLine(postData) {
    String _checkCate = postData.contentCategory.split('.')[1];
    String category;
    if (_checkCate == ContentCategory.QUESTION.toString().split('.')[1]) {
      category = ContentCategory.QUESTION.category;
    } else if (_checkCate ==
        ContentCategory.SMALLTALK.toString().split('.')[1]) {
      category = ContentCategory.SMALLTALK.category;
    }
    // else if (kReleaseMode) {
    //   throw new CategoryException(
    //       "Does not match category. Please Update Enum in parentSate.dart Or If statement in boardListView.dart secondColumnLine");
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: deviceWidth / 50),
        ),
        Container(
            height: deviceHeight / 27 * 0.6,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(3.0))),
            child: Center(
              child: Text(
                category ?? "",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        Container(
          height: deviceHeight / 27,
          alignment: Alignment.centerLeft,
          child: Container(
              margin: EdgeInsets.only(left: deviceWidth / 50),
              width: deviceWidth * 0.8,
              child: Text(postData.textContent ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 13))),
        ),
      ],
    );
  }

  thirdColumnLine(postData) {
    return Container(
        padding: EdgeInsets.only(left: deviceWidth / 50),
        child: Row(children: <Widget>[
          Expanded(
              child: Row(
            children: <Widget>[
              IconTheme(
                  child: Icon(Icons.favorite, size: 14),
                  data: new IconThemeData(color: Colors.red)),
              // Icon(Icons.favorite),
              Container(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  postData.favoriteCount.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                ' | ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                child: _setDateTimeText(postData.uploadTime, postData),
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

  _setDateTimeText(DateTime dateTime, var boardData) {
    String resultText;
    DateTime today = DateTime.now();
    today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime setUTC9 = dateTime;
    var _dateDifference = DateTime(setUTC9.year, setUTC9.month, setUTC9.day)
        .difference(today)
        .inDays;
    if (_dateDifference == 0 || _dateDifference == -1) {
      var _date = setUTC9.toString().split(' ')[1].split('.')[0];
      if (_dateDifference == 0) {
        resultText = "오늘 " + _date;
      } else {
        resultText = "어제 " + _date;
      }
    } else {
      var _date = dateTime.toString().split('');
      int _dateLength = dateTime.toString().split('').length;
      _date.removeRange(_dateLength - 10, _dateLength);
      resultText = _date.join();
    }

    return Text(resultText);
  }
}
