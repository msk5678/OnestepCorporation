import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/AboutPost/createPost.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
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
    // TODO: implement initState
    super.initState();
    alterPostData = widget.postData;
    textEditingControllerBottomSheet..text = alterPostData.title;
    textEditingControllerContent..text = alterPostData.textContent;
    imageCommentMap = alterPostData.imageCommentMap;
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
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        firstContainer(),
                        displayCurrentBoard(alterPostData.boardName),
                        setPostName(),
                        secondContainer(),
                        thirdContainer(),
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
          // )),
        ),
        TipDialogContainer(duration: const Duration(seconds: 2))
      ],
    );
  }

  @override
  thirdContainer(Map<String, dynamic> imgCommMap, {Widget popUpMenu}) {
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
    for (int i = 0; i < 5 - containImageCount; i++) {
      _emptyWidget.add(imageContainer());
    }
  }

  cachedImgWidget(String imageURL) {
    return CachedNetworkImage(imageUrl: imageURL);
  }
}
