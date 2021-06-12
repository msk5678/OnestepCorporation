import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/AboutPost/createPost.dart';
import 'package:onestep_rezero/board/TipDialog/tip_dialog.dart';
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
    // TODO: implement setBoardData
    throw UnimplementedError();
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
              child:
                  // Scaffold(
                  //   key: _scaffoldKey,
                  //   body: SlidingUpPanel(
                  //     controller: panelController,
                  //     borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(10.0),
                  //         topRight: Radius.circular(10.0)),
                  //     minHeight: device_height / 30,
                  //     maxHeight: device_height / 2.5,
                  //     panel: Column(
                  //       children: [
                  //         //Slider Gesture Widget
                  //         Center(
                  //             child: Container(
                  //                 margin: EdgeInsets.only(top: 5),
                  //                 height: device_height / 130,
                  //                 width: device_width / 10,
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.grey[300],
                  //                     borderRadius:
                  //                         BorderRadius.all(Radius.circular(5))))),
                  //         StatefulBuilder(builder:
                  //             (BuildContext context, StateSetter setState) {
                  //           return Container(
                  //             margin: EdgeInsets.only(left: 5, right: 5, top: 20),
                  //             child: Column(children: [
                  //               Container(
                  //                   child: Column(
                  //                 children: [
                  //                   Container(
                  //                       child: TextField(
                  //                     maxLength: 30,
                  //                     onSubmitted: (value) {
                  //                       if (_category != null)
                  //                         panelController.close();
                  //                     },
                  //                     controller:
                  //                         textEditingControllerBottomSheet,
                  //                     decoration: InputDecoration(
                  //                         border: OutlineInputBorder(),
                  //                         labelText: "제목"),
                  //                   )),
                  //                   Text(
                  //                     "앤터를 누르면 글쓰기 화면으로 전환됩니다.",
                  //                     style: TextStyle(color: Colors.grey),
                  //                   ),
                  //                 ],
                  //               )),
                  //               RadioListTile(
                  //                   title: Text("일상"),
                  //                   value: ContentCategory.SMALLTALK,
                  //                   groupValue: _category,
                  //                   onChanged: (value) {
                  //                     setState(() {
                  //                       _category = value;
                  //                     });
                  //                   }),
                  //               RadioListTile(
                  //                   title: Text("질문"),
                  //                   value: ContentCategory.QUESTION,
                  //                   groupValue: _category,
                  //                   onChanged: (value) {
                  //                     setState(() {
                  //                       _category = value;
                  //                     });
                  //                   }),
                  //             ]),
                  //           );
                  //         }),
                  //       ],
                  //     ),
                  // body:
                  SafeArea(
                minimum: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        firstContainer(),
                        displayCurrentBoard(currentBoardData.boardName),
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
}
