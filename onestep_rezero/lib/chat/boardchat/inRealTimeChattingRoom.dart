import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/chat/boardchat/realtimeProductChatController.dart';
import 'package:onestep_rezero/chat/widget/FullmageWidget.dart';
import 'package:onestep_rezero/chat/widget/message_list_time.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

import 'dart:io' as io;

import 'model/productMessage.dart';
import 'model/productSendMessage.dart';

class InRealTimeChattingRoomPage extends StatelessWidget {
  final String myUid;
  final String friendId;
  final String postId;
  // InRealTimeChattingRoomPage(
  //     {@required this.myUid, @required this.friendId, @required this.postId});

  InRealTimeChattingRoomPage({this.myUid, this.friendId, this.postId});

  @override
  Widget build(BuildContext context) {
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
              "chatRoomUid : $postId",
              style: TextStyle(fontSize: 9),
            ),
          ],
        ),
      ),
      body: ChatScreen(
        myUid: myUid,
        friendId: friendId,
        postId: postId,
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
//                     .collection("chattingroom")
//                     .doc(copy)
//                     .collection('message')
//                     .get()
//                     .then((snapshot) {
//                   for (DocumentSnapshot ds in snapshot.docs) {
//                     ds.reference.delete();
//                   }
//                 });
//                 FirebaseFirestore.instance
//                     .collection("chattingroom")
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

  ChatScreen(
      {Key key,
      @required this.myUid,
      @required this.friendId,
      @required this.postId})
      : super(key: key);

  @override
  _LastChatState createState() =>
      _LastChatState(myId: myUid, friendId: friendId, postId: postId);
}

class _LastChatState extends State<ChatScreen> {
  final String myId; // uid 받음
  final String friendId;
  final String postId;

  _LastChatState(
      {@required this.myId, @required this.friendId, @required this.postId});

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
  String chattingRoomId; //채팅방 있으면 새로만들고 없으면 기존 채팅아이디
  bool existChattingRoom; //채팅방

  //RealTime
  List<ProductMessage> listProductMessage = []; //Realtime List
  DatabaseReference productChatMessageReference = FirebaseDatabase.instance
      .reference()
      .child("chattingroom")
      .child("productchat"); //Chat Message Ref

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
    chattingRoomId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void checkExistChattingRoom() {
    //RealTime
    DatabaseReference productchatdatabasereference = FirebaseDatabase.instance
        .reference()
        .child("chattingroom")
        .child("productchat");

    productchatdatabasereference
        .orderByChild("users/${currentUserModel.uid}")
        .equalTo(true)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        _createChatId();
      } else {
        Map<dynamic, dynamic> values = snapshot.value;
        //retest(values);
        //retest2();
        values.forEach((key, values) {
          Future.delayed(const Duration(seconds: 1));

          if ((myId == values['users'].keys.toList()[0] &&
                  friendId == values['users'].keys.toList()[1] &&
                  postId == values['postId']) ||
              (myId == values['users'].keys.toList()[1] &&
                  friendId == values['users'].keys.toList()[0] &&
                  postId == values['postId'])) {
            existChattingRoom = true;
            chattingRoomId = key.toString();
          }
        });
        if (existChattingRoom == true) {
          //만약 채팅방이 있으면
          setState(() {});
        } else {
          _createChatId();
        }
      } //else
    } //than
            );
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      onFocusChange();
    });

    isDisplaySticker = false;
    isLoading = false;
    existChattingRoom = false;

    checkExistChattingRoom();
  }

  onFocusChange() {
    //print("^^^포커스체인지" + id.toString());
    if (focusNode.hasFocus) {
      //hide stickers whenever keypad appears
      setState(() {
        isDisplaySticker = false;
      });
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
              createProductInfomation(),
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
                onPressed: () => onSendToProductMessage("st", 2),
                //padding: EdgeInsets.all(0.0),
                child: Image.asset(
                  "images/st.png",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () => onSendToProductMessage("mimi3", 2),
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

  Future getProductInfo() async {
    return FirebaseFirestore.instance.collection('products').doc(postId).get();
  }

  FutureBuilder createProductInfomation() {
    return FutureBuilder(
      future: getProductInfo(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
                    child: Row(
                      children: <Widget>[
                        // Material(
                        //   child: ExtendedImage.network(
                        //     snapshot.data['images'][0],
                        //     width: 55,
                        //     height: 55,
                        //     fit: BoxFit.cover,
                        //     cache: true,
                        //   ),
                        //   borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        //   clipBehavior: Clip.hardEdge,
                        // ),
                        Material(
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data['images'][0],
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Column(
                          children: <Widget>[
                            Text(snapshot.data['title']),
                            Text(snapshot.data['price']),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 10,
                    thickness: 1,
                  ),
                ],
              );
            }
        }
      },
    );
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
              stream: productChatMessageReference
                  .child('$chattingRoomId/message')
                  //.orderByChild("message")
                  .onValue, //조건1.  타임스탬프 기준
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
                      listProductMessage.clear(); //리스트 클리어
                      DataSnapshot dataValues = snapshot.data.snapshot;
                      Map<dynamic, dynamic> values = dataValues.value;

                      values.forEach((key, values) {
                        //Message Read update
                        if (values["idTo"].keys.toList()[0] ==
                                currentUserModel.uid &&
                            values['idTo'].values.toList()[0] == false) {
                          //listProductMessage[0].
                          //
                          RealtimeProductChatController()
                              .updateReadMessage(chattingRoomId, key);
                          // DatabaseReference productChatMessageReference =
                          //     FirebaseDatabase.instance
                          //         .reference()
                          //         .child("chattingroom")
                          //         .child("productchat")
                          //         .child(chattingRoomId)
                          //         .child("message")
                          //         .child(key)
                          //         .child("idTo");
                          // productChatMessageReference.update({
                          //   googleSignIn.currentUser.id.toString(): true,
                          // });
                          listProductMessage
                              .add(ProductMessage.forReadMapSnapshot(values));
                        } //업데이트 종료
                        else
                          listProductMessage
                              .add(ProductMessage.forMapSnapshot(values));
                      });
                      listProductMessage.sort((b, a) =>
                          a.timestamp.compareTo(b.timestamp)); //정렬3. 시간 순 정렬

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

  Widget createMessageDate(int index, int maxIndex,
      ProductMessage productMessage, ProductMessage nextProductMessage) {
    var maxindex = maxIndex - 1;

    if (index == maxindex && productMessage != null) //메세지 시작일 경우 이거 출력
      return getMessageDate(productMessage.timestamp);
    else if (index < maxindex && productMessage != null) {
      return compareToMessageDate(productMessage, nextProductMessage);
      // if (productMessage.timestamp == nextProductMessage.timestamp)
      //   print("전과 같으면 ");
      //첫 메세지 제외일 경우

    } else
      return Text("err");
  }

  Widget createMessage(int index, ProductMessage productMessage) {
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
//                        ? Text("${productMessage.isRead} 상대방 안읽음")
//                       : Text("${productMessage.isRead} 상대방 읽음"),

                  //Text(document["isRead"].toString()),
                  //GetTime(document),
                  //Text("time"),
                  getMessageTime(productMessage.timestamp),
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
                      : Container(
                          child: Image.asset(
                            "images/${productMessage.content}.gif",
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMsgRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
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
                getMessageTime(productMessage.timestamp),
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
                    if (existChattingRoom == false) {
                      //방 만들어진 적이 없으면
                      ProductSendMessage productSendMessage;
                      productSendMessage =
                          new ProductSendMessage.forMapSnapshot(
                              textEditingController.text,
                              0,
                              friendId,
                              postId,
                              chattingRoomId,
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
                      onSendToProductMessage(textEditingController.text, 0);
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

  void onSendToProductMessage(String contentMsg, int type) {
    //type = 0 its text msg
    //type = 1 its imageFile
    //type = 2 its sticker image
    if (contentMsg != "") {
      textEditingController.clear();
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();

//RealTime
      DatabaseReference productChatMessageReference = FirebaseDatabase.instance
          .reference()
          .child("chattingroom")
          .child("productchat")
          .child(chattingRoomId)
          .child("message")
          .child(messageId);

      DatabaseReference productChatReference = FirebaseDatabase.instance
          .reference()
          .child("chattingroom")
          .child("productchat")
          .child(chattingRoomId);

      productChatMessageReference.set({
        "idFrom": myId,
        "idTo": {friendId: false},
        "timestamp": messageId,
        "content": contentMsg,
        "type": type,
        //"isRead": false,
      }).whenComplete(() {
        switch (type) {
          case 1:
            contentMsg = "사진을 보냈습니다.";
            break;
          case 2:
            contentMsg = "이모티콘을 보냈습니다.";
            break;
        }
        productChatReference.update({
          "recentText": contentMsg,
          "timestamp": messageId,
        });
      });

      listScrollController.animateTo(0.0,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    } //if
    else {
      Fluttertoast.showToast(msg: 'Empty Message. Can not be send.');
    }
  }

  // var metadata;
  Future getImage() async {
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

    uploadImageFile();
  }

  Future uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
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
      setState(() {
        isLoading = false;
        onSendToProductMessage(imageUrl, 1);
      });
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      print('에러' + error);
      //Fluttertoast.showToast(msg: "Error: ", error);
    });
  }
}
