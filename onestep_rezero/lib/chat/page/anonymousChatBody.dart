import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:onestep_rezero/admob/googleAdmob.dart';
import 'package:onestep_rezero/chat/productchat/model/anonymousChatList.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/utils/onestepCustom/color/onestepAppColor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnonymousChatBody extends StatefulWidget {
  @override
  _AdmobListState createState() => _AdmobListState();
}

class _AdmobListState extends State<AnonymousChatBody> {
  List<AnonymousChatList> listAnonymousChat = [];

  final TextEditingController textContentController = TextEditingController();
  final TextEditingController textNickNameController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initNickNameTextField();
  }

  @override
  void dispose() {
    textContentController.dispose();
    textNickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: //
          Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: 0,
            ),
            child: Container(
              child: Column(
                children: [
                  Flexible(
                    flex: 10,
                    fit: FlexFit.tight,
                    child: _buildChatListListTileStream(),
                  ),
                  createInput(),
                  GoogleAdmob().getChatMainBottomBanner(deviceWidth),
                  // Flexible(
                  //   flex: 1,
                  //   fit: FlexFit.tight,
                  //   child:
                  // Positioned(
                  //   child:
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: createInput(),
                  // ),
                  // bottom: 50.h,
                  // ),
                  // ),
                  // Container(
                  //   color: Colors.lightBlue,
                  //   height: 50,
                  //   child: Text("admob"),
                  // ),
                  // Flexible(
                  //   flex: 1,
                  //   fit: FlexFit.tight,
                  //   child: Container(
                  //     // color: Colors.amber,
                  //     height: 50,
                  //     child: TextField(),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Positioned(
          //   child: Column(
          //     children: [
          //       createInput(),
          //       GoogleAdmob().getChatMainBottomBanner(deviceWidth),
          //     ],
          //   ),
          //   bottom: 0,
          // ),
        ],
      ),
    );
  }

  createInput() {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    Color _inputWidgetColor = Colors.grey;
    return Container(
      // height: deviceHeight / 16.h,
      width: deviceWidth,
      decoration: BoxDecoration(
        color: _inputWidgetColor,
      ),
      child: new ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: deviceHeight / 16.h,
          maxHeight: deviceHeight / 2.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              // color: Colors.black,
              // color: Colors.grey[300],
              height: deviceHeight / 16.h,
              width: deviceWidth / 5.w,
              child: Center(
                child: Container(
                  // color: Colors.amber,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      0,
                      0,
                      0,
                      4,
                    ),
                    child: TextField(
                      maxLength: 5,

                      // maxLengthEnforced: true,
                      cursorColor: OnestepColors().mainColor,
                      controller: textNickNameController,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        labelStyle: new TextStyle(
                          color: null,
                        ),
                        hintText: "    닉네임",
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        // border: new UnderlineInputBorder(
                        //   borderSide: new BorderSide(color: Colors.green),
                        // ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: _inputWidgetColor,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: _inputWidgetColor,
                          ),
                        ),
                        // border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Flexible(
            // flex: 3,
            // fit: FlexFit.tight,
            // child:
            Container(
              // color: Colors.red,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // minWidth: 200,
                  // maxWidth: 250,
                  maxWidth: deviceWidth / 1.3.w,

                  minHeight: deviceHeight / 27.h,
                  maxHeight: deviceHeight / 4.h,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    5,
                    3,
                    0,
                    0,
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    // onSubmitted: (value) {
                    //   print("search");
                    //   Fluttertoast.showToast(msg: "버튼클릭");
                    // },
                    onEditingComplete: () {
                      _checkTextField();
                    },
                    cursorColor: OnestepColors().mainColor,
                    enabled: true,
                    // maxLength: 80,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    controller: textContentController,
                    minLines: 1,
                    maxLines: 1,
                    // maxLines: 2,
                    // maxLength: 80,
                    decoration: InputDecoration.collapsed(
                      hintText: "채팅을 입력하세요.",
                      hintStyle: TextStyle(
                        // fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      // border: OutlineInputBorder(),
                    ),
                    focusNode: focusNode,
                  ),
                ),
              ),
              // ),
            ),
            // Container(
            //   color: Colors.blue,
            //   width: 10,
            //   height: 10,
            //   child: Spacer(),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                0,
                0,
                0,
                0,
              ),
              child: Container(
                // color: Colors.amber,
                // width: 15.w,
                // height: 15.h,
                child: IconButton(
                    splashColor: Colors.deepOrange,
                    icon: Icon(Icons.send),
                    color: OnestepColors().mainColor,
                    disabledColor: Colors.red,
                    onPressed: () {
                      _checkTextField();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatListListTileStream() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child("university")
                  .child(currentUserModel.university)
                  .child("chat")
                  .child("anonymouschat")
                  .child("testChatId")
                  .child("message")
                  .orderByChild("sendTime")
                  .startAt("1")
                  .limitToLast(50)
                  .onValue,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "단체 채팅방을 불러오고 있습니다..!",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );

                  default:
                    if (snapshot == null ||
                        !snapshot.hasData ||
                        snapshot.data.snapshot.value == null) {
                      return Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          // color: Colors.yellow,
                          child: Center(
                            child: Text("생성된 채팅이 없습니다..!\n\n 첫 채팅을 작성해주세요!"),
                          ),
                        ),
                      );
                    } else {
                      listAnonymousChat.clear();
                      DataSnapshot dataValues = snapshot.data.snapshot;
                      Map<dynamic, dynamic> values = dataValues.value;
                      values.forEach((key, values) {
                        listAnonymousChat
                            .add(AnonymousChatList.forMapSnapshot(values));
                      });
                      listAnonymousChat
                          .sort((b, a) => a.sendTime.compareTo(b.sendTime));
                      return Center(
                        child: Container(
                          color: Colors.white,
                          child: CustomScrollView(
                            reverse: true,
                            shrinkWrap: false,
                            slivers: <Widget>[
                              //Tap 하위일 경우 사용
                              // SliverOverlapInjector(
                              //   handle: NestedScrollView
                              //       .sliverOverlapAbsorberHandleFor(context),
                              // ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    var gettime =
                                        DateFormat("yy/MM/dd kk:mm").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(
                                            listAnonymousChat[index].sendTime),
                                      ),
                                    );
                                    var nickNameColor =
                                        listAnonymousChat[index].uid ==
                                                currentUserModel.uid
                                            ? OnestepAppColors().test3Color
                                            : Colors.blue;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 150,
                                                minWidth: 0,
                                              ),
                                              child: Text(
                                                listAnonymousChat[index]
                                                    .nickName,
                                                style: TextStyle(
                                                  color: nickNameColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10, height: 10),
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 200,
                                                minWidth: 0,
                                              ),
                                              child: Text(
                                                listAnonymousChat[index]
                                                    .content,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10, height: 10),
                                            Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    gettime,
                                                    // anonymousChat[index].sendTime,
                                                    style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // onLongPress: () {
                                        //   Fluttertoast.showToast(
                                        //       msg: "채팅 LongPress");
                                        // },
                                      ),
                                    );
                                  },
                                  childCount: listAnonymousChat.length,
                                ),
                              ),
                            ],
                            // ),
                          ),
                        ),
                      );
                    }
                }
              }),
        ),
      ],
    );
  }

  createAnonymousChat(String nickName) {
    final DatabaseReference anonymousChatReference = FirebaseDatabase.instance
        .reference()
        .child("university")
        .child(currentUserModel.university)
        .child("chat")
        .child("anonymouschat");
    String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    String chatId = "testChatId";
    //1. 익명채팅 접근
    DatabaseReference anonymousChatInfoReference = anonymousChatReference
        .child(chatId)
        .child("chatUsers")
        .child("uid")
        .child(currentUserModel.uid)
        .child("setTime")
        .child(messageId);
    //2. 닉네임 중복 검사 하고
    //2-1. 중복 없으면 리스트 닉네임 추가 -> 메세지 전송 O
    //2-2. 중복 있으면 사용 불가 -> 메세지 전송 X
    try {
      //중복검사 했다 치고
      anonymousChatInfoReference.set({
        "nickName": nickName,
      }).whenComplete(() {});
      // Fluttertoast.showToast(msg: "챗 생성 성공.");
    } catch (e) {
      // Fluttertoast.showToast(msg: "$e 챗 생성 에러.");

    }
  }

  _initNickNameTextField() {
    textNickNameController.text =
        getAnonymousChatUserNickName(textNickNameController.text);
  }

  _checkTextField() {
    if (textNickNameController.text == "")
      Fluttertoast.showToast(msg: "닉네임을 입력해주세요.");
    else if (textContentController.text == "")
      Fluttertoast.showToast(msg: "채팅을 입력해주세요.");
    else {
      setAnonymousChatUserNickName(textNickNameController.text);
      createAnonymousChatMessage(
        textNickNameController.text,
        textContentController.text,
      );
      _clearTextField();
    }
  }

  _clearTextField() {
    // textnickNameController.clear();
    textContentController.clear();
  }

  String getAnonymousChatUserNickName(String anonymousChatNickName) {
    String nickName;
    if (Hive.box('localChatList')
            .get('anonymousChatNickName + ${currentUserModel.uid}') !=
        null) {
      nickName = Hive.box('localChatList')
          .get('anonymousChatNickName + ${currentUserModel.uid}');
      return nickName;
    } else
      return "";
  }

  void setAnonymousChatUserNickName(String anonymousChatNickName) {
    if (Hive.box('localChatList')
                .get('anonymousChatNickName + ${currentUserModel.uid}') ==
            null ||
        Hive.box('localChatList')
                .get('anonymousChatNickName + ${currentUserModel.uid}') !=
            anonymousChatNickName) {
      Hive.box('localChatList').put(
          'anonymousChatNickName + ${currentUserModel.uid}',
          anonymousChatNickName);
    }
  }

  createAnonymousChatMessage(String nickName, String content) {
    final DatabaseReference anonymousChatReference = FirebaseDatabase.instance
        .reference()
        .child("university")
        .child(currentUserModel.university)
        .child("chat")
        .child("anonymouschat");
    String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    String chatId = "testChatId";

    DatabaseReference anonymousChatMessageReference =
        anonymousChatReference.child(chatId).child("message").child(messageId);

    try {
      anonymousChatMessageReference.set({
        "idFrom": {"uid": currentUserModel.uid, "nickName": nickName},
        "sendTime": messageId,
        "content": content,
      }).whenComplete(() {});
      // Fluttertoast.showToast(msg: "챗 생성 성공.");
    } catch (e) {
      // Fluttertoast.showToast(msg: "$e 챗 생성 에러.");

    }
  }

  // Widget _admobList() {
  //   return CustomScrollView(
  //     shrinkWrap: false,
  //     // anchor: 0.5,
  //     // dragStartBehavior: DragStartBehavior.down,
  //     slivers: <Widget>[
  //       SliverOverlapInjector(
  //         handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  //       ),
  //       SliverList(
  //         delegate: SliverChildBuilderDelegate(
  //           (context, index) {
  //             return ListTile(
  //                 title: Column(
  //                   children: [
  //                     // Container(
  //                     //   color: Colors.amber,
  //                     //   height: 40,
  //                     // ),
  //                     // Divider(),
  //                     Container(
  //                         color: Colors.pink, child: Text('Item #$index')),
  //                   ],
  //                 ),
  //                 onTap: () {
  //                   print("ge");
  //                 });
  //           },
  //           childCount: 20,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
