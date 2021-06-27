import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postContent.dart';
import 'package:onestep_rezero/board/AboutPost/createPost.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  int firstImageCount = 0;

  @override
  void initState() {
    alterPostData = widget.postData;
    super.initState();

    textEditingControllerBottomSheet..text = alterPostData.title;
    textEditingControllerContent..text = alterPostData.textContent;
    imageCommentMap =
        Map<String, List<dynamic>>.from(alterPostData.imageCommentMap);
    firstImageCount = imageCommentMap["IMAGE"].length;
    imageCommentMap.update(
        "COMMENT",
        (value) => value
          ..addAll(List<String>.generate(
              maxImageCount - firstImageCount, (index) => "")));
    initImgCommentText(imageCommentMap);
    // getterImgCommentFromMapToTextEditingControl(imageCommentMap);
  }

  @override
  void dispose() {
    super.dispose();
  }

  initImgCommentText(Map<String, List<dynamic>> imgComment) {
    for (int i = 0; i < imgComment["COMMENT"].length; i++) {
      String commentText = imgComment["COMMENT"][i].toString();
      if (i == 0) {
        textEditingControllerImage1..text = commentText;
      } else if (i == 1) {
        textEditingControllerImage2..text = commentText;
      } else if (i == 2) {
        textEditingControllerImage3..text = commentText;
      } else if (i == 3) {
        textEditingControllerImage4..text = commentText;
      } else if (i == 4) {
        textEditingControllerImage5..text = commentText;
      } else {
        continue;
      }
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

          Future.delayed(Duration(seconds: 2)).then((value) {
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

    return await postData.updatePostData(context, updatedData, firstImageCount);
  }

  @override
  thirdContainer(Map<String, dynamic> imgCommMap) {
    List<Widget> _imageWidget = [];
    List<Widget> _emptyWidget = [];

    for (int i = 0; i < firstImageCount; i++) {
      if (imgCommMap["IMAGE"][i].runtimeType != String) {
        continue;
      }

      _imageWidget.add(Container(
          padding: EdgeInsets.all(5.0),
          child: imageContainer(i, cachedImgWidget(imgCommMap["IMAGE"][i]),
              imgCommMap["COMMENT"][i])));
    }

    for (int i = firstImageCount; i < imgCommMap["IMAGE"].length; i++) {
      if (imgCommMap["IMAGE"][i].runtimeType != AssetEntity) {
        continue;
      }

      if (imgCommMap["IMAGE"][i] != null)
        _imageWidget.add(Container(
            padding: EdgeInsets.all(5.0),
            child: imageContainer(
                i, imgCommMap["IMAGE"][i], imgCommMap["COMMENT"][i])));
    }

    for (int i = 0; i < maxImageCount - imgCommMap["IMAGE"].length; i++) {
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
    TextEditingController textEditingController;
    if (index == 0) {
      textEditingController = textEditingControllerImage1;
    } else if (index == 1) {
      textEditingController = textEditingControllerImage2;
    } else if (index == 2) {
      textEditingController = textEditingControllerImage3;
    } else if (index == 3) {
      textEditingController = textEditingControllerImage4;
    } else if (index == 4) {
      textEditingController = textEditingControllerImage5;
    }
    bool isCachedImage = false;
    if (index < firstImageCount)
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
                  maxLines: null,
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
    if (imageCommentMap["IMAGE"] != null) {
      if (imageCommentMap["IMAGE"].isNotEmpty)
        for (int i = firstImageCount;
            i < imageCommentMap["IMAGE"].length;
            i++) {
          resultList.add(imageCommentMap["IMAGE"][i]);
        }
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
        ) ??
        [];

    setState(() {
      // imageCommentMap["IMAGE"].add(resultList);
      // for (int i = firstImageCount; i < maxImageCount;i ++){
      //   imageCommentMap["IMAGE"][i]
      // }
      //   alterImageCommentMap.update("IMAGE", (value) => resultList);
      // if (imageCommentMap["IMAGE"].isNotEmpty) {
      //   imageCommentMap["IMAGE"].addAll(resultList);
      // } else
      imageCommentMap.update("IMAGE", (value) => value..addAll(_entity));
    });
  }

  @override
  emptyImageWidget(Map<String, dynamic> imgCommMap) {
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
                          child: Text('초기화'),
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
                        ElevatedButton(
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
                      firstImageCount = 0;
                      imageCommentMap["IMAGE"].clear();
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
  imageDismiss(Map<String, dynamic> imgCommMap, int selectedIndex) {
    setterImgCommentFromMapToTextEditingControl(imageCommentMap);
    var _undoImage = imgCommMap["IMAGE"][selectedIndex];
    String _undoComment = imgCommMap["COMMENT"][selectedIndex];
    bool isDeletedFirstImage = selectedIndex < firstImageCount;
    setState(() {
      if (isDeletedFirstImage) --firstImageCount;
      imageCommentMap["IMAGE"].removeAt(selectedIndex);
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
                if (isDeletedFirstImage) ++firstImageCount;
                setterImgCommentFromMapToTextEditingControl(imageCommentMap);
                imageCommentMap["IMAGE"].insert(selectedIndex, _undoImage);
                imageCommentMap["COMMENT"].insert(selectedIndex, _undoComment);
                imageCommentMap["COMMENT"].removeLast();
                getterImgCommentFromMapToTextEditingControl(imageCommentMap);
              });
            })));
  }
}
