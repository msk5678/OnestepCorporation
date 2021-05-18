import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/chat/boardchat/model/productMessage.dart';
import 'package:onestep_rezero/chat/boardchat/model/productSendMessage.dart';
import 'package:onestep_rezero/chat/boardchat/realtimeProductChatController.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMessage.dart';
import 'package:onestep_rezero/chat/widget/FullmageWidget.dart';
import 'package:onestep_rezero/chat/widget/message_list_time.dart';
import 'package:onestep_rezero/main.dart';

import 'dart:io' as io;

import 'package:onestep_rezero/product/models/product.dart';

class ProductChattingRoomPage extends StatelessWidget {
  final String myUid;
  final String friendId;
  final String postId;
  final Product product;
  ProductChattingRoomPage(
      {this.myUid, this.friendId, this.postId, this.product});

  @override
  Widget build(BuildContext context) {
    print("포커스 빌드 다시됨");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              //backgroundImage: CachedNetworkImageProvider(),
            ),
          ),
          //_deleteChattingRoom(context), //삭제 다시 구현
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("real"),
            Text(
              "myUid : $myUid",
              style: TextStyle(fontSize: 9),
            ),
            Text(
              "friendId : $friendId",
              style: TextStyle(fontSize: 9),
            ),
            Text(
              "postId : $postId",
              style: TextStyle(fontSize: 9),
            ),
            product == null
                ? Text(
                    "챗리스트에서 옴",
                    style: TextStyle(fontSize: 9),
                  )
                : Text(
                    "${product.title.toString()}",
                    style: TextStyle(fontSize: 9),
                  ),
          ],
        ),
      ),
      body: ChatScreen(
        myUid: myUid,
        friendId: friendId,
        postId: postId,
        product: product,
      ),
    );
  }
}

//  Widget _deleteChattingRoom(var context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               try {
//                 FirebaseFirestore.instance
//                     .collection("chat")
//                     .doc(copy)
//                     .collection('message')
//                     .get()
//                     .then((snapshot) {
//                   for (DocumentSnapshot ds in snapshot.docs) {
//                     ds.reference.delete();
//                   }
//                 });
//                 FirebaseFirestore.instance
//                     .collection("chat")
//                     .doc(chat)
//                     .delete();

//                 Navigator.of(context).pop();
//                 print("삭제 되었습니다." + chattingRoomId);
//               } catch (e) {
//                 print(e.message);
//               }
//             }),
//       ],
//     );
//   }

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
  final String myId; // uid 받음
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
  var listMessage;
  //채팅방 생성 판별
  String chatId; //채팅방 있으면 새로만들고 없으면 기존 채팅아이디
  bool existChattingRoom; //채팅방

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
    chatId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void checkExistChattingRoom() {
    //RealTime

    productChatReference
        .orderByChild("chatUsers/${googleSignIn.currentUser.id}/hide")
        .equalTo(false)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        _createChatId();
        print('#realpro check exist chat  : null $chatId');
      } else {
        print('#realpro check exist chat  : not null');
        print('#realpro Data strmsg : ${snapshot.value}');
        Map<dynamic, dynamic> values = snapshot.value;
        //retest(values);
        //retest2();
        values.forEach((key, values) {
          Future.delayed(const Duration(seconds: 1));
          print('#realpro Data strmsg second value : ${values.toString()}');
          print('#realpro Data strmsg second key : ${key.toString()}');
          print(
              "#realpro 생성 채팅방 가져온값 186 key ${key.toString()} / myid ${values['chatUsers'].keys.toList()[0]} / fid ${values['chatUsers'].keys.toList()[1]} / postId ${values['postId']}");

          print(
              "#realpro Data strmsg second 1  myid $myId / fid $friendId / post $postId");
          print("#realpro 생성 채팅방 상단");
          if ((myId == values['chatUsers'].keys.toList()[0] &&
                  friendId == values['chatUsers'].keys.toList()[1] &&
                  postId == values['postId']) ||
              (myId == values['chatUsers'].keys.toList()[1] &&
                  friendId == values['chatUsers'].keys.toList()[0] &&
                  postId == values['postId'])) {
            existChattingRoom = true;
            chatId = key.toString();

            print(
                "#realpro Data strmsg second 채팅방 있음 22 myid $myId / fid $friendId / post $postId / chatId $chatId");
          }
        });
        print("#realpro 생성 채팅방 하단");
        if (existChattingRoom == true) {
          print(
              "#realpro 생성 채팅방 있음 186 myid $myId / fid $friendId / chatId $chatId");
          //만약 채팅방이 있으면
          setState(() {});
          checkProductExist(chatId, friendId, product, 3);
        } else {
          _createChatId();
          print(
              "#realpro 생성 채팅방 없음 $existChattingRoom 186 myid $myId / fid $friendId / chatId $chatId");
          print(
              "#realpro 생성 채팅방 찍기 $existChattingRoom 186 myid ${DateTime.now().millisecondsSinceEpoch.toString()}");
        }
      } //else
    } //than
            );
  }

  @override
  void initState() {
    super.initState();
    print("포커스 ㅇㅇ");
    focusNode.hasFocus;
    focusNode.addListener(() {
      onFocusChange();
    });

    isDisplaySticker = false;
    isLoading = false;
    existChattingRoom = false;

    print("#### Data strmsg init");

    checkExistChattingRoom();
    //chatId get, create Info
  }

  checkProductExist(String chatId, String friendId, var contentMsg, int type) {
    //네비게이트 위치 확인,
    String test = "dd";
    if (product != null) {
      print("maptest 진입전");
      checkTheSendMessage(chatId, friendId, contentMsg, 3);
      print("maptest 종료");
      Fluttertoast.showToast(
          msg:
              "type ${product.runtimeType} / 프로덕트에서 넘어옴, 초기 채팅 저장 ${product.title}");
    } else
      Fluttertoast.showToast(
          msg: "type ${test.runtimeType} / 챗리스트에서 넘어옴 product null");
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
    if (isDisplaySticker) {
      setState(() {
        isDisplaySticker = false;
      });
    } else {
      Navigator.pop(context);
      //print('뒤로감');
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
    //Future.delayed(const Duration(seconds: 1));
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
                  //.orderByChild("message")
                  .onValue, //조건1.  타임스탬프 기준
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container();
                  //CircularProgressIndicator();
                  default:
                    print("#realpro Strmsg top $chatId");
                    if (snapshot == null ||
                        !snapshot.hasData ||
                        snapshot.data.snapshot.value == null) {
                      print(
                          "stream values if0 null : ${snapshot.data.snapshot.value}");
                      return Container();
                    } else if (snapshot.hasData) {
                      print("#realpro Strmsg top 값 있음");
                      listProductMessage.clear(); //리스트 클리어
                      DataSnapshot dataValues = snapshot.data.snapshot;
                      Map<dynamic, dynamic> values = dataValues.value;
                      print("#realpro Strmsg top value : " + values.toString());
                      print("#realpro Strmsg keys : ${values.keys.toString()}");
                      print("#realpro Strmsg top con : " +
                          values['content'].toString());

                      values.forEach((key, values) {
                        print(
                            "#realpro Strmsg message id : ${values["idTo"].keys.toList()[0]}");
                        String s = values[
                            "idTo/${googleSignIn.currentUser.id.toString()}"];
                        print(
                            "#realpro Strmsg message read : ${googleSignIn.currentUser.id.toString()} ${values["idTo/${googleSignIn.currentUser.id.toString()}"]} $s");
                        print(
                            "#realpro Strmsg message read : ${googleSignIn.currentUser.id.toString()} ${values["idTo/TLtvLka2sHTPQE3q6U2WPxfgJ8j2"].toString()} ");

                        print(
                            "#realpro Strmsg message key : ${key.toString()}");
                        print(
                            "#realpro Strmsg message value : ${values['content']}");
                        print(
                            "#realpro Strmsg message idTo : ${values['idTo']}");
                        print(
                            "#realpro Strmsg message idTo : ${values['idTo'].values.toList()[0]}");

                        //Message Read update
                        if (values["idTo"].keys.toList()[0] ==
                                googleSignIn.currentUser.id.toString() &&
                            values['idTo'].values.toList()[0] == false) {
                          print(
                              "안읽은 메세지, idTo : ${values["idTo"].keys.toList()[0]} // bool : ${values['idTo'].values.toList()[0]} // vals : $values");

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
                      print("#realpro Strmsg top list index : " +
                          listProductMessage.length.toString());
                      return listProductMessage.length > 0
                          ? ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              shrinkWrap: true,
                              reverse: true,
                              controller: listScrollController,
                              itemCount: listProductMessage.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    //Text("jo"),
                                    if (index == listProductMessage.length - 1)
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

                                    createMessage(
                                        index, listProductMessage[index]),
                                  ],
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

  bool isLastMsgLeft(int index) {
    //얘는 falst 반환
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] == receiveId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMsgRight(int index) {
    //얘는 트루 반환함
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]["idFrom"] != receiveId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
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
    //My messages - Right Side
    // var chatTime = DateFormat("yyyy-MM-dd").format(
    //     DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"])));
    // var nextchatTime = DateFormat("yyyy-MM-dd").format(
    //     DateTime.fromMillisecondsSinceEpoch(
    //         int.parse(datedocument["timestamp"])));
    if (productMessage.idFrom == myId) {
      senderId = myId;
      receiveId = friendId;
      //내가 보냈을 경우
      productMessage.type == 0
          ? Container()
          : productMessage.type == 1
              ? Container()
              : productMessage.type == 2
                  ? Container()
                  : Container();

      return Column(
        //요기
        children: <Widget>[
          //Text("time test"),
          // if (index == size - 1) Text(chatTime),
          // if (chatTime != nextchatTime) Text(chatTime),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  productMessage.isRead == false ? Text("1") : Text(""),
                  // ? Text("${productMessage.isRead} 상대방 안읽음")
                  // : Text("${productMessage.isRead} 상대방 읽음"),
                  //Text(document["isRead"].toString()),
                  //GetTime(document),
                  //Text("time"),
                  getMessageTime(productMessage.sendTime),
                ],
              ),
              SizedBox(width: 5, height: 10),
              productMessage.type == 0
                  //Text Msg
                  ? Container(
                      child: Text(
                        productMessage.content,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: 150.0,
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(
                          //textmargin
                          top: 10,
                          bottom: isLastMsgRight(index) ? 0.0 : 10.0,
                          right: 10.0),
                    )
                  //Image Msg
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset("images/mimi1.gif",
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: productMessage.content,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
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
                                          url: productMessage.content)));
                            },
                          ),
                          margin: EdgeInsets.only(
                              //image margin
                              top: 10,
                              bottom: isLastMsgRight(index) ? 0.0 : 10.0,
                              right: 0.0),
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
                                  bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                                  right: 10.0),
                            )
                          //inMessage
                          : Container(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              // width: 150.0,
                              //height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text("PRODUCT - TITLE"),
                                          Text("PRODUCT - PRICE"),
                                        ],
                                      ),
                                      Text("PRODUCT - 사진"),
                                    ],
                                  ),
                                  Text("구매하기"),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Column(
                              //       children: [
                              //         Text("product - title"),
                              //         SizedBox(
                              //           width: 10,
                              //         ),
                              //         Spacer(),
                              //         Container(
                              //           child: Text(
                              //             "product - price",
                              //             style: TextStyle(
                              //               color: Colors.red,
                              //               fontWeight: FontWeight.w500,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     SizedBox(
                              //       width: 10,
                              //     ),
                              //     Text("product - 사진"),
                              //   ],
                              // ),
                            )
              // GetTime(document), //채팅 우측 시간출력
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          )
        ],
      );
    } //if My messages - Right Side

    //Receiver Messages - Left Side
    else {
      //상대가 보냈을 경우

      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMsgLeft(index)
                    ? Material(
                        //display receiver profile image
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  (Colors.lightBlueAccent)),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: "images/mimi1.gif",
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(
                        width: 35.0,
                      ),
                //displayMessages
                productMessage.type == 0
                    //Text Msg
                    ? Container(
                        child: Text(
                          productMessage.content,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(
                            left: 10.0, right: 10.0), //상대 텍스트 마진
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
                                  imageUrl: productMessage.content,
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
                                            url: productMessage.content)));
                              },
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        //Sticker
                        : Container(
                            child: Image.asset(
                              "images/${productMessage.content}.gif",
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMsgLeft(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
                //GetTime(document),
                getMessageTime(productMessage.sendTime),
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
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
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
                color: Colors.lightBlueAccent,
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
                color: Colors.lightBlueAccent,
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
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    print(
                        "#realpro myid $myId / fid $friendId / chatId $chatId");
                    if (existChattingRoom == false) {
                      //방 만들어진 적이 없으면
                      print("#realpro 채팅방 없음, 방생성ㅇ.");
                      ProductSendMessage productSendMessage;
                      productSendMessage =
                          new ProductSendMessage.forMapSnapshot(
                              textEditingController.text,
                              0,
                              friendId,
                              postId,
                              chatId,
                              textEditingController,
                              listScrollController);

                      RealtimeProductChatController()
                          .createProductChatingRoomToRealtimeFirebase(
                              productSendMessage);
                      existChattingRoom = true;
                      // RealtimeProductChatController()
                      //     .createProductChatingRoomToRealtimeFirebaseStorage(
                      //         postId, chattingRoomId)
                      //     .whenComplete(() {
                      //   notificationLogger("i",
                      //       "누가먼저돌까요1 if $chattingRoomId $existChattingRoom");
                      //   existChattingRoom = true;
                      //   onSendMessage(textEditingController.text, 0);
                      // });

//                      print("누가먼저돌까요1-3 if 방생성함");
                    } else {
                      checkTheSendMessage(
                          chatId, friendId, textEditingController.text, 0);
                      //onSendToProductMessage(textEditingController.text, 0);
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
    if (ProductChatController()
            .onSendToProductMessage(chatId, friendId, contentMsg, type) ==
        true) {
      initTextEditingController();
      initListScrollController();
    } else {
      print("메세지 전송에 실패했습니다. . ");
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
