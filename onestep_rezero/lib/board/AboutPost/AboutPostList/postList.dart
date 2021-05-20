import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onestep_rezero/board/StateManage/Provider/postListProvider.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';

final postListProvider =
    ChangeNotifierProvider<PostListProvider>((ref) => PostListProvider());
final FETCH_ROW = 15;

class PostListRiverpod extends ConsumerWidget {
  PostListRiverpod();
  @override
  Widget build(BuildContext context, watch) {
    final postlistProvider = watch(postListProvider).boards;
    return PostListView(
      postList: postlistProvider,
    );
  }
}

class PostListView extends ConsumerWidget {
  final List postList;
  const PostListView({Key key, this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    Widget scaffoldBody;
    if (postList != null) {
      if (postList.isNotEmpty) {
        scaffoldBody = Container(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //PageStorageKey is Keepping ListView scroll position when switching pageview
                key: PageStorageKey<String>("value"),
                //Bottom Padding
                padding: const EdgeInsets.only(
                    bottom: kFloatingActionButtonMargin + 60),
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  // final currentRow = (index + 1) ~/ FETCH_ROW;
                  // if (_lastRow != currentRow) {
                  //   _lastRow = currentRow;
                  // }
                  return _buildListCard(context, index, postList[index]);
                }));
      } else {
        return Center(child: CupertinoActivityIndicator());
      }
      //This part setting
      // scaffoldBody = Center(child: Text("새 게시글로 시작해보세요!"));
    } else {
      scaffoldBody = Center(child: Text(PostListProvider().errorMessage));
    }
    return scaffoldBody;
  }

  Widget _buildListCard(BuildContext context, int index, var boardData) {
    bool isDeleted = boardData.deleted ?? false;
    if (!isDeleted)
      return Card(
        child: Padding(
            padding: const EdgeInsets.all(1.0),
            //Click Animation
            child: InkWell(
                // Set Click Color
                splashColor: Colors.grey,
                //Click Event
                onTap: () async {
                  await Navigator.of(context).pushNamed('/PostContent',
                      arguments: {
                        "BOARD_DATA": boardData
                      }).then((value) => context
                      .read(postListProvider)
                      .fetchPosts(boardData.boardId));
                },
                child: Column(
                  children: <Widget>[
                    firstColumnLine(boardData),
                    secondColumnLine(boardData),
                    thirdColumnLine(boardData)
                  ],
                ))),
      );
    else
      return Container();
  }

  firstColumnLine(var boardData) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        //Title Container
        titleContainerMethod(title: boardData.title ?? ""),
        // _commentCountMethod(index)
      ],
    ));
  }

  secondColumnLine(var boardData) {
    String _checkCate = boardData.contentCategory.split('.')[1];
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
          padding: EdgeInsets.only(left: 5.0),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(3.0))),
            child: Text(
              category ?? "",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )),
        Container(
          height: 20,
          alignment: Alignment.centerLeft,
          child: Container(
              margin: const EdgeInsets.only(left: 5),
              width: 300,
              child: Text(boardData.textContent ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 13))),
        ),
      ],
    );
  }

  thirdColumnLine(var boardData) {
    return Container(
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
              boardData.favoriteCount.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            ' | ',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Container(
            child: _setDateTimeText(boardData.uploadTime, boardData),
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
            child: Text(boardData.views.length.toString()),
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

  @override
  Widget titleContainerMethod({@required String title}) {
    return Container(
        margin: const EdgeInsets.only(left: 5),
        width: 300,
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ));
  }
}
