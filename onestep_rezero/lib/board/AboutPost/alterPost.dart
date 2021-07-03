import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postContent.dart';
import 'package:onestep_rezero/board/AboutPost/createPost.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AlterPost extends StatefulWidget {
  final postData;
  AlterPost({Key key, this.postData}) : super(key: key);

  @override
  _AlterPostState createState() => _AlterPostState();
}

class _AlterPostState extends CreatePageParent<AlterPost> {
  PostData alterPostData;
  final bool isAlterPage = true;

  @override
  void initState() {
    alterPostData = widget.postData;
    super.initState();

    textEditingControllerBottomSheet..text = alterPostData.title;
    textEditingControllerContent..text = alterPostData.textContent;
    imageCommentMap =
        Map<String, List<dynamic>>.from(alterPostData.imageCommentMap);
    imageCommentMap.addAll({"ALTERIMAGE": <AssetEntity>[]});

    imageCommentMap.update(
        "COMMENT",
        (value) => value
          ..addAll(List<String>.generate(
              maxImageCount - imageCommentMap["IMAGE"].length, (index) => "")));
    initImgCommentText(imageCommentMap);
    // getterImgCommentFromMapToTextEditingControl(imageCommentMap);
  }

  @override
  void dispose() {
    for (int i = imageCommentMap["IMAGE"].length;
        i < imageCommentMap["ALTERIMAGE"].length;
        i++) {
      imageCommentMap["COMMENT"].removeAt(imageCommentMap["IMAGE"].length);
    }

    imageCommentMap.remove("ALTERIMAGE");

    super.dispose();
  }

  initImgCommentText(Map<String, List<dynamic>> imgComment) {
    for (int i = 0; i < imgComment["COMMENT"].length; i++) {
      String commentText = imgComment["COMMENT"][i].toString();
      TextEditingController textEditingController =
          getTextEditingImageTextField(i);
      if (textEditingController != null) {
        textEditingController..text = commentText;
      }

      // if (i == 0) {
      //   textEditingControllerImage1..text = commentText;
      // } else if (i == 1) {
      //   textEditingControllerImage2..text = commentText;
      // } else if (i == 2) {
      //   textEditingControllerImage3..text = commentText;
      // } else if (i == 3) {
      //   textEditingControllerImage4..text = commentText;
      // } else if (i == 4) {
      //   textEditingControllerImage5..text = commentText;
      // } else {
      //   continue;
      // }
    }
  }

  @override
  setBoardData() {
    currentBoardData = new BoardData(
        boardId: alterPostData.boardId, boardName: alterPostData.boardName);
  }

  @override
  Widget build(BuildContext context) {
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
        TipDialogContainer(duration: const Duration(seconds: 1))
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
    FocusScope.of(context).unfocus();
    TipDialogHelper.loading("수정 중!\n 잠시만 기다려주세요.");

    await updateData(alterPostData).then((value) {
      if (value.runtimeType == bool) {
        if (value) {
          TipDialogHelper.dismiss();
          TipDialogHelper.success("수정 완료!");

          Future.delayed(Duration(seconds: 1)).then((value) {
            Navigator.pop(context, true);
            context.read(postProvider).getLatestPostData(alterPostData);
          });

          return;
        }
      }
      Navigator.pop(context, false);
      return;
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

    for (int i = 0; i < imgCommMap["IMAGE"].length; i++) {
      _imageWidget.add(Container(
          padding: EdgeInsets.all(5.0),
          child: imageContainer(i, cachedImgWidget(imgCommMap["IMAGE"][i]),
              imgCommMap["COMMENT"][i])));
    }

    for (int i = imgCommMap["IMAGE"].length;
        i < imgCommMap["ALTERIMAGE"].length;
        i++) {
      if (imgCommMap["ALTERIMAGE"][i] != null)
        _imageWidget.add(Container(
            padding: EdgeInsets.all(5.0),
            child: imageContainer(
                i, imgCommMap["ALTERIMAGE"][i], imgCommMap["COMMENT"][i])));
    }

    for (int i = 0;
        i <
            maxImageCount -
                imgCommMap["IMAGE"].length -
                imgCommMap["ALTERIMAGE"].length;
        i++) {
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
    if (imageURL != null)
      return CachedNetworkImage(
          imageUrl: imageURL,
          placeholder: (context, url) => CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
              ));
    else
      return Container();
  }

  @override
  imageContainer(int index, image, String comment) {
    var style = ElevatedButton.styleFrom(
        elevation: 0, primary: OnestepColors().secondColor);
    TextEditingController textEditingController =
        getTextEditingImageTextField(index);

    // if (index == 0) {
    //   textEditingController = textEditingControllerImage1;
    // } else if (index == 1) {
    //   textEditingController = textEditingControllerImage2;
    // } else if (index == 2) {
    //   textEditingController = textEditingControllerImage3;
    // } else if (index == 3) {
    //   textEditingController = textEditingControllerImage4;
    // } else if (index == 4) {
    //   textEditingController = textEditingControllerImage5;
    // }
    bool isCachedImage = false;
    if (index < imageCommentMap["IMAGE"].length)
      isCachedImage = true;
    else
      isCachedImage = false;
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
                                    style: style,
                                    child: Text('삭제'),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: style,
                                    child: Text('유지'),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  ),
                                ],
                              );
                            }) ??
                        false;

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
                  child: isCachedImage
                      ? Container(
                          child: image,
                          height: 200,
                          width: 200,
                        )
                      : Container(
                          child: Image(
                            width: 200,
                            height: 200,
                            image: AssetEntityImageProvider(image,
                                isOriginal: false),
                            fit: BoxFit.cover,
                          ),
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
                  maxLines: 4,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                    border: OutlineInputBorder(),
                    labelText: "사진${index + 1}의 설명",
                    hintText: "내용을 입력하세요",
                  ),
                  controller: textEditingController),
            ),
          )
        ],
      ),
    );
  }

  getImage() async {
    List<AssetEntity> resultList = [];

    if (imageCommentMap["ALTERIMAGE"].isNotEmpty)
      for (int i = 0; i < imageCommentMap["ALTERIMAGE"].length; i++) {
        resultList.add(imageCommentMap["ALTERIMAGE"][i]);
      }

    final List<AssetEntity> _entity = await AssetPicker.pickAssets(
      context,
      maxAssets: 5 - imageCommentMap["IMAGE"].length,
      pageSize: 330,
      pathThumbSize: 80,
      gridCount: 3,
      requestType: RequestType.image,
      selectedAssets: resultList,
      specialPickerType: SpecialPickerType.wechatMoment,
      textDelegate: KoreaTextDelegate(),
    );

    if (_entity != null)
      setState(() {
        imageCommentMap.update("ALTERIMAGE", (value) => (_entity));
      });
  }

  @override
  emptyImageWidget(Map<String, dynamic> imgCommMap) {
    var style = ElevatedButton.styleFrom(
        elevation: 0, primary: OnestepColors().secondColor);
    return Container(
      padding: EdgeInsets.all(5.0),
      child: SizedBox(
        height: 50,
        width: 50,
        child: GestureDetector(
            onTap: () async {
              if (imgCommMap["IMAGE"].isNotEmpty) {
                bool isInit = await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('사진 작성 중'),
                      content: Text("작성중인 사진 및 설명이 있습니다. 초기화 하시겠습니까?"),
                      actions: <Widget>[
                        ElevatedButton(
                          style: style,
                          child: Text('초기화'),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        ElevatedButton(
                          style: style,
                          child: Text('유지'),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                        ElevatedButton(
                          style: style,
                          child: Text('취소'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (isInit != null) {
                  if (isInit) {
                    setState(() {
                      imageCommentMap["IMAGE"].clear();
                      imageCommentMap["ALTERIMAGE"].clear();
                      imageCommentMap["COMMENT"] = initCommentList;

                      getterImgCommentFromMapToTextEditingControl(
                          imageCommentMap);
                    });
                  }
                  checkCamStorePermission(getImage);
                }
              } else {
                checkCamStorePermission(getImage);
              }
            },
            child: Container(
              child: Icon(Icons.add),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
            )),
      ),
    );
  }

  @override
  setterImgCommentFromMapToTextEditingControl(Map<String, dynamic> imgCommMap) {
    List<String> _tempTextEditing = [];
    int mapSetLength = imgCommMap["IMAGE"].length;
    int mapSetAlterLength = imgCommMap["ALTERIMAGE"].length;
    for (int i = 0; i < mapSetLength; i++) {
      _tempTextEditing.add(getTextEditingImageTextField(i).text.trim());
    }
    for (int i = mapSetLength; i < mapSetAlterLength; i++) {
      _tempTextEditing.add(getTextEditingImageTextField(i).text.trim());
    }
    imageCommentMap["COMMENT"].clear();
    imageCommentMap["COMMENT"].addAll(_tempTextEditing
      ..addAll(List<String>.generate(
          maxImageCount - mapSetLength - mapSetAlterLength, (index) => "")));
  }

  @override
  imageDismiss(Map<String, dynamic> imgCommMap, int selectedIndex) {
    setterImgCommentFromMapToTextEditingControl(imageCommentMap);
    var _undoImage;
    bool isDismissSaveImage;
    if (selectedIndex < imageCommentMap["IMAGE"].length) {
      _undoImage = imgCommMap["IMAGE"][selectedIndex];
      isDismissSaveImage = true;
    } else {
      _undoImage = imgCommMap["ALTERIMAGE"][selectedIndex];
      isDismissSaveImage = false;
    }
    String _undoComment = imgCommMap["COMMENT"][selectedIndex];

    setState(() {
      if (isDismissSaveImage)
        imageCommentMap["IMAGE"].removeAt(selectedIndex);
      else
        imageCommentMap["ALTERIMAGE"].removeAt(selectedIndex);
      //setting comment List
      imageCommentMap["COMMENT"] = imgCommMap["COMMENT"]
        ..removeAt(selectedIndex);
      imageCommentMap["COMMENT"].add("");
      textEditingControllerImage5..text = '';
      getterImgCommentFromMapToTextEditingControl(imageCommentMap);
    });
    ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
        textMessage: Text("${selectedIndex + 1}번째 이미지가 삭제되었습니다."),
        duration: Duration(milliseconds: 1500),
        snackBarAction: SnackBarAction(
            label: "되돌리기",
            onPressed: () {
              setState(() {
                setterImgCommentFromMapToTextEditingControl(imageCommentMap);
                if (isDismissSaveImage)
                  imageCommentMap["IMAGE"].insert(selectedIndex, _undoImage);
                else
                  imageCommentMap["ALTERIMAGE"]
                      .insert(selectedIndex, _undoImage);
                imageCommentMap["COMMENT"].insert(selectedIndex, _undoComment);
                imageCommentMap["COMMENT"].removeLast();
                getterImgCommentFromMapToTextEditingControl(imageCommentMap);
              });
            })));
  }
}
