import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMessage.dart';
import 'package:onestep_rezero/chat/widget/FullmageWidget.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/chat/widget/message_list_time.dart';
import 'package:onestep_rezero/chat/widget/productChatMenu.dart';
import 'package:onestep_rezero/main.dart';

import 'dart:io' as io;

import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/pages/product/productDetail.dart';

class ProductChattingRoomPage extends StatefulWidget {
  final String myUid;
  final String friendId;
  final String postId;
  final Product product;

  ProductChattingRoomPage(
      {this.myUid, this.friendId, this.postId, this.product});

  @override
  _ProductChattingRoomPageState createState() =>
      _ProductChattingRoomPageState();
}

class _ProductChattingRoomPageState extends State<ProductChattingRoomPage> {
  final StreamController<int> streamController = new StreamController<int>();
  int flags = 0;

  @override
  void dispose() {
    super.dispose();
    streamController.close();
    print("채팅방 디스포즈");
  }

  @override
  void initState() {
    super.initState();
    // print("채팅방 입장");
  }

  @override
  Widget build(BuildContext context) {
    print("포커스 빌드 다시됨");

    return
        // WillPopScope(
        //   onWillPop:
        //       // onBackPress,

        //       () {
        //     print("키보드 상단 해제");
        //     return Future(() => false);
        //   },
        //   child:
        Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.lightBlue,
      //   actions: <Widget>[
      //     ProductChatMenu().getProductMenu(context),
      //     //1. 메뉴 UX 향후 구현, dropdown 메뉴 우선 구현
      //     // Stack(
      //     //   children: <Widget>[
      //     //     StreamBuilder(
      //     //       initialData: 0,
      //     //       stream: streamController.stream,
      //     //       builder: (context, snapshot) {
      //     //         return flags % 2 == 0
      //     //             ? Positioned(
      //     //                 top: 30.0,
      //     //                 // right: 10.0,
      //     //                 // width: 10.0,
      //     //                 // height: 10.0,
      //     //                 left: 30,
      //     //                 child: Container(
      //     //                   width: 300,
      //     //                   height: 60,
      //     //                   color: Colors.red,
      //     //                   child: Text("짝수 $flags"),
      //     //                   decoration: BoxDecoration(
      //     //                     shape: BoxShape.circle,
      //     //                     //color: AppColors.notification,
      //     //                   ),
      //     //                 ),
      //     //               )
      //     //             : Text("홀수 $flags");
      //     //       },
      //     //     ),
      //     //     _buildjson(context),
      //     //     // Text(flags.toString()),
      //     //     // flags == 0 ? Text("0") : Text("1"),
      //     //   ],
      //     // ),

      //     // CircleAvatar(
      //     //   backgroundColor: Colors.black,
      //     //   //backgroundImage: CachedNetworkImageProvider(),
      //     // ),

      //     //_deleteChattingRoom(context), //삭제 다시 구현
      //   ],
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       Text("real"),
      //       Text(
      //         "myUid : ${widget.myUid}",
      //         style: TextStyle(fontSize: 9),
      //       ),
      //       Text(
      //         "friendId : ${widget.friendId}",
      //         style: TextStyle(fontSize: 9),
      //       ),
      //       Text(
      //         "postId : ${widget.postId}",
      //         style: TextStyle(fontSize: 9),
      //       ),
      //       widget.product == null
      //           ? Text(
      //               "챗리스트에서 옴",
      //               style: TextStyle(fontSize: 9),
      //             )
      //           : Text(
      //               "${widget.product.title.toString()}",
      //               style: TextStyle(fontSize: 9),
      //             ),
      //     ],
      //   ),
      // ),
      body: ChatScreen(
        myUid: widget.myUid,
        friendId: widget.friendId,
        postId: widget.postId,
        product: widget.product,
      ),
      // ),
    );
  }

//   Widget _buildjson(var context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         IconButton(
//             icon: Icon(Icons.ac_unit),
//             onPressed: () {
//               //productChat.toJson();
//               print("JSON 실행");
//               flags % 2 == 0
//                   ? streamController.sink.add(++flags)
//                   : streamController.sink.add(--flags);
// //              database.child("test").set(productChat.toJson());

//               //print(productChat.toJson());
//             }),
//         Positioned(
//           // top: 12.0,
//           // right: 10.0,
//           // width: 10.0,
//           // height: 10.0,
//           left: 300,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               //color: AppColors.notification,
//             ),
//           ),
//         )
//       ],
//     );
//   }

}

class ChatScreen extends StatefulWidget {
  final String myUid;
  final String friendId;
  final String postId;
  final Product product;

  ChatScreen({
    Key key,
    @required this.myUid,
    @required this.friendId,
    @required this.postId,
    @required this.product,
  }) : super(key: key);

  @override
  _LastChatState createState() => _LastChatState(
        myId: myUid,
        friendId: friendId,
        postId: postId,
        product: product,
      );
}

class _LastChatState extends State<ChatScreen> {
  final String myId;
  final String friendId;
  final String postId;
  final Product product;

  _LastChatState(
      {@required this.myId,
      @required this.friendId,
      @required this.postId,
      @required this.product});

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker;
  bool isLoading;
  //add image
  PickedFile pickFile;
  String imageUrl;

  //메시지 보내기
  String senderId; //보내는 내 아이디
  String receiveId; //받는 상대 아이디

  //SharedPreferences preferences;
  //String id; //내아이디
  //채팅방 생성 판별
  String chatId; //채팅방 있으면 새로만들고 없으면 기존 채팅아이디
  bool existChattingRoom; //채팅방
  //유저 연결시간
  String connectTime;
  //RealTime
  List<ProductChatMessage> listProductMessage = []; //Realtime List
  DatabaseReference productChatReference =
      ProductChatController.productChatReference; //Chat Message Ref

  //logger
  // var logger = Logger(
  //   //level: Level.debug,
  //   printer: PrettyPrinter(),
  // );

  // var loggerNoStack = Logger(
  //   printer: PrettyPrinter(methodCount: 0),
  // );

  // void notificationLogger(
  //   String type,
  //   var value,
  // ) {
  //   switch (type) {
  //     case 'v':
  //       logger.v(value.toString());
  //       break;
  //     case 'd':
  //       logger.d(value.toString());
  //       break;
  //     case 'i':
  //       logger.i(value.toString());
  //       break;
  //     case 'w':
  //       logger.w(value.toString());
  //       break;
  //     case 'e':
  //       logger.e(value.toString());
  //       break;
  //     default:
  //       logger.e("Type Error..");
  //   }
  // }

  Future<void> retest2() async {
    await Future.delayed(const Duration(seconds: 10));
  }

  _createChatId() {
    print("proChat-_createChatId");
    chatId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void checkExistChattingRoom() {
    print("proChat-checkExistChattingRoom");
    //RealTime

    productChatReference
        .orderByChild("chatUsers/${googleSignIn.currentUser.id}/friendUid")
        .equalTo(friendId)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        print("proChat-checkExistChattingRoom 1-1. 채팅방 없으므로  chatId 생성");
        //1-1. 채팅방 없을 경우 chatId 생성하고 채팅방 만든다.
        _createChatId(); //chatId 생성
        ProductChatController().createProductChatToRealtimeDatabase(
            friendId, postId, chatId, product); //chat Id로 채팅방 생성
        setTextFieldtoProductInfo(product);
      } else {
        //채팅방 하나라도 있으면 판별해줘야 함
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          print(
              "#realpro 생성 채팅방 가져온값 186 key ${key.toString()} / myid ${values['chatUsers'].keys.toList()[0]} / fid ${values['chatUsers'].keys.toList()[1]} / postId ${values['postId']}");

          //만약 나와 상대 채팅방이 있으면, 텍스트 필드 생성
          if ((myId == values['chatUsers'].keys.toList()[0] &&
                  friendId == values['chatUsers'].keys.toList()[1]
              //&&postId == values['postId']
              ) ||
              (myId == values['chatUsers'].keys.toList()[1] &&
                  friendId == values['chatUsers'].keys.toList()[0]
              //&&postId == values['postId']
              )) {
            existChattingRoom = true;
            chatId = key.toString();
            connectTime = values['chatUsers'][myId]['connectTime'];
            print("2.-1. $chatId");
            ProductChatController().getChatUserimageUrl(chatId);

            print("getc 커넥타임 $connectTime ");
            // getConnectTime(chatId);

            //채팅방 있으면서 & 장터에서 넘어온 경우
            if (checkProductExist() == true) {
              print(
                  "proChat-checkExistChattingRoom 1-3. 만약 장터에서 왔으면 초기 메세지 생성");
              //장터에서 온게 맞으면 텍스트 필드에 물품정보 생성
              setTextFieldtoProductInfo(product);
            }
          }
        }); //foreach 종료하고 생성해야됨.
        if (existChattingRoom == false) {
          _createChatId(); //chatId 생성
          ProductChatController().createProductChatToRealtimeDatabase(
              friendId, postId, chatId, product); //chat Id로 채팅방 생성
          setTextFieldtoProductInfo(product);
        }
      } //else 데이터 하나라도 있을 경우
      setState(() {});
    } //than
            );
  }

  void setTextFieldtoProductInfo(Product product) {
    String title = product.title;
    textEditingController.text = "[상품정보문의] [$title] 상품에 관심있어요!";
  }

  @override
  void initState() {
    super.initState();
    focusNode.hasFocus;
    focusNode.addListener(() {
      onFocusChange();
    });

    isDisplaySticker = false;
    isLoading = false;
    existChattingRoom = false;

    checkExistChattingRoom(); //1. 채팅방 생성 여부 확인
    print("getc init $connectTime");
  }

  bool checkProductExist() {
    print("proChat-checkProductExist");
    //네비게이트 위치 확인,
    String test = "dd";
    if (product != null) {
      Fluttertoast.showToast(
          msg:
              "type ${product.runtimeType} / 프로덕트에서 넘어옴, 초기 채팅 저장 ${product.title}");
      return true;
    } else
      Fluttertoast.showToast(
          msg: "type ${test.runtimeType} / 챗리스트에서 넘어옴 product null");
    return false;
  }

  onFocusChange() {
    print("^^^포커스체인지");
    if (focusNode.hasFocus) {
      //hide stickers whenever keypad appears
      //setState(() {
      isDisplaySticker = false;
      //});
    }
  }

  @override
  build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        //alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
//            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppBar(
                leading: BackButton(
                  color: Colors.black,
                  // OnestepColors().mainColor,
                ),
                // shadowColor: Colors.white,
                elevation: 0,
                backgroundColor: Colors.white10,
                // OnestepColors().thirdColor,
                title: Center(
                  child: Column(
                    children: [
                      ProductChatController()
                          .getProductUserNickName(friendId, 15),
                      SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 9,
                          ),
                          Text(
                            "접속중",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Text("ge"),
                ),
                actions: [
                  ProductChatMenu().getProductMenu(context, chatId, friendId),
                  // Text("ge"),
                ],
              ),
              //Text("con $connectTime"),
              ProductChatController().createProductInfomation(postId),
              // Align(
              //  alignment: FractionalOffset(0.5, 0.5), // 수평 중간, 수직 하단에 위치하도록 설정
              //    child:
              _buildChatListListTileStream(),
              //),
              (isDisplaySticker ? createStickers() : Container()),
              //Input Controllers
              createInput(),
            ],
          ),
          createLoding(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  createLoding() {
    return Positioned(
      child: isLoading ? CircularProgressIndicator() : Container(),
    );
  }

  Future<bool> onBackPress() {
    print("키보드 백 기본");
    if (isDisplaySticker) {
      print("키보드 이모티콘 떠있네여");
      setState(() {
        isDisplaySticker = false;
      });
    }
    // else if (focusNode.) {
    //   print("키보드 떠있네여");
    // }
    // else if (focusNode.hasFocus) {
    //   print("키보드 떠있네여");
    //   // SystemChannels.textInput.invokeMethod('TextInput.hide');
    //   // FocusScope.of(context).requestFocus(new FocusNode());
    //   // focusNode.dispose();
    // }
    else {
      print("키보드 없음");
      Navigator.pop(context);
      //   //print('뒤로감');
    }
    return Future.value(false);
  }

  createStickers() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () => print("test@"),
                //onSendMessage("mimi1", 2),
                child: Image.asset(
                  "images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () => checkTheSendMessage(chatId, friendId, "st", 2),
                //padding: EdgeInsets.all(0.0),
                child: Image.asset(
                  "images/st.png",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () =>
                    checkTheSendMessage(chatId, friendId, "mini3", 2),
                child: Image.asset(
                  "images/mimi3.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  _buildChatListListTileStream() {
    // Future.delayed(const Duration(seconds: 1));
    print("getc 스트림시작 $connectTime");
    return Flexible(
      fit: FlexFit.tight,
      child: myId == ""
          ? Center(
              // child: CircularProgressIndicator(
              //   valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              // ),
              )
          : StreamBuilder(
              stream: productChatReference
                  .child('$chatId/message')
                  .orderByChild("sendTime")
                  .startAt(connectTime) //null or connectTime
                  //.equalTo("1621496441639")
                  .onValue,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container();
                  //CircularProgressIndicator();
                  default:
                    if (snapshot == null ||
                        !snapshot.hasData ||
                        snapshot.data.snapshot.value == null) {
                      return Container();
                    } else if (snapshot.hasData) {
                      listProductMessage.clear();
                      DataSnapshot dataValues = snapshot.data.snapshot;
                      Map<dynamic, dynamic> values = dataValues.value;
                      print(
                          "#realpro Strmsg message id0 : ${values.toString()}");
                      values.forEach((key, values) {
                        print(
                            "#realpro Strmsg message id1 : ${values["idTo"].keys.toList()[0]}");
                        String s = values[
                            "idTo/${googleSignIn.currentUser.id.toString()}"];
                        print(
                            "#realpro Strmsg message read2 : ${googleSignIn.currentUser.id.toString()} ${values["idTo/${googleSignIn.currentUser.id.toString()}"]} $s");
                        print(
                            "#realpro Strmsg message read3 : ${googleSignIn.currentUser.id.toString()} ${values["idTo/TLtvLka2sHTPQE3q6U2WPxfgJ8j2"].toString()} ");

                        print(
                            "#realpro Strmsg message key4 : ${key.toString()}");
                        print(
                            "#realpro Strmsg message value5 : ${values['content']}");
                        print(
                            "#realpro Strmsg message idTo6 : ${values['idTo']}");
                        print(
                            "#realpro Strmsg message idTo7 : ${values['idTo'].values.toList()[0]}");

                        //Message Read update
                        if (values["idTo"].keys.toList()[0] ==
                                googleSignIn.currentUser.id.toString() &&
                            values['idTo'].values.toList()[0] == false) {
                          ProductChatController()
                              .updateReadMessage(chatId, key);

                          listProductMessage.add(
                              ProductChatMessage.forReadMapSnapshot(values));
                        } //업데이트 종료
                        else
                          listProductMessage
                              .add(ProductChatMessage.forMapSnapshot(values));
                      });
                      listProductMessage.sort((b, a) =>
                          a.sendTime.compareTo(b.sendTime)); //정렬3. 시간 순 정렬
                      return listProductMessage.length > 0
                          ? ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              shrinkWrap: true,
                              reverse: true,
                              controller: listScrollController,
                              itemCount: listProductMessage.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                    bottom: 5,
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          if (index ==
                                              listProductMessage.length - 1)
                                            createMessageDate(
                                                index,
                                                listProductMessage.length,
                                                listProductMessage[index],
                                                listProductMessage[index])
                                          else
                                            createMessageDate(
                                                index,
                                                listProductMessage.length,
                                                listProductMessage[index],
                                                listProductMessage[index + 1]),
                                        ],
                                      ),
                                      createMessage(
                                          index, listProductMessage[index]),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Text("생성된 채팅방이 없습니다. . !");
                    } else
                      return Text("리얼타임 채팅 내부");
                }
              },
            ), //플렉시블
    );
  }

  Widget createMessageDate(
      int index,
      int maxIndex,
      ProductChatMessage productMessage,
      ProductChatMessage nextProductMessage) {
    var maxindex = maxIndex - 1;
    print(
        "##message index $index / m Index $maxIndex / proMsg ${productMessage.sendTime}");
    if (index == maxindex && productMessage != null) //메세지 시작일 경우 이거 출력
      return getMessageDate(productMessage.sendTime);
    else if (index < maxindex && productMessage != null) {
      return compareToProductMessageDate(productMessage, nextProductMessage);
      // if (productMessage.timestamp == nextProductMessage.timestamp)
      //   print("전과 같으면 ");
      //첫 메세지 제외일 경우

    } else
      return Text("err");
  }

  Widget createMessage(int index, ProductChatMessage productMessage) {
    if (productMessage.idFrom == myId) {
      senderId = myId;
      receiveId = friendId;
      //내가 보냈을 경우
      return Container(
          // margin: EdgeInsets.only(top: 8.0),
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                productMessage.isRead == false ? Text("1") : Text(""),
                getMessageTime(productMessage.sendTime),
              ],
            ),
          ),
          SizedBox(width: 5, height: 10),
          productMessage.type == 0
              //Text Msg
              ? Container(
                  child: Text(
                    productMessage.content.title,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  //width: 150.0,
                  decoration: BoxDecoration(
                      color: OnestepColors().fifColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      //textmargin
                      // top: 8,
                      // bottom: 5,
                      // isLastMsgRight(index) ? 0.0 : 0.0,
                      // right: 10.0,
                      ),
                )
              //Image Msg
              : productMessage.type == 1
                  ?
                  //Text(productMessage.content.imageUrl.toString())
                  Container(
                      child: TextButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    (OnestepColors().mainColor)),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Text("err"),
                              // Image.asset("images/mimi1.gif",
                              //     width: 200.0,
                              //     height: 200.0,
                              //     fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: productMessage.content.imageUrl,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          // print("pic click " +
                          //     document["content"] +
                          //     'index : ' +
                          //     index.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(
                                      url: productMessage.content.imageUrl)));
                        },
                      ),
                      margin: EdgeInsets.only(
                          //image margin
                          // top: 8,
                          // bottom: isLastMsgRight(index) ? 0.0 : 0.0,
                          // right: 0.0,
                          ),
                    )
                  //Sticker . gif Msg
                  : productMessage.type == 2
                      ? Container(
                          child: Image.asset(
                            "images/${productMessage.content}.gif",
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              // top: 8,
                              // bottom: isLastMsgRight(index) ? 20.0 : 0.0,
                              // right: 10.0,
                              ),
                        )
                      //Product Info Message
                      : Container(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
                          // width: 150.0,
                          //height: 150,
                          decoration: BoxDecoration(
                              color: OnestepColors().fifColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Expanded(
                                  //child:
                                  Material(
                                    child: CachedNetworkImage(
                                      imageUrl: productMessage.content.imageUrl,
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 140,
                                        child: Text(
                                          productMessage.content.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        productMessage.content.price + "원",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        OnestepColors().mainColor),
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                (ProductDetail(
                                                    docId: widget.postId))));
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      height: 30,
                                      child: Text("상세보기")),
                                ),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(
                              // top: 8,

                              ),
                        ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ));
    } //if My messages - Right Side

    //Receiver Messages - Left Side
    else {
      //상대가 보냈을 경우

      return Container(
        // margin: EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(right: 6.0),
                child: ProductChatController().getUserImagetoChatroom(chatId)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //displayMessages
                productMessage.type == 0
                    //Text Msg
                    ? Container(
                        child: Text(
                          productMessage.content.title,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        //width: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(
                          //top: 8,

                          // left: 10.0,
                          right: 5.0,
                        ), //상대 텍스트 마진
                      )
                    : productMessage.type == 1
                        ? Container(
                            child: TextButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          (Colors.lightBlueAccent)),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset("images/test.jpeg",
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: productMessage.content.imageUrl,
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: productMessage
                                                .content.imageUrl)));
                              },
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        //Sticker
                        : productMessage.type == 2
                            ? Container(
                                child: Image.asset(
                                  "images/${productMessage.content}.gif",
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    //bottom: isLastMsgLeft(index) ? 20.0 : 10.0,
                                    right: 10.0),
                              )
                            //Product Info Message
                            : Container(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                // width: 150.0,
                                //height: 150,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Expanded(
                                        //child:
                                        Material(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                productMessage.content.imageUrl,
                                            fit: BoxFit.cover,
                                            height: 50,
                                            width: 50,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          clipBehavior: Clip.hardEdge,
                                        ),

                                        // child: ExtendedImage.network(
                                        //   snapshot.data['imageUrl'],
                                        //   fit: BoxFit.cover,
                                        //   height: 50,
                                        //   width: 50,
                                        //   cache: true,
                                        // ),
                                        // ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 140,
                                              child: Text(
                                                productMessage.content.title,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              productMessage.content.price +
                                                  "원",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.grey[400],
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(0),
                                          // hoverElevation: 0,
                                          // focusElevation: 0,
                                          // highlightElevation: 0,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      (ProductDetail(
                                                          docId:
                                                              widget.postId))));
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 60,
                                            height: 30,
                                            child: Text("상세보기")),
                                      ),
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.only(
                                    //top: 8,
                                    // bottom: isLastMsgRight(index) ? 20.0 : 0.0,
                                    right: 10.0),
                              ),
                //GetTime(document),
                getMessageTime(productMessage.sendTime),
              ],
            ),
          ],
        ),
        //Msg time 하단이라 지움
/*
            isLastMsgLeft(index)
                ? Container(
                    child: GetTime(document), //채팅 우측 시간출력
                    margin: EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0),
                  )
                : Container(
                    child: Text(' 텍스트?'),
                  )
                  */
      );
    } //else 상대방 Receiver Messages - Left Side
  }

  //Future<void>
  createInput() {
    return Container(
      child: Row(
        children: <Widget>[
          //pick image icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: OnestepColors().mainColor,
                onPressed: getImage, //getImageFromGallery,
              ),
            ),
            color: Colors.white,
          ),

          //emoji icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                color: OnestepColors().mainColor,
                onPressed: getSticker, //getImageFromGallery,
              ),
            ),
            color: Colors.white,
          ),

          //Text Field
          Flexible(
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 15.0),
              controller: textEditingController,
              maxLines: null,
              decoration: InputDecoration.collapsed(
                  hintText: "Write here...,",
                  hintStyle: TextStyle(color: Colors.grey)),
              focusNode: focusNode,
            ),
          ),

          //Send Message Icon Button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: IconButton(
                  icon: Icon(Icons.send),
                  color: OnestepColors().mainColor,
                  onPressed: () {
                    if (textEditingController.text.contains("[상품정보문의]")) {
                      String reConnectTime =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      ProductChatController().reConnectProductChat(
                          chatId,
                          friendId,
                          reConnectTime); //상대방 hide = true 면 변경하고 수신시간도 바꿈
                      checkTheSendMessage(chatId, friendId, product, 3);
                      print("상품정보");
                    } else {
                      print(
                          "#realpro myid $myId / fid $friendId / chatId $chatId");
                      checkTheSendMessage(
                          chatId, friendId, textEditingController.text, 0);
                    }
                  }),
              color: Colors.white,
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
          color: Colors.grey,
          width: 0.5,
        )),
        color: Colors.white,
      ),
    );
  }

  void checkTheSendMessage(
      String chatId, String friendId, var contentMsg, int type) {
    print(
        "proChat-checkTheSendMessage 1. 받은 값 확인, 문제없으면 채팅 생성 $chatId $friendId ${contentMsg.runtimeType} $type ");

    if (ProductChatController()
            .onSendToProductMessage(chatId, friendId, contentMsg, type) ==
        true) {
      print("proChat-checkTheSendMessage 3. 전송성공");
      if (type == 3) {
        print("proChat-checkTheSendMessage 2. type == 3, 추가 채팅 생성");
        ProductChatController().onSendToProductAddMessage(chatId, friendId);
      }
      initTextEditingController();
      initListScrollController();
    } else {
      print("proChat-checkTheSendMessage 4. 전송실패");
    }
  }

  void initTextEditingController() {
    //텍스트 컨트롤러 초기화
    textEditingController.clear();
  }

  void initListScrollController() {
    //리스트 스크롤 컨트롤러 초기화
    listScrollController.animateTo(0.0,
        duration: Duration(microseconds: 300), curve: Curves.easeOut);
  }

  // var metadata;
  Future getImage() async {
    print("1. 이미지 선택");
    pickFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickFile != null) {
      isLoading = true;
      //$이미지 메타데이터 넣고싶으면 추가
      // metadata = firebase_storage.SettableMetadata(
      //     contentType: 'createImage/jpeg',
      //     customMetadata: {'picked-file-path': pickFile.path});

    }

    //imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    // if (imageFile != null) {
    //   isLoading = true;
    // }
    print("2. 이미지 선택 완료");

    uploadImageFile();
    print("0. 이미지 업로드 완료");
  }

  Future uploadImageFile() async {
    print("3. 이미지 업로드 호출");
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    print('4. 이미지 파일명 : $fileName');
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("chat Images")
        .child(fileName);

    firebase_storage.UploadTask storageUploadTask =
        storageReference.putFile(io.File(pickFile.path));
    //storageReference.putFile(io.File(pickFile.path), metadata); //이미지 메타데이터 추가 시
    firebase_storage.TaskSnapshot storageTaskSnapshot = await storageUploadTask;

    //.onComplete;
    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child("chat Images").child(fileName);
    // StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    // StorageTaskSnapshot storageTaskSnapshot =
    //     await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      // setState(() {
      isLoading = false;
      checkTheSendMessage(chatId, friendId, imageUrl, 1);
      //  });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      print('에러' + error);
      //Fluttertoast.showToast(msg: "Error: ", error);
    });
  }
}
