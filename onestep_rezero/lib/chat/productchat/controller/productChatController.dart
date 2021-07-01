import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatLocalController.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

import 'package:onestep_rezero/product/models/product.dart';

class ProductChatController {
  //Product Chat Count
  static final DatabaseReference productChatReference = FirebaseDatabase
      .instance
      .reference()
      .child("university")
      .child(currentUserModel.university)
      .child("chat")
      .child("productchat");

  Future<void> createProductChatToRealtimeDatabase(
      String friendUid, String postId, String chatId) async {
    String myUid = currentUserModel.uid;
    // print("proChatController-createProductChatToRealtimeDatabase 1. 채팅방 생성");
    try {
      //2. users 판매자 정보 가져오기 : 닉네임, 이미지
      FirebaseFirestore.instance
          .collection("user")
          .doc(friendUid)
          .get()
          .then((uservalue) {
        // print("FriendNickname : ${uservalue["nickName"].toString()}");
        // print("FriendNickImage : ${uservalue["photoUrl"].toString()}");
      }).whenComplete(
        () {
          var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
          //Realtime data base
          productChatReference.child(chatId).set({
            "chatId": chatId,
            "postId": postId,
            "createTime": nowTime,
            "recentTime": nowTime,
            "recentText": "채팅방이 생성되었습니다.",
            "chatUsers": {
              myUid: {
                "friendUid": friendUid,
                "connectTime": nowTime,
                "hide": true,
              },
              friendUid: {
                "friendUid": myUid,
                "connectTime": nowTime,
                "hide": true,
              },
            },
          }).whenComplete(() {
            // onSendToProductMessage(chatId, friendUid, product, 3);
            // onSendToProductAddMessage(chatId, friendUid);

            // productChatReference
            //     .child(chatId)
            //     //.child("roominfo")
            //     .once()
            //     .then((DataSnapshot snapshot) {
            //   print('Data : ${snapshot.value}');
            // });
          }); //채팅방 생성 whenComplete
        },
      ); //product whencomplete
    } //users whencomplete
    catch (e) {
      print(e.message);
    }
  }

  void onSendToProductAddMessage(String chatId, String friendUid) {
    onSendToProductMessage(chatId, friendUid, "이 상품에 관심있어요!", 0);
  }

  Widget getUserImageToChat(String chatId) {
    return Material(
      child: CachedNetworkImage(
        imageUrl: ProductChatLocalController().getChatUserimageUrl(chatId),
        // productMessage.content.imageUrl,
        fit: BoxFit.cover,
        height: 40,
        width: 40,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(18.0),
      ),
      clipBehavior: Clip.hardEdge,
    );
  }

  Future getProductInfo(String postId) async {
    return FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('product')
        .doc(postId)
        .get();
  }

  FutureBuilder createProductInfomation(String postId) {
    return FutureBuilder(
      future: getProductInfo(postId),
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
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 8),
                    child: Row(
                      children: <Widget>[
                        Material(
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data['imagesUrl'][0],
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                          //borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data['title'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                snapshot.data['price'],
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: OnestepColors().mainColor,
                    height: 7,
                    thickness: 2,
                  ),
                ],
              );
            }
        }
      },
    );
  }

  bool onSendToProductMessage(
      String chatId, String friendId, var contentMsg, int type) {
    // print("proChatController-onSendToProductMessage 1. 받은 값 확인, 문제없으면 채팅 생성 $chatId $friendId ${contentMsg.runtimeType} $type ");
    //type = 0 its text msg
    //type = 1 its imageFile
    //type = 2 its sticker image
    //contentMsg.characters;
    var content;
    if (contentMsg == "" || contentMsg == null) {
      Fluttertoast.showToast(msg: 'Empty Message. Can not be send.');
      return false;
    } else if (contentMsg != null) {
      if (contentMsg.runtimeType == Product) {
        // print("proChatController-onSendToProductMessage 2-1. contentMsg type이 product이면 map형식 생성");
        // 프로덕트 타입이면 contentMsg 변경
        Map<String, String> productContent = {
          'title': '${contentMsg.title}',
          'price': '${contentMsg.price}',
          'imageUrl': '${contentMsg.imagesUrl[0]}',
        };

        content = productContent;
        // print("maptest $content");
      } else {
        // print("proChatController-onSendToProductMessage 2-2. contentMsg type이 string이면 그대로 생성");
        content = contentMsg;
      }
      // print("maptest1 컨텐츠저장완");
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();
      // print("proChatController-onSendToProductMessage 2-3. 상대방 hide true면 변경함");

      // print("maptest1-1 $chatId $messageId");
//RealTime
      try {
        DatabaseReference productChatMessageReference = productChatReference
            .child(chatId)
            .child("message")
            .child(messageId);
        // print("maptest1-2");
        DatabaseReference productChatListReference =
            productChatReference.child(chatId);
        // print("maptest2");
        productChatMessageReference.set({
          "idFrom": currentUserModel.uid,
          "idTo": {friendId: false},
          "sendTime": messageId,
          "content": content,
          "type": type,
          // "isRead": false,
          //"isRead": false,
        }).whenComplete(() {
          // print("proChatController-onSendToProductMessage 3. 메세지 저장 완료");
          switch (type) {
            case 1:
              content = "사진을 보냈습니다.";
              break;
            case 2:
              content = "이모티콘을 보냈습니다.";
              break;
          }
          if (contentMsg.runtimeType == String) {
            // print("proChatController-onSendToProductMessage 4. 채팅방 시간, 최근 정보 업데이트");

            productChatListReference.update({
              "recentText": content,
              "recentTime": messageId,
            });
          } else if (contentMsg.runtimeType == Product) {
            // productChatListReference.update({
            //   "recentText": content,
            //   "recentTime": messageId,
            // });
          }
        });
        // Fluttertoast.showToast(msg: "챗 생성 성공.");
      } catch (e) {
        // Fluttertoast.showToast(msg: "$e 챗 생성 에러.");

      }
      return true;
    } //if
    else {
      Fluttertoast.showToast(msg: 'Empty Message. Can not be send.');
      return false;
    }
  }

  Future<void> updateReadMessage(String chatId, String messageId) async {
    DatabaseReference productChatMessageReference = productChatReference
        .child(chatId)
        .child("message")
        .child(messageId)
        .child("idTo");
    productChatMessageReference.update({
      currentUserModel.uid: true,
      //"111357489031227818227": true,
    });
    // print(
    //     "##updateReadMessage hasData value : ${snapshot.data.snapshot.value}");
    // print("##updateReadMessage hasData key: ${snapshot.data.snapshot.key}");
    // print("##updateReadMessage hasData chatId: ${chattingRoomId}");
    // databaseReference
    //     .child("chattingroom")
    //     .child("productchat")
    //     .child(chattingRoomId)
    //     .child("message")
    //     .once()
    //     .then((value) {
    //   // value.value.foreach(key, value)(

    //   // );
    //   print("##updateReadMessage message value : ${value.value}");
    // });
    // //if (data['idTo'] == googleSignIn.currentUser.id.toString() && data['isRead'] == false) {}
  }

  void reConnectProductChat(
      String chatId, String friendId, String reConnectTime) {
    DatabaseReference productChatFriendUidRefernce =
        productChatReference.child(chatId).child("chatUsers").child(friendId);
    Map<String, dynamic> friendConnectState;
    productChatFriendUidRefernce.once().then((DataSnapshot snapshot) {
      if (snapshot.value['hide'] == true) {
        // print("proChatContro ${snapshot.value['hide']}");
        // print("proChatContro ${snapshot.value['friendUid']}");
        friendConnectState = {
          "hide": false,
          "connectTime": reConnectTime,
        };
        productChatFriendUidRefernce.update(friendConnectState);
      }
    });
    DatabaseReference productChatMyUidRefernce = productChatReference
        .child(chatId)
        .child("chatUsers")
        .child(currentUserModel.uid);
    Map<String, dynamic> myConnectState;
    productChatMyUidRefernce.once().then((DataSnapshot snapshot) {
      if (snapshot.value['hide'] == true) {
        // print("proChatContro ${snapshot.value['hide']}");
        // print("proChatContro ${snapshot.value['friendUid']}");
        myConnectState = {
          "hide": false,
          "connectTime": reConnectTime,
        };
        productChatMyUidRefernce.update(myConnectState);
      }
    });
  }

  void exitProductChat(String chatId) {
    // print("채팅방 나가기. hide = true, currentTime = 나간시간");
    String exitTime = DateTime.now().millisecondsSinceEpoch.toString();
    productChatReference
        .child(chatId)
        .child("chatUsers")
        .child(currentUserModel.uid)
        .update({
      "hide": true,
      "connectTime": exitTime,
      //"111357489031227818227": true,
    });
  }
}
