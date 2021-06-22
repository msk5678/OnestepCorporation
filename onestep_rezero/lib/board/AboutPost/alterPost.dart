import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/AboutPost/createPost.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';

class AlterPost extends StatefulWidget {
  final postData;
  AlterPost({Key key, this.postData}) : super(key: key);

  @override
  _AlterPostState createState() => _AlterPostState();
}

class _AlterPostState extends CreatePageParent<AlterPost> {
  PostData alterPostData;

  @override
  void initState() {
    alterPostData = widget.postData;
    super.initState();

    textEditingControllerBottomSheet..text = alterPostData.title;
    textEditingControllerContent..text = alterPostData.textContent;
    imageCommentMap =
        Map<String, List<dynamic>>.from(alterPostData.imageCommentMap);
  }

  @override
  setBoardData() {
    currentBoardData = new BoardData(
        boardId: alterPostData.boardId, boardName: alterPostData.boardName);
  }

  @override
  Widget build(BuildContext context) {
    // print("CreatePost AssetThumb change to ConvertImages ");
    return Stack(
      children: <Widget>[
        Scaffold(
          body: WillPopScope(
            onWillPop: () {
              isDataContain()
                  ? Navigator.pop(context)
                  : navigatorPopAlertDialog();
              return null;
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SafeArea(
                minimum: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      firstContainer(),
                      displayCurrentBoard(currentBoardData.boardName),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          alignment: Alignment.bottomLeft,
                          width: deviceWidth / 3,
                          child: postCategory(
                              ContentCategory.values, deviceHeight, category)),
                      setPostName(deviceHeight),
                      secondContainer(),
                      thirdContainer(imageCommentMap),
                      SizedBox(
                        height: deviceHeight / 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // )),
        ),
        TipDialogContainer(duration: const Duration(seconds: 2))
      ],
    );
  }

  @override
  firstContainer() {
    TextStyle _textStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                isDataContain()
                    ? Navigator.pop(context)
                    : navigatorPopAlertDialog();
              },
              child: Container(
                child: Text(
                  "취소",
                  style: _textStyle,
                ),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () async {
                var _result = checkDataContain();
                if (_result.runtimeType == bool) {
                  if (_result) {
                    saveDataInFirestore();
                  }
                } else if (_result.runtimeType == String) {
                  print(_result);
                  switch (_result.toString()) {
                    case "CONTENT":
                      ScaffoldMessenger.of(context).showSnackBar(
                          showSnackBar(textMessage: Text("내용을 입력하세요.")));
                      break;
                    case "CATEGORY":
                      ScaffoldMessenger.of(context).showSnackBar(
                          showSnackBar(textMessage: Text("카테고리 분류를 입력하세요.")));
                      break;
                    case "TITLE":
                      ScaffoldMessenger.of(context).showSnackBar(
                          showSnackBar(textMessage: Text("제목을 입력하세요.")));
                      // _scaffoldKey.currentState.showSnackBar(
                      // showSnackBar(textMessage: Text("제목을 입력하세요.")));
                      break;
                  }
                }
              },
              child: Container(
                child: Text(
                  "작성",
                  style: _textStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  saveDataInFirestore() async {
    TipDialogHelper.loading("저장 중입니다.\n 잠시만 기다려주세요.");

    await updateData(alterPostData).then((value) {
      TipDialogHelper.dismiss();
      TipDialogHelper.success("저장 완료!");
      Future.delayed(Duration(seconds: 2))
          .then((value) => Navigator.pop(context, alterPostData));
    }).whenComplete(() {});
  }

  Future updateData(PostData postData) async {
    setterImgCommentFromMapToTextEditingControl(imageCommentMap);
    PostData updatedData = PostData(
      title: textEditingControllerBottomSheet.text,
      imageCommentMap: imageCommentMap,
      textContent: textEditingControllerContent.text,
      contentCategory: category.toString(),
    );

    return await postData.updatePostData(context, updatedData);
  }

  @override
  thirdContainer(Map<String, dynamic> imgCommMap) {
    List<Widget> _imageWidget = [];
    List<Widget> _emptyWidget = [];
    int containImageCount =
        imgCommMap["IMAGE"] != null ? imageCommentMap["IMAGE"].length : 0;
    for (int i = 0; i < containImageCount; i++) {
      if (imgCommMap["IMAGE"][i].runtimeType == String) {
        continue;
      }
      _imageWidget.add(cachedImgWidget(imgCommMap["IMAGE"][i]));
    }
    for (int i = 0; i < maxImageCount - containImageCount; i++) {
      _emptyWidget.add(emptyImageWidget(imgCommMap));
    }
    return Container(
      child: Column(
        children: _imageWidget
          ..add(Row(
            children: _emptyWidget,
          )),
      ),
    );
  }

  cachedImgWidget(String imageURL) {
    return CachedNetworkImage(imageUrl: imageURL);
  }
}
