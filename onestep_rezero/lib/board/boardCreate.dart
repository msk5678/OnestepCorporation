import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimation.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';

class BoardCreate extends StatefulWidget {
  @override
  _BoardCreate createState() => _BoardCreate();
}

class _BoardCreate extends State<BoardCreate> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  int delayAmount = 500;
  List<BoardCategory> boardCategoryList = [];
  initState() {
    super.initState();
    resetItem();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
        color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: deviceWidth / 20, right: deviceWidth / 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: deviceHeight / 13,
            ),
            ShowUp(
              child: Text(
                "어떤",
                style: textStyle,
              ),
              delay: delayAmount,
            ),
            ShowUp(
              child: Text(
                "게시판을 만들까요?",
                style: textStyle,
              ),
              delay: delayAmount + 200,
            ),
            SizedBox(
              height: deviceHeight / 20,
            ),
            AnimatedList(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              key: _listKey,
              initialItemCount: boardCategoryList.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(index, animation);
              },
            )
            // ListView.separated(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: BoardCategory.values.length,
            //   itemBuilder: (context, index) {
            //     return ShowUp(
            //         delay: delayAmount + (700 + 200 * index),
            //         child: Container(
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //               border: Border.all(width: 0.5, color: Colors.grey)),
            //           child: Row(
            //             // mainAxisAlignment: MainAxisAlignment,
            //             children: <Widget>[
            //               Icon(
            //                 BoardCategory.values[index].categoryData.icon,
            //                 size: 35,
            //               ),
            //               SizedBox(
            //                 width: deviceWidth / 70,
            //               ),
            //               Text(BoardCategory.values[index].categoryData.title,
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.bold, fontSize: 20)),
            //               SizedBox(
            //                 width: deviceWidth / 50,
            //               ),
            //               Text(BoardCategory.values[index].categoryData.explain,
            //                   textAlign: TextAlign.end,
            //                   style:
            //                       TextStyle(fontSize: 13, color: Colors.grey)),
            //             ],
            //           ),
            //         ));
            //   },
            //   separatorBuilder: (BuildContext context, int index) {
            //     return Divider(
            //       color: Colors.white,
            //     );
            //   },
            // )
          ]),
        ),
      ),
    );
  }

  void _removeSingleItem(int removeIndex) {
    // Remove item from data list but keep copy to give to the animation.
    boardCategoryList.removeAt(removeIndex);
    // This builder is just for showing the row while it is still
    // animating away. The item is already gone from the data list.
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removeIndex, animation);
      // return _buildItem(removedItem, animation);
    };

    // Remove the item visually from the AnimatedList.
    _listKey.currentState.removeItem(removeIndex, builder);
  }

  Widget _buildItem(int index, Animation animation) {
    return ShowUp(
      delay: delayAmount + (700 + 200 * index),
      child: GestureDetector(
        onTap: () {
          int length = boardCategoryList.length;

          // for (int i = index + 1; i < length; i++) _removeSingleItem(i);
          // for (int i = 0; i < index; i++) _removeSingleItem(i);
        },
        child: SizeTransition(
            sizeFactor: animation,
            child: Card(
                child: ListTile(
              leading: Icon(boardCategoryList[index].categoryData.icon),
              title: Text(
                boardCategoryList[index].categoryData.title,
                style: TextStyle(fontSize: 20),
              ),
            ))),
      ),
    );
  }

  void resetItem() {
    boardCategoryList = BoardCategory.values.toList();
  }
}
