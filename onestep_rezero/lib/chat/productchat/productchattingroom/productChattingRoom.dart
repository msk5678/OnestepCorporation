import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatListController.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMessage.dart';
import 'package:onestep_rezero/chat/widget/FullmageWidget.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/chat/widget/message_list_time.dart';
import 'package:onestep_rezero/chat/widget/productChatMenu.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  String chatId;
  bool existChattingRoom;
  String connectTime;

  //RealTime
  List<ProductChatMessage> listProductMessage = []; //Realtime List
  DatabaseReference productChatReference =
      ProductChatController.productChatReference; //Chat Message Ref

  _createChatId() {
    chatId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void checkExistChattingRoom() {
    try {
      productChatReference
          .orderByChild("chatUsers/${currentUserModel.uid}/friendUid")
          .equalTo(friendId)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value == null) {
          //1-1. 채팅방 없을 경우 chatId 생성하고 채팅방 만든다.
          _createChatId(); //chatId 생성
          ProductChatController().createProductChatToRealtimeDatabase(
              friendId, postId, chatId); //chat Id로 채팅방 생성
          setTextFieldtoProductInfo(product);
        } else {
          //채팅방 하나라도 있으면 판별해줘야 함
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key, values) async {
            // print("#realpro 생성 채팅방 가져온값 186 key ${key.toString()} / myid ${values['chatUsers'].keys.toList()[0]} / fid ${values['chatUsers'].keys.toList()[1]} / postId ${values['postId']}");

            //나, 상대 채팅방 있으면 텍스트 필드 생성
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
              // print("2.-1. $chatId");
              // print("getc 커넥타임 $connectTime ");
              //채팅방 있으면서 & 장터에서 넘어온 경우
              if (checkProductExist() == true) {
                // print("proChat-checkExistChattingRoom 1-3. 만약 장터에서 왔으면 초기 메세지 생성");
                //장터에서 온게 맞으면 텍스트 필드에 물품정보 생성
                setTextFieldtoProductInfo(product);
              }
            }
          }); //foreach 종료하고 생성해야됨.
          if (existChattingRoom == false) {
            _createChatId(); //chatId 생성
            ProductChatController().createProductChatToRealtimeDatabase(
                friendId, postId, chatId); //chat Id로 채팅방 생성
            setTextFieldtoProductInfo(product);
          }
        } //else 데이터 하나라도 있을 경우
        setState(() {});
      } //than
              );
    } catch (e) {
      print("$e");
    }
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
  }

  bool checkProductExist() {
    if (product != null) {
      return true;
    } else
      return false;
  }

  onFocusChange() {
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
        children: <Widget>[
          Container(
            color: Colors.grey[50],
            child: Column(
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
                  backgroundColor: Colors.grey[50],
                  // Colors.white,
                  // OnestepColors().thirdColor,
                  title: Center(
                    child: Column(
                      children: [
                        ProductChatListController()
                            .getProductUserNickName(chatId, friendId, 15),
                        SizedBox(
                          height: 1.h,
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
                  ),
                  actions: [
                    ProductChatMenu().getProductMenu(
                      context,
                      chatId,
                      friendId,
                    ),
                  ],
                ),
                ProductChatController().createProductInfomation(postId),
                _buildChatListListTileStream(),
                createInput(),
                (isDisplaySticker ? createStickers() : Container()),
              ],
            ),
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
    }
    // else if (focusNode.hasFocus) {
    //   // SystemChannels.textInput.invokeMethod('TextInput.hide');
    //   // FocusScope.of(context).requestFocus(new FocusNode());
    //   // focusNode.dispose();
    // }
    else {
      Navigator.pop(context);
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
                  width: 50.0.w,
                  height: 50.0.h,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () => checkTheSendMessage(chatId, friendId, "st", 2),
                //padding: EdgeInsets.all(0.0),
                child: Image.asset(
                  "images/st.png",
                  width: 50.0.w,
                  height: 50.0.h,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                onPressed: () =>
                    checkTheSendMessage(chatId, friendId, "mini3", 2),
                child: Image.asset(
                  "images/mimi3.gif",
                  width: 50.0.w,
                  height: 50.0.h,
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
              width: 0.5.w,
            ),
          ),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0.h,
    );
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  _buildChatListListTileStream() {
    return Flexible(
      fit: FlexFit.tight,
      child: myId == ""
          ? Center()
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
                  default:
                    if (snapshot == null ||
                        !snapshot.hasData ||
                        snapshot.data.snapshot.value == null) {
                      return Container();
                    } else if (snapshot.hasData) {
                      listProductMessage.clear();
                      DataSnapshot dataValues = snapshot.data.snapshot;
                      Map<dynamic, dynamic> values = dataValues.value;
                      // print("#realpro Strmsg message id0 : ${values.toString()}");
                      values.forEach((key, values) {
                        // print("#realpro Strmsg message id1 : ${values["idTo"].keys.toList()[0]}");
                        // String s = values[
                        //     "idTo/${googleSignIn.currentUser.id.toString()}"];
                        // print("#realpro Strmsg message read2 : ${googleSignIn.currentUser.id.toString()} ${values["idTo/${googleSignIn.currentUser.id.toString()}"]} $s");
                        // print("#realpro Strmsg message read3 : ${googleSignIn.currentUser.id.toString()} ${values["idTo/TLtvLka2sHTPQE3q6U2WPxfgJ8j2"].toString()} ");

                        // print("#realpro Strmsg message key4 : ${key.toString()}");
                        // print("#realpro Strmsg message value5 : ${values['content']}");
                        // print("#realpro Strmsg message idTo6 : ${values['idTo']}");
                        // print("#realpro Strmsg message idTo7 : ${values['idTo'].values.toList()[0]}");

                        //Message Read update
                        if (values["idTo"].keys.toList()[0] ==
                                currentUserModel.uid.toString() &&
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
                                    bottom: 5, //각 메세지 하단 패딩
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
    // print("##message index $index /@@/${productMessage.content.title} /@@/ m Index $maxIndex / proMsg ${productMessage.sendTime}");
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

  _createMessageTypeWithText(String uid, String content) {
    double deviceWidth = MediaQuery.of(context).size.width;
    Color messageColor;
    uid == currentUserModel.uid
        ? messageColor = OnestepColors().fifColor
        : messageColor = Colors.grey[200];

    return Container(
      // color: Colors.red,
      padding: EdgeInsets.fromLTRB(
        13,
        10,
        13,
        13,
      ),

      // height: 30,
      constraints: BoxConstraints(
        maxWidth: deviceWidth / 1.38.h,
        minWidth: 1.w,
      ),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 15,
          // height: 1.5,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),

      decoration: BoxDecoration(
        color: messageColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      // margin: EdgeInsets.all(5),
    );
  }

  _createMessageTypeWithImage(String content) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(maxHeight: 200, maxWidth: 200),
      width: deviceWidth / 1.5.w,
      height: deviceWidth / 1.5.h,
      // color: Colors.black,width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullPhoto(url: content),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, //textButton margin
          // minimumSize: Size(50, 30),
          // alignment: Alignment.centerLeft,
        ),
        child: Material(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            imageUrl: content,
            width: deviceWidth / 1.5.w,
            height: deviceWidth / 1.5.h,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  (OnestepColors().mainColor),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Material(
              child: Text("err"),
              // Image.asset("images/mimi1.gif",
              //     width: 200.0,
              //     height: 200.0,
              //     fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(4.0),

              clipBehavior: Clip.hardEdge,
            ),
          ),
        ),
      ),
    );
  }

  _createMessageTypeWithProductInfo(
      String uid, ProductChatMessage productMessage) {
    Color messageColor;
    Color btnColor;
    uid == currentUserModel.uid
        ? messageColor = OnestepColors().fifColor
        : messageColor = Colors.grey[200];

    uid == currentUserModel.uid
        ? btnColor = OnestepColors().mainColor
        : btnColor = Colors.grey[400];

    return Container(
      padding: EdgeInsets.all(
        10.0,
      ), // width: 150.0,
      //height: 150,
      decoration: BoxDecoration(
        color: messageColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
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
                  height: 50.h,
                  width: 50.w,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140.w,
                    child: Text(
                      productMessage.content.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
                backgroundColor: MaterialStateProperty.all(btnColor),
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (ProductDetail(docId: widget.postId)),
                  ),
                );
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 60.w,
                  height: 30.h,
                  child: Text("상세보기")),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.only(
          // top: 8,

          ),
    );
  }

  Widget createMessage(int index, ProductChatMessage productMessage) {
    if (productMessage.idFrom == myId) {
      //내가 보냈을 경우
      return Container(
        // color: Colors.blue,
        // margin: EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            //   child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                productMessage.isRead == false
                    ? Text(
                        "1",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: OnestepColors().mainColor,
                        ),
                      )
                    : Text(""),
                getMessageTime(productMessage.sendTime),
              ],
            ),
            // ),
            Container(
              // color: Colors.red,
              child: SizedBox(width: 5, height: 10),
            ),
            productMessage.type == 0
                //0. Text
                ? _createMessageTypeWithText(
                    productMessage.idFrom, productMessage.content.title)
                //1. Image
                : productMessage.type == 1
                    ? _createMessageTypeWithImage(
                        productMessage.content.imageUrl)
                    //2. Sticker
                    : productMessage.type == 2
                        ? Container(
                            child: Image.asset(
                              "images/${productMessage.content}.gif",
                              width: 100.0.w,
                              height: 100.0.h,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                // top: 8,
                                ),
                          )
                        //3. Product Info Message
                        : _createMessageTypeWithProductInfo(
                            productMessage.idFrom, productMessage),
          ],
        ),
      );
    } //if My messages - Right Side
    else {
      //상대가 보냈을 경우
      return Container(
        // color: Colors.yellow,
        // margin: EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 6.0),
              child: //2
                  ProductChatController().getUserImageToChat(chatId),
              // ProductChatController().getUserImagetoChatroom(chatId),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                productMessage.type == 0
                    //0. Text
                    ? _createMessageTypeWithText(
                        productMessage.idFrom, productMessage.content.title)
                    //1. Image
                    : productMessage.type == 1
                        ? _createMessageTypeWithImage(
                            productMessage.content.imageUrl)
                        //2. Sticker
                        : productMessage.type == 2
                            ? Container(
                                child: Image.asset(
                                  "images/${productMessage.content}.gif",
                                  width: 100.0.w,
                                  height: 100.0.h,
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    //bottom: isLastMsgLeft(index) ? 20.0 : 10.0,
                                    right: 10.0),
                              )
                            //3. Product Info Message
                            : _createMessageTypeWithProductInfo(
                                productMessage.idFrom, productMessage),
                Container(
                  // color: Colors.red,
                  child: SizedBox(width: 5, height: 10),
                ),
                getMessageTime(productMessage.sendTime),
              ],
            ),
          ],
        ),
      );
    } //else 상대방 Receiver Messages - Left Side
  }

  createInput() {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    print("@@input Size !!!!  H : $deviceHeight / w : $deviceWidth");
    Color _inputWidgetColor = Colors.white;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // border: Border(
        //   top: BorderSide(
        //     // color: Colors.green,
        //     width: 0.5,
        //   ),
        // ),
        color: _inputWidgetColor,
      ),
      child: new ConstrainedBox(
        constraints: BoxConstraints(
          // minHeight: 50.h,
          // maxHeight: 400.0.h,
          minHeight: deviceHeight / 16.h,
          maxHeight: deviceHeight / 2.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            //pick image icon button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                5,
                0,
                0,
                4,
              ),
              child: Container(
                // color: Colors.red,
                // height: a, //안됨
                margin: EdgeInsets.symmetric(horizontal: 1.0),
                child: IconButton(
                  icon: Icon(Icons.image),
                  color: OnestepColors().mainColor,
                  onPressed: getImage, //getImageFromGallery,
                ),
              ),
            ),

            //emoji icon button
            // Material(
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 1.0),
            //     child: IconButton(
            //       icon: Icon(Icons.face),
            //       color: OnestepColors().mainColor,
            //       onPressed: getSticker, //getImageFromGallery,
            //     ),
            //   ),
            //   color: Colors.white,
            // ),

            //Text Field
            Container(
              // color: Colors.red,
              // decoration: BoxDecoration(
              //   color: Colors.amber,
              //   // Colors.grey[200],
              //   borderRadius: BorderRadius.circular(18.0),
              // ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // minWidth: 200,
                  // maxWidth: 300.w,
                  maxWidth: deviceWidth / 1.37.w,
                  // minHeight: 35.h,
                  // maxHeight: 200.0.h,
                  minHeight: deviceHeight / 27.h,
                  maxHeight: deviceHeight / 4.h,
                ),
                // width: 250,
                // height: b,

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    10,
                    10,
                    18,
                  ),
                  child: TextField(
                    // cursorHeight: 24.0,
                    // cursorWidth: 5,
                    // cursorRadius: Radius.zero,
                    // onChanged: (value) {
                    //   textEditingController.text == ""
                    //   ?
                    // },
                    cursorColor: OnestepColors().mainColor,
                    enabled: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    controller: textEditingController,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration.collapsed(
                      hintText:
                          "채팅을 입력하세요.                                     ",
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                      // border: OutlineInputBorder(),
                    ),
                    focusNode: focusNode,
                  ),
                ),
              ),
            ),
            Spacer(),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                0,
                10,
                16,
                20,
              ),
              child: Container(
                // color: Colors.amber,
                width: 25.w,
                height: 25.h,
                //Send Icon Button Color
                // color: Colors.blue,
                // _inputWidgetColor,
                // height: c,
                // width: 40,
                // margin: EdgeInsets.symmetric(
                //   horizontal: 8.0,
                // ),
                child: IconButton(
                    icon: Icon(Icons.send),
                    color: OnestepColors().mainColor,
                    disabledColor: Colors.red,
                    onPressed: () {
                      if (textEditingController.text.contains("[상품정보문의]")) {
                        String reConnectTime =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        ProductChatController().reConnectProductChat(
                            chatId,
                            friendId,
                            reConnectTime); //상대방 hide = true 면 변경하고 수신시간도 바꿈
                        checkTheSendMessage(chatId, friendId, product, 3);
                        // print("상품정보");
                      } else {
                        // print("#realpro myid $myId / fid $friendId / chatId $chatId");
                        checkTheSendMessage(
                            chatId, friendId, textEditingController.text, 0);
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkTheSendMessage(
      String chatId, String friendId, var contentMsg, int type) {
    // print("proChat-checkTheSendMessage 1. 받은 값 확인, 문제없으면 채팅 생성 $chatId $friendId ${contentMsg.runtimeType} $type ");

    if (ProductChatController()
            .onSendToProductMessage(chatId, friendId, contentMsg, type) ==
        true) {
      // print("proChat-checkTheSendMessage 3. 전송성공");
      if (type == 3) {
        // print("proChat-checkTheSendMessage 2. type == 3, 추가 채팅 생성");
        ProductChatController().onSendToProductAddMessage(chatId, friendId);
      }
      initTextEditingController();
      initListScrollController();
    } else {
      // print("proChat-checkTheSendMessage 4. 전송실패");
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
    // print("1. 이미지 선택");
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
    // print("2. 이미지 선택 완료");

    uploadImageFile();
    // print("0. 이미지 업로드 완료");
  }

  Future uploadImageFile() async {
    // print("3. 이미지 업로드 호출");
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // print('4. 이미지 파일명 : $fileName');
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
