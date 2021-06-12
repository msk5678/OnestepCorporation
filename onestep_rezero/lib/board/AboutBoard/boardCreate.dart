import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/Animation/slideUpAnimationWidget.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';

import '../TipDialog/tip_dialog.dart';

class BoardCreate extends StatefulWidget {
  final boardCategory;

  const BoardCreate({Key key, this.boardCategory}) : super(key: key);
  @override
  _BoardCreate createState() => _BoardCreate();
}

class _BoardCreate extends State<BoardCreate> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  TextEditingController textControllerTitle;
  TextEditingController textControllerExplain;

  int delayAmount = 500;
  List<BoardCategory> boardCategoryList = [];
  BoardCategory selectedBoardCategory;
  int selectedIndex;
  bool isTitleTextEmpty;

  initState() {
    super.initState();
    resetItem();
    textControllerTitle = TextEditingController();
    textControllerExplain = TextEditingController();
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth / 20, right: deviceWidth / 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        return _buildItem(
                            boardCategoryList[index], animation, index);
                      },
                    ),
                    boardDetailSettingWidget(),
                    saveButtonWidget(),
                  ]),
            ),
          ),
        ),
        TipDialogContainer(duration: const Duration(seconds: 2))
      ]),
    );
  }

  Widget boardDetailSettingWidget() {
    if (selectedBoardCategory != null) {
      return ShowUp(
        delay: 500,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: "게시판 이름",
                      errorText: isTitleTextEmpty != null
                          ? isTitleTextEmpty
                              ? "이름을 입력하세요."
                              : null
                          : null),
                  onChanged: (value) {
                    if (value == "")
                      isTitleTextEmpty = true;
                    else
                      isTitleTextEmpty = false;
                    setState(() {});
                  },
                  controller: textControllerTitle,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "게시판 설명"),
                  controller: textControllerExplain,
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget saveButtonWidget() {
    if (isTitleTextEmpty != null) if (!isTitleTextEmpty &&
        selectedBoardCategory != null) {
      return ShowUp(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: OnestepColors().fifColor, elevation: 0),
          child: Text("게시하기!"),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (!isTitleTextEmpty) {
              final db = FirebaseFirestore.instance;
              String currentTimeStamp =
                  DateTime.now().millisecondsSinceEpoch.toString();
              TipDialogHelper.loading("게시 중입니다.\n 잠시만 기다려주세요.");
              await db
                  .collection('university')
                  .doc(currentUserModel.university)
                  .collection('board')
                  .doc(currentTimeStamp)
                  .set({
                "boardName": textControllerTitle.text.trim(),
                "boardExplain": textControllerExplain.text.trim(),
                "boardCategory": selectedBoardCategory.boardCategoryName
              }).then((value) {
                TipDialogHelper.dismiss();
                TipDialogHelper.success("저장 완료!");
                Future.delayed(Duration(seconds: 2))
                    .then((value) => Navigator.pop(context, true));
              });
            }
          },
        ),
      );
    }

    return Container();
  }

  void _removeItems() {
    //Dismiss Under selected item
    int removeIndex = selectedIndex + 1;
    int count = boardCategoryList.length - removeIndex;
    for (int i = 0; i < count; i++) {
      BoardCategory removedItem = boardCategoryList.removeAt(removeIndex);
      AnimatedListRemovedItemBuilder builder = (context, animation) {
        return _buildItem(removedItem, animation, removeIndex);
      };
      _listKey.currentState.removeItem(removeIndex, builder);
    }
    //Dismiss Over selected item
    removeIndex = 0;
    count = selectedIndex;
    for (int i = 0; i < count; i++) {
      BoardCategory removedItem = boardCategoryList.removeAt(removeIndex);
      AnimatedListRemovedItemBuilder builder = (context, animation) {
        return _buildItem(removedItem, animation, removeIndex);
      };
      _listKey.currentState.removeItem(removeIndex, builder);
    }
    setState(() {});
  }

  // void insertItems() {
  //   resetItem();

  //   for (int offset = 0; offset < selectedIndex; offset++) {
  //     _listKey.currentState.insertItem(offset);
  //   }
  // }

  Widget _buildItem(
    BoardCategory boardCategory,
    Animation animation,
    int index,
  ) {
    return ShowUp(
      delay: delayAmount + (700 + 200 * index),
      child: GestureDetector(
        onTap: () {
          if (selectedBoardCategory == null) {
            selectedBoardCategory = boardCategory;

            selectedIndex = index;
            _removeItems();
          }
          //  else {
          //   insertItems();
          //   selectedBoardCategory = null;
          // }
        },
        child: SizeTransition(
            sizeFactor: animation,
            child: Card(
                child: ListTile(
              leading: Icon(boardCategory.categoryData.icon),
              title: Text(
                boardCategory.categoryData.title,
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
