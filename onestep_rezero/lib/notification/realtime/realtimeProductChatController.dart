import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/notification/model/productSendMessage.dart';
import 'firebase_api.dart';

class RealtimeProductChatController {
  final databaseReference = FirebaseDatabase.instance.reference();
  //Product Chat Count
  DatabaseReference productChatMessageReference = FirebaseDatabase.instance
      .reference()
      .child("chattingroom")
      .child("productchat"); //Chat Message Ref

  DatabaseReference productChatMessageReference2;
  int productChatcount = 0;

  Future<void> createProductChatingRoomToRealtimeFirebaseStorage2(
      ProductSendMessage productSendMessage) async {
    String myUid = FirebaseApi.getId();
    String title;
    String friendUid;
    String productImageUrl;
    // userImageFile,

    try {
      FirebaseFirestore.instance
          .collection("products")
          .doc(productSendMessage.postId)
          .get()
          .then((value) {
        title = value["title"];
        friendUid = value["uid"];
        productImageUrl = value["images"][0];
      }).whenComplete(
        () {
          var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
//Realtime data base
          databaseReference
              .child("chattingroom")
              .child("productchat")
              .child(productSendMessage.chattingRoomId)
              //.child("roominfo")
              .set({
            "boardtype": "장터게시판",
            "title": title,
            "chatId": productSendMessage.chattingRoomId,
            "postId": productSendMessage.postId,
            "users": {
              myUid: true,
              friendUid: true,
            },
            "productImage": productImageUrl,
            "recentText": "채팅방이 생성되었습니다!",
            "timestamp": nowTime,
          }).whenComplete(() {
            databaseReference
                .child("chattingroom")
                .child("productchat")
                .child(productSendMessage.chattingRoomId)
                //.child("roominfo")
                .once()
                .then((DataSnapshot snapshot) {
              print('Data : ${snapshot.value}');

//                      notificationLogger("i", "누가먼저돌까요2 else 방생성안함");
            });

            onSendToProductMessage(productSendMessage);
          }); //채팅방 생성 whenComplete
        },
      );
    } catch (e) {
      print(e.message);
    }
  }

  void onSendToProductMessage(
    ProductSendMessage productSendMessage,
  ) {
    String contentMsg = productSendMessage.contentMsg;
    int type = productSendMessage.type;
    String myId = FirebaseApi.getId();
    String friendId = productSendMessage.friendId;
    String chattingRoomId = productSendMessage.chattingRoomId;
    TextEditingController textEditingController =
        productSendMessage.textEditingController;
    ScrollController listScrollController =
        productSendMessage.listScrollController;

    //type = 0 its text msg
    //type = 1 its imageFile
    //type = 2 its sticker image
    if (contentMsg != "") {
      print("누가먼저돌까요3 메세지 낫 널 $contentMsg");

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
        //"idTo": friendId,
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

  Future getUserId(String proUserId) async {
    return FirebaseFirestore.instance.collection('users').doc(proUserId).get();
  }

  FutureBuilder getProductUserNickname(String proUserId) {
    return FutureBuilder(
      future: getUserId(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          //return CircularProgressIndicator();
          default:
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }

            if (snapshot.data['nickname'] == "") {
              return Text("닉네임 오류");
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              );
            } else {
              return AutoSizeText(
                snapshot.data['nickname'],
                style: TextStyle(fontSize: 15),
                minFontSize: 10,
                stepGranularity: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
        }
      },
    );
  }

  FutureBuilder getUserImage(String proUserId) {
    return FutureBuilder(
      future: getUserId(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          //return CircularProgressIndicator();
          default:
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }

            if (snapshot.data['photoUrl'] == "") {
              //프로필사진 미설정
              return LayoutBuilder(builder: (context, constraint) {
                return Icon(
                  Icons.supervised_user_circle,
                  size: 50,
                  //constraint.biggest.height,
                );
              });
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            } else {
              return Expanded(
                child: CachedNetworkImage(
                  imageUrl: snapshot.data['photoUrl'],
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                ),
                // child: ExtendedImage.network(
                //   snapshot.data['photoUrl'],
                //   fit: BoxFit.cover,
                //   height: 50,
                //   width: 50,
                //   cache: true,
                // ),
              );
            }
        }
      },
    );
  }

  Future<void> setToFirebaseProductChatCount(int chatCount) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseApi.getId())
        .collection("chatcount")
        .doc(FirebaseApi.getId())
        .update({
      "productchatcount": chatCount,
    }).whenComplete(() {
      //Fluttertoast.showToast(msg: '채팅방카운트를 업데이트했습니다.');
      print("##챗카운트 업데이트 성공");
    }).catchError((onError) {
      Fluttertoast.showToast(msg: '채팅방카운트를 업데이트 실패.');
      print(onError);
    });
  }

  //Chat Main ChatCount
  StreamBuilder getProductCountText() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseApi.getId())
            .collection("chatcount")
            .doc(FirebaseApi.getId())
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
          } else
            return Text("error");
          if (snapshot.data.data()['productchatcount'] != null) {
            //print("####누적 채팅 : ${snapshot.data.data()['nickname']}");
          }
          return Text(
            snapshot.data.data()['productchatcount'].toString(),
            style: TextStyle(fontSize: 8, color: Colors.white),
          );
        });
  }

  StreamBuilder getTotalChatCountInBottomBar() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseApi.getId())
            .collection("chatcount")
            .doc(FirebaseApi.getId())
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
          } else
            return Text("error");

          if (snapshot.data.data()['productchatcount'] == 0 &&
              snapshot.data.data()['boardchatcount'] == 0) {
            return Stack(
              children: [
                new Icon(
                  Icons.notifications_none,
                  size: 25,
                  color: Colors.black,
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: Stack(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(),
                        child: Center(
                          child: Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.data.data()['productchatcount'] > 0 ||
              snapshot.data.data()['boardchatcount'] > 0) {
            return Stack(
              children: [
                new Icon(
                  Icons.notifications_none,
                  size: 25,
                  color: Colors.black,
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: Stack(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Center(
                          child: Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        });
  }
}
