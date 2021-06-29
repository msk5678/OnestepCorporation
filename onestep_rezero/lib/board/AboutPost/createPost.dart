import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';

import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/board/permissionLib.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreatePost extends StatefulWidget {
  final currentBoardData;
  CreatePost({Key key, this.currentBoardData}) : super(key: key);

  @override
  _CreateBoardState createState() => _CreateBoardState();
}

class _CreateBoardState extends CreatePageParent<CreatePost> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  setBoardData() {
    currentBoardData = widget.currentBoardData;
  }
}

abstract class CreatePageParent<T extends StatefulWidget> extends State<T>
    with OneStepPermission {
  // CustomSlideDialog customSlideDialog;
  final int maxImageCount = 5;
  double deviceHeight;
  double deviceWidth;
  ContentCategory category = ContentCategory.SMALLTALK;
  TextEditingController textEditingControllerBottomSheet;
  TextEditingController textEditingControllerContent;
  TextEditingController textEditingControllerImage1;
  TextEditingController textEditingControllerImage2;
  TextEditingController textEditingControllerImage3;
  TextEditingController textEditingControllerImage4;
  TextEditingController textEditingControllerImage5;

  ScrollController scrollController;
  FixedExtentScrollController categoryPickerController;
  BoardData currentBoardData;
  setBoardData();
  List<String> initCommentList = ['', '', '', '', ''];
  Map<String, List<dynamic>> imageCommentMap = {"IMAGE": [], "COMMENT": []};

  textEditingInitNDispose(bool isInit) {
    if (isInit) {
      textEditingControllerBottomSheet = new TextEditingController();
      textEditingControllerContent = new TextEditingController();
      textEditingControllerImage1 = new TextEditingController();
      textEditingControllerImage2 = new TextEditingController();
      textEditingControllerImage3 = new TextEditingController();
      textEditingControllerImage4 = new TextEditingController();
      textEditingControllerImage5 = new TextEditingController();
    } else {
      textEditingControllerBottomSheet.dispose();
      textEditingControllerContent.dispose();
      textEditingControllerImage1.dispose();
      textEditingControllerImage2.dispose();
      textEditingControllerImage3.dispose();
      textEditingControllerImage4.dispose();
      textEditingControllerImage5.dispose();
    }
  }

  @override
  void initState() {
    imageCommentMap["COMMENT"].addAll(initCommentList);
    super.initState();
    setBoardData();
    textEditingInitNDispose(true);
    scrollController = new ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
  }

  @override
  void dispose() {
    textEditingInitNDispose(false);
    scrollController.dispose();

    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
                  ? Navigator.pop(context, false)
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
                      // Container(
                      //     padding: EdgeInsets.symmetric(vertical: 3),
                      //     alignment: Alignment.bottomLeft,
                      //     width: deviceWidth / 3,
                      //     child: postCategory(
                      //         ContentCategory.values, deviceHeight, category)),
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

  postCategory(
      List<ContentCategory> categoryList, double deviceheight, initData) {
    if (initData == null) category = categoryList[0];
    return CupertinoPicker(
      // scrollController: FixedExtentScrollController(initialItem: 0),
      itemExtent: deviceheight / 20,
      children: <Widget>[
        for (int i = 0; i < categoryList.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(categoryList[i].categoryData.icon),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  categoryList[i].categoryData.title,
                  style: TextStyle(color: OnestepColors().mainColor),
                ),
              )
            ],
          ),
      ],
      onSelectedItemChanged: (int index) => category = categoryList[index],
      looping: true,
    );

    // return CupertinoPicker(
    //     itemExtent: category.length.toDouble(),
    //     onSelectedItemChanged: (int index) {},
    //     children: [
    //       for (int i = 0; i < category.length; i++)
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             // BuildingProblem.problemListIcons[i],
    //             Padding(
    //               padding: EdgeInsets.only(left: 10),
    //               child: Text(
    //                 category[i].toString(),
    //                 style: TextStyle(color: Colors.white70),
    //               ),
    //             )
    //           ],
    //         ),
    //     ]);
  }

  displayCurrentBoard(String name) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text("게시되는 곳 : "),
            Text(
              "${name ?? ''}",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  setPostName(double deviceHeight) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: deviceHeight / 10,
      child: TextField(
        controller: textEditingControllerBottomSheet,
        maxLength: 30,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '제목을 입력하세요.',
        ),
      ),
    );
  }

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

  saveDataInFirestore() async {
    FocusScope.of(context).unfocus();
    TipDialogHelper.loading("저장 중!\n 잠시만 기다려주세요.");

    await saveData().then((value) {
      if (value.runtimeType == bool) {
        if (value) {
          TipDialogHelper.dismiss();
          TipDialogHelper.success("저장 완료!");
          Future.delayed(Duration(seconds: 1))
              .then((value) => Navigator.pop(context, true));
          return;
        }
      }
      Navigator.pop(context, false);
      return;
      // TipDialogHelper.dismiss();
      // TipDialogHelper.success("저장 완료!");
      // Future.delayed(Duration(seconds: 2))
      //     .then((value) => Navigator.pop(context, true));
      // return true;
    }).whenComplete(() {});
  }

  Future saveData() async {
    setterImgCommentFromMapToTextEditingControl(imageCommentMap);

    PostData _postData = PostData(
        title: textEditingControllerBottomSheet.text,
        imageCommentMap: imageCommentMap,
        textContent: textEditingControllerContent.text,
        contentCategory: category.toString(),
        boardName: currentBoardData.boardName,
        boardId: currentBoardData.boardId);
    return await _postData.toFireStore(context);
  }

  showSnackBar(
      {@required Text textMessage,
      SnackBarAction snackBarAction,
      Duration duration}) {
    return SnackBar(
      duration: duration ?? Duration(milliseconds: 500),
      action: snackBarAction ?? null,
      content: textMessage,
    );
  }

  secondContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: textEditingControllerContent,
        minLines: 20,
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "",
          hintText: "내용을 입력하세요",
        ),
      ),
    );
  }

  checkDataContain() {
    String content = textEditingControllerContent.text.trim();
    String title = textEditingControllerBottomSheet.text;
    if (title != null && title != '') {
      if (category != null) {
        if (content != null && content != '') {
          return true;
        } else {
          return "CONTENT";
        }
      } else {
        return "CATEGORY";
      }
    } else {
      return "TITLE";
    }
  }

  isDataContain() {
    String content = textEditingControllerContent.text.trim();
    String title = textEditingControllerBottomSheet.text;
    if (title == null || title == '') {
      if (category == null) {
        if (content == null || content == '') {
          if (imageCommentMap["IMAGE"].isEmpty) return true;
        }
      }
    }
    return false;
  }

  navigatorPopAlertDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작성 중'),
          content: Text("변경된 내용은 저장이 되지 않습니다."),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0, primary: OnestepColors().secondColor),
              child: Text('나가기'),
              onPressed: () {
                // Navigator.of(context)
                //     .popUntil(ModalRoute.withName('/MainPage'));
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0, primary: OnestepColors().secondColor),
              child: Text('유지'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  imageContainer(int index, image, String comment) {
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
                    child: Image(
                      width: 200,
                      height: 200,
                      image: AssetEntityImageProvider(image, isOriginal: false),
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
                  controller: getTextEditingImageTextField(
                    index,
                  )),
            ),
          )
        ],
      ),
    );
  }

  imageDismiss(Map<String, dynamic> imgCommMap, int selectedIndex) {
    setterImgCommentFromMapToTextEditingControl(imageCommentMap);
    AssetEntity _undoImage = imgCommMap["IMAGE"][selectedIndex];
    String _undoComment = imgCommMap["COMMENT"][selectedIndex];
    setState(() {
      imageCommentMap["IMAGE"].removeAt(selectedIndex);
      imageCommentMap["COMMENT"].removeAt(selectedIndex);
      textEditingControllerImage5..text = '';
      imageCommentMap["COMMENT"].add('');
      getterImgCommentFromMapToTextEditingControl(imageCommentMap);
      // images.removeAt(value);
    });
    FocusScope.of(context).requestFocus(FocusNode());
    ScaffoldMessenger.of(context).showSnackBar(showSnackBar(
        textMessage: Text("${selectedIndex + 1}번째 이미지가 삭제되었습니다."),
        duration: Duration(milliseconds: 1500),
        snackBarAction: SnackBarAction(
            label: "되돌리기",
            onPressed: () {
              setState(() {
                setterImgCommentFromMapToTextEditingControl(imageCommentMap);
                imageCommentMap["IMAGE"].insert(selectedIndex, _undoImage);
                imageCommentMap["COMMENT"].insert(selectedIndex, _undoComment);
                imageCommentMap["COMMENT"].removeLast();
                getterImgCommentFromMapToTextEditingControl(imageCommentMap);
              });
              FocusScope.of(context).requestFocus(FocusNode());
            })));
  }

  emptyImageWidget(Map<String, dynamic> imgCommMap) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: SizedBox(
        height: 50,
        width: 50,
        child: GestureDetector(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
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
                      imageCommentMap["IMAGE"].clear();
                      imageCommentMap["COMMENT"].clear();

                      imageCommentMap["COMMENT"].addAll(initCommentList);
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

  getImage() async {
    List<AssetEntity> resultList = [];
    if (imageCommentMap["IMAGE"] != null) {
      if (imageCommentMap["IMAGE"].isNotEmpty)
        for (var image in imageCommentMap["IMAGE"]) {
          resultList.add(image);
        }
    }
    final List<AssetEntity> _entity = await AssetPicker.pickAssets(
          context,
          maxAssets: 5,
          pageSize: 330,
          pathThumbSize: 80,
          gridCount: 3,
          requestType: RequestType.image,
          selectedAssets: resultList,
          specialPickerType: SpecialPickerType.wechatMoment,
          textDelegate: KoreaTextDelegate(),
        ) ??
        [];

    if (mounted) {
      setState(() {
        imageCommentMap.update("IMAGE", (value) => _entity);
      });
    }
  }

  thirdContainer(Map<String, dynamic> imgCommMap) {
    List<Widget> _imageWidget = [];
    List<Widget> _emptyWidget = [];
    int containImageCount =
        imgCommMap["IMAGE"] != null ? imgCommMap["IMAGE"].length : 0;

    for (int i = 0; i < containImageCount; i++) {
      if (imgCommMap["IMAGE"][i].runtimeType == String) {
        //Continue Check Plz
        continue;
      }
      _imageWidget.add(imageContainer(
        i,
        imgCommMap["IMAGE"][i],
        imgCommMap["COMMENT"][i],
      ));
    }
    for (int i = 0; i < 5 - containImageCount; i++) {
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

  getterImgCommentFromMapToTextEditingControl(
    Map<String, dynamic> imgCommMap,
  ) {
    for (int i = 0; i < imgCommMap["COMMENT"].length; i++) {
      TextEditingController textEditingController;
      textEditingController = getTextEditingImageTextField(i);
      if (textEditingController != null)
        getTextEditingImageTextField(
          i,
        )..text = imgCommMap["COMMENT"][i];
    }
  }

  setterImgCommentFromMapToTextEditingControl(
    Map<String, dynamic> imgCommMap,
  ) {
    List<String> _tempTextEditing = [];
    int mapSetLength = imgCommMap["IMAGE"].length;

    for (int i = 0; i < mapSetLength; i++) {
      _tempTextEditing.add(getTextEditingImageTextField(i).text.trim());
    }
    imageCommentMap["COMMENT"].clear();
    imageCommentMap["COMMENT"].addAll(_tempTextEditing
      ..addAll(
          List<String>.generate(maxImageCount - mapSetLength, (index) => "")));
  }

  getTextEditingImageTextField(
    int index,
  ) {
    if (index == 0)
      return textEditingControllerImage1;
    else if (index == 1)
      return textEditingControllerImage2;
    else if (index == 2)
      return textEditingControllerImage3;
    else if (index == 3)
      return textEditingControllerImage4;
    else if (index == 4)
      return textEditingControllerImage5;
    else
      return null;
  }
}
