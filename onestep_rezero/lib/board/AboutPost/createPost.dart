import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onestep_rezero/board/StateManage/firebase_GetUID.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/board/permissionLib.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';

enum ContentCategory { SMALLTALK, QUESTION }

// extension ContentCategoryExtension on ContentCategory {
//   String get category {
//     switch (this) {
//       case ContentCategory.QUESTION:
//         return "질문";
//       case ContentCategory.SMALLTALK:
//         return "일상";
//       default:
//         return throw CategoryException(
//             "Enum Category Error, Please Update Enum ContentCategory in parentState.dart");
//     }
//   }
// }

const int MAX_IMAGE_COUNT = 5;

class CreatePost extends StatefulWidget {
  final String currentBoardName;
  final String currentBoardId;
  CreatePost({Key key, this.currentBoardName, this.currentBoardId})
      : super(key: key);

  @override
  _CreateBoardState createState() => _CreateBoardState();
}

class _CreateBoardState extends _CreatePageParent<CreatePost> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  setBoardData() {
    boardName = widget.currentBoardName;
    boardId = widget.currentBoardId;
  }
}

abstract class _CreatePageParent<T extends StatefulWidget> extends State<T>
    with OneStepPermission {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // CustomSlideDialog customSlideDialog;
  double device_height;
  double device_width;
  ContentCategory _category;
  TextEditingController textEditingControllerBottomSheet;
  TextEditingController textEditingControllerContent;
  TextEditingController textEditingControllerImage1;
  TextEditingController textEditingControllerImage2;
  TextEditingController textEditingControllerImage3;
  TextEditingController textEditingControllerImage4;
  TextEditingController textEditingControllerImage5;
  PanelController panelController;

  ScrollController _scrollController;
  BoardData boardData;
  String boardName;
  String boardId;
  setBoardData();
  List<String> _initCommentList = ['', '', '', '', ''];
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
    imageCommentMap["COMMENT"].addAll(_initCommentList);
    super.initState();
    setBoardData();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    textEditingInitNDispose(true);
    _scrollController = new ScrollController();
    panelController = new PanelController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    device_width = MediaQuery.of(context).size.width;
    device_height = MediaQuery.of(context).size.height;
  }

  @override
  void dispose() {
    textEditingInitNDispose(false);
    _scrollController.dispose();

    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    print("CreatePost AssetThumb change to ConvertImages ");
    return Stack(
      children: <Widget>[
        Scaffold(
          body: WillPopScope(
              onWillPop: () {
                _isDataContain()
                    ? Navigator.pop(context)
                    : _navigatorPopAlertDialog();
              },
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Scaffold(
                  key: _scaffoldKey,
                  body: SlidingUpPanel(
                    controller: panelController,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    minHeight: device_height / 30,
                    maxHeight: device_height / 2.5,
                    panel: Column(
                      children: [
                        //Slider Gesture Widget
                        Center(
                            child: Container(
                                margin: EdgeInsets.only(top: 5),
                                height: device_height / 130,
                                width: device_width / 10,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))))),
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Container(
                            margin: EdgeInsets.only(left: 5, right: 5, top: 20),
                            child: Column(children: [
                              Container(
                                  child: Column(
                                children: [
                                  Container(
                                      child: TextField(
                                    maxLength: 30,
                                    onSubmitted: (value) {
                                      if (_category != null)
                                        panelController.close();
                                    },
                                    controller:
                                        textEditingControllerBottomSheet,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "제목"),
                                  )),
                                  Text(
                                    "앤터를 누르면 글쓰기 화면으로 전환됩니다.",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )),
                              RadioListTile(
                                  title: Text("일상"),
                                  value: ContentCategory.SMALLTALK,
                                  groupValue: _category,
                                  onChanged: (value) {
                                    setState(() {
                                      _category = value;
                                    });
                                  }),
                              RadioListTile(
                                  title: Text("질문"),
                                  value: ContentCategory.QUESTION,
                                  groupValue: _category,
                                  onChanged: (value) {
                                    setState(() {
                                      _category = value;
                                    });
                                  }),
                            ]),
                          );
                        }),
                      ],
                    ),
                    body: SafeArea(
                      minimum: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: <Widget>[
                              firstContainer(),
                              displayCurrentBoard(boardName: boardName),
                              secondContainer(),
                              thirdContainer(),
                              RaisedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                child: Text("hi"),
                              ),
                              SizedBox(
                                height: device_height / 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ),
        TipDialogContainer(duration: const Duration(seconds: 2))
      ],
    );
  }

  displayCurrentBoard({String boardName}) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text("게시되는 곳 : "),
            Text(
              "${boardName ?? ''}",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  firstContainer() {
    TextStyle _textStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () {
                _isDataContain()
                    ? Navigator.pop(context)
                    : _navigatorPopAlertDialog();
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
                if (panelController.isPanelOpen) {
                  panelController.close();
                  FocusScope.of(context).unfocus();
                } else
                  panelController.open();
              },
              child: Container(
                child: Text(
                  textEditingControllerBottomSheet.text == ''
                      ? "제목을 입력하세요."
                      : textEditingControllerBottomSheet.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle,
                ),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () async {
                var _result = _checkDataContain();
                if (_result.runtimeType == bool) {
                  if (_result) {
                    _saveDataInFirestore();
                  }
                } else if (_result.runtimeType == String) {
                  print(_result);
                  switch (_result.toString()) {
                    case "CONTENT":
                      _scaffoldKey.currentState.showSnackBar(
                          showSnackBar(textMessage: Text("내용을 입력하세요.")));
                      break;
                    case "CATEGORY":
                      _scaffoldKey.currentState.showSnackBar(
                          showSnackBar(textMessage: Text("카테고리 분류를 입력하세요.")));
                      break;
                    case "TITLE":
                      _scaffoldKey.currentState.showSnackBar(
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

  _saveDataInFirestore() async {
    TipDialogHelper.loading("저장 중입니다.\n 잠시만 기다려주세요.");
    // await saveData()
    //     .onError((error, stackTrace) {
    //       TipDialogHelper.fail("ERROR CODE : BOARD UPLOAD ERROR");
    //     })
    //     .then((value) => null)
    //     .whenComplete(() => null);

    // await saveData().whenComplete(() => null).then((value) => null);

    await saveData().then((value) {
      TipDialogHelper.dismiss();
      TipDialogHelper.success("저장 완료!");
      Future.delayed(Duration(seconds: 2))
          .then((value) => Navigator.pop(context, true));
    }).whenComplete(() {});
  }

  Future saveData() async {
    _getterSetterImageComment(isMapSet: true, isSave: true);
    BoardData _boardData = BoardData(
        title: textEditingControllerBottomSheet.text,
        imageCommentList: imageCommentMap,
        textContent: textEditingControllerContent.text,
        contentCategory: _category.toString(),
        boardName: boardName,
        boardId: boardId);
    return await _boardData.toFireStore(context);
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
        onTap: () {
          if (panelController.isPanelOpen) panelController.close();
        },
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

  _checkDataContain() {
    String content = textEditingControllerContent.text.trim();
    String title = textEditingControllerBottomSheet.text;
    if (title != null && title != '') {
      if (_category != null) {
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

  _isDataContain() {
    String content = textEditingControllerContent.text.trim();
    String title = textEditingControllerBottomSheet.text;
    if (title == null || title == '') {
      if (_category == null) {
        if (content == null || content == '') {
          if (imageCommentMap["IMAGE"].isEmpty) return true;
        }
      }
    }
    return false;
  }

  _navigatorPopAlertDialog() async {
    String result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작성 중'),
          content: Text("변경된 내용은 저장이 되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('나가기'),
              onPressed: () {
                // Navigator.of(context)
                //     .popUntil(ModalRoute.withName('/MainPage'));
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
            ),
            FlatButton(
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

  _imageContainer({int index, Asset imageAsset}) {
    return imageAsset != null
        ? Container(
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
                                    FlatButton(
                                      child: Text('삭제'),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('유지'),
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                    ),
                                  ],
                                );
                              });
                          if (result) {
                            _getterSetterImageComment(isMapSet: true);
                            Asset _undoImage = imageCommentMap["IMAGE"][value];
                            String _undoComment =
                                imageCommentMap["COMMENT"][value];
                            setState(() {
                              imageCommentMap["IMAGE"].removeAt(value);
                              imageCommentMap["COMMENT"].removeAt(value);
                              textEditingControllerImage5..text = '';
                              imageCommentMap["COMMENT"].add('');
                              _getterSetterImageComment(isMapSet: false);
                              // images.removeAt(value);
                            });
                            _scaffoldKey.currentState.showSnackBar(showSnackBar(
                                textMessage:
                                    Text("${value + 1}번째 이미지가 삭제되었습니다."),
                                duration: Duration(milliseconds: 1500),
                                snackBarAction: SnackBarAction(
                                    label: "되돌리기",
                                    onPressed: () {
                                      setState(() {
                                        // images.insert(index, _undoImage);
                                        _getterSetterImageComment(
                                            isMapSet: true);
                                        imageCommentMap["IMAGE"]
                                            .insert(value, _undoImage);
                                        imageCommentMap["COMMENT"]
                                            .insert(value, _undoComment);
                                        imageCommentMap["COMMENT"].removeLast();
                                        _getterSetterImageComment(
                                            isMapSet: false);
                                      });
                                    })));
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
                            child: AssetThumb(
                          asset: imageAsset,
                          height: 200,
                          width: 200,
                        ))),
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 5.0),
                          border: OutlineInputBorder(),
                          labelText: "사진${index + 1}의 설명",
                          hintText: "내용을 입력하세요",
                        ),
                        controller: _getTextEditingImageTextField(index)),
                  ),
                )
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(5.0),
            child: SizedBox(
              height: 50,
              width: 50,
              child: GestureDetector(
                  onTap: () async {
                    if (imageCommentMap["IMAGE"].isNotEmpty) {
                      bool isInit = await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('사진 작성 중'),
                            content: Text("작성중인 사진 및 설명이 있습니다. 초기화 하시겠습니까?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('초기화'),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                              FlatButton(
                                child: Text('유지'),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              FlatButton(
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
                            imageCommentMap["COMMENT"].addAll(_initCommentList);
                            _getterSetterImageComment(isMapSet: false);
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
    List<Asset> resultList = [];
    if (imageCommentMap["IMAGE"].isNotEmpty) {
      for (var image in imageCommentMap["IMAGE"]) {
        resultList.add(image);
      }
    }
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 5, enableCamera: true, selectedAssets: resultList);
    } on NoImagesSelectedException {}

    setState(() {
      imageCommentMap.update("IMAGE", (value) => resultList);
    });
  }

  _getterSetterImageComment({@required bool isMapSet, bool isSave}) {
    List<String> _tempTextEditing = [];
    isSave = isSave ?? false;
    int mapSetLength =
        !isSave ? MAX_IMAGE_COUNT : imageCommentMap["IMAGE"].length;
    if (isMapSet) {
      for (int i = 0; i < mapSetLength; i++) {
        _tempTextEditing.add(_getTextEditingImageTextField(i).text.trim());
      }
      imageCommentMap["COMMENT"].clear();
      imageCommentMap["COMMENT"].addAll(_tempTextEditing);
    } else {
      for (int i = 0; i < MAX_IMAGE_COUNT; i++) {
        _getTextEditingImageTextField(i)..text = imageCommentMap["COMMENT"][i];
      }
    }
  }

  TextEditingController _getTextEditingImageTextField(
    int index,
  ) {
    switch (index) {
      case 0:
        return textEditingControllerImage1;

      case 1:
        return textEditingControllerImage2;
      case 2:
        return textEditingControllerImage3;
      case 3:
        return textEditingControllerImage4;
      case 4:
        return textEditingControllerImage5;
    }
  }

  thirdContainer({Widget popUpMenu}) {
    List<Widget> _imageWidget = [];
    List<Widget> _emptyWidget = [];
    int containImageCount = imageCommentMap["IMAGE"].length;

    for (int i = 0; i < containImageCount; i++) {
      if (imageCommentMap["IMAGE"][i].runtimeType == String) {
        continue;
      }
      _imageWidget.add(
          _imageContainer(index: i, imageAsset: imageCommentMap["IMAGE"][i]));
    }
    for (int i = 0; i < 5 - containImageCount; i++) {
      _emptyWidget.add(_imageContainer());
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
}
