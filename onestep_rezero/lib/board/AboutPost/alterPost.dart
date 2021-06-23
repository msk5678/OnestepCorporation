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
      if (imgCommMap["IMAGE"][i].runtimeType != String) {
        continue;
      }
      _imageWidget.add(Container(
          padding: EdgeInsets.all(5.0),
          child: imageContainer(i, cachedImgWidget(imgCommMap["IMAGE"][i]),
              imageCommentMap["COMMENT"][i])));
    }
    for (int i = 0; i < maxImageCount - containImageCount; i++) {
      _emptyWidget.add(emptyImageWidget(imgCommMap));
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  @override
  imageContainer(int index, image, String comment) {
    Widget cachedImage = image;
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Container(
              child: PopupMenuButton<int>(
                  onSelected: (value) async {
                    bool result = await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('사진 삭제'),
                            content: Text("사진 및 설명이 삭제됩니다."),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('삭제'),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                              ElevatedButton(
                                child: Text('유지'),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ],
                          );
                        });
                    if (result) {
                      //Deleted
                      imageDismiss(imageCommentMap, value);
                    }
                  },
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          value: index,
                          child: Text(
                            "삭제",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                  child: Container(
                    child: cachedImage,
                    height: 200,
                    width: 200,
                  )),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                    border: OutlineInputBorder(),
                    labelText: "사진${index + 1}의 설명",
                    hintText: "내용을 입력하세요",
                  ),
                  controller: getTextEditingImageTextField(
                    index,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
