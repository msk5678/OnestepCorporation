import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/models/product.dart';

class ProductChatController {
  //Product Chat Count
  static final DatabaseReference productChatReference =
      FirebaseDatabase.instance
          .reference()
          .child("university")
          .child("KMU") //향후 대학교 id값 가져와서 추가
          .child("chat")
          .child("productchat");

  int productChatcount = 0;

  //채팅방 생성 시 상대방 정보 내부 저장 / 채팅방 정보 fb 저장
  Future<void> createProductChattingRoomToRealtimeDatabase(
      String friendUid, String postId, String chatId) async {
    String myUid = googleSignIn.currentUser.id;
    try {
      //1.

      //2. users 판매자 정보 가져오기 : 판매자 닉네임, 이미지 가져오기
      FirebaseFirestore.instance
          .collection("users")
          .doc(friendUid)
          .get()
          .then((uservalue) {
        //읽어온 상대방 정보 내부db 저장
        print("FriendNickname test");
        print("FriendNickname : ${uservalue["nickName"].toString()}");
        print("FriendNickImage : ${uservalue["photoUrl"].toString()}");
      }).whenComplete(
        () {
          var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
//Realtime data base
          productChatReference.child(chatId)
              //.child("roominfo")
              .set({
            "chatId": chatId,
            "postId": postId,
            "createTime": nowTime,
            "recentTime": nowTime,
            "recentText": "채팅방이 생성되었습니다.",
            "chatUsers": {
              myUid: {
                "uid": myUid,
                "connextTime": nowTime,
                "hide": false,
              },
              friendUid: {
                "uid": friendUid,
                "connextTime": nowTime,
                "hide": false,
              },
            },
          }).whenComplete(() {
            onSendToProductMessage(
                "1618662154938", "108438757310040285856", "디폴트로 생성해줌", 0);

            productChatReference
                .child(chatId)
                //.child("roominfo")
                .once()
                .then((DataSnapshot snapshot) {
              print('Data : ${snapshot.value}');
            });
          }); //채팅방 생성 whenComplete
        },
      ); //product whencomplete
    } //users whencomplete
    catch (e) {
      print(e.message);
    }
  }

  Future getUserId(String proUserId) async {
    return FirebaseFirestore.instance.collection('users').doc(proUserId).get();
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
              return Column(
                children: [
                  Expanded(
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
                  ),
                ],
              );
            }
        }
      },
    );
  }

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  _fetchData(String proUserId) {
    return this._memoizer.runOnce(() async {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(proUserId)
          .get();
    });
  }

  FutureBuilder getProductUserNickname(String proUserId) {
    print("Future 연결");
    return FutureBuilder(
      future: getUserId(proUserId),
      // _fetchData(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          //return CircularProgressIndicator();
          default:
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }

            if (snapshot.data['nickName'] == "") {
              return Text("닉네임 오류");
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              );
            } else {
              return Text(
                snapshot.data['nickName'],
                style: TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
        }
      },
    );
  }

  Future getProductInfo(String postId) async {
    return FirebaseFirestore.instance.collection('products').doc(postId).get();
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

  Future<void> setToFirebaseProductChatCount(int chatCount) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(googleSignIn.currentUser.id.toString())
        .collection("chatcount")
        .doc(googleSignIn.currentUser.id.toString())
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

  bool onSendToProductMessage(
      String chatId, String friendId, var contentMsg, int type) {
    //type = 0 its text msg
    //type = 1 its imageFile
    //type = 2 its sticker image
    //contentMsg.characters;
    var content;
    if (contentMsg != null) {
      if (contentMsg.runtimeType == Product) {
        // 프로덕트 타입이면 contentMsg 변경
        Map<String, String> productContent = {
          'title': '${contentMsg.title}',
          'price': '${contentMsg.price}',
          'imageUrl': '${contentMsg.images[0]}',
        };

        content = productContent;
        print("maptest $content");
      } else {
        content = contentMsg;
      }
      print("maptest1 컨텐츠저장완");
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();
      print("maptest1-1 $chatId $messageId");
//RealTime
      DatabaseReference productChatMessageReference =
          productChatReference.child(chatId).child("message").child(messageId);
      print("maptest1-2");
      DatabaseReference productChatListReference =
          productChatReference.child(chatId);
      print("maptest2");
      productChatMessageReference.set({
        "idFrom": googleSignIn.currentUser.id,
        "idTo": {friendId: false},
        "sendTime": messageId,
        "content": content,
        "type": type,
        "isRead": false,
        //"isRead": false,
      }).whenComplete(() {
        print("maptest3 저장성공");
        switch (type) {
          case 1:
            content = "사진을 보냈습니다.";
            break;
          case 2:
            content = "이모티콘을 보냈습니다.";
            break;
        }
        if (contentMsg.runtimeType != Product) {
          productChatListReference.update({
            "recentText": content,
            "recentTime": messageId,
          });
        }
      });
      return true;
    } //if
    else {
      Fluttertoast.showToast(msg: 'Empty Message. Can not be send.');
      return false;
    }
  }

  Future<void> updateReadMessage(
      String chattingRoomId, String messageId) async {
    DatabaseReference productChatMessageReference = productChatReference
        .child(chattingRoomId)
        .child("message")
        .child(messageId)
        .child("idTo");
    productChatMessageReference.update({
      googleSignIn.currentUser.id: true,
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

  void createProductInfoMessage(Product product) {}
//   void onSendToProductMessage(
//     ProductSendMessage productSendMessage,
//   ) {
//     String contentMsg = productSendMessage.contentMsg;
//     int type = productSendMessage.type;
//     String myId = googleSignIn.currentUser.id.toString();
//     String friendId = productSendMessage.friendId;
//     String chattingRoomId = productSendMessage.chattingRoomId;
//     TextEditingController textEditingController =
//         productSendMessage.textEditingController;
//     ScrollController listScrollController =
//         productSendMessage.listScrollController;

//     //type = 0 its text msg
//     //type = 1 its imageFile
//     //type = 2 its sticker image
//     if (contentMsg != "") {
//       textEditingController.clear();
//       String messageId = DateTime.now().millisecondsSinceEpoch.toString();

// //RealTime
//       DatabaseReference productChatMessageReference = FirebaseDatabase.instance
//           .reference()
//           .child("chat")
//           .child("productchat")
//           .child(chattingRoomId)
//           .child("message")
//           .child(messageId);

//       DatabaseReference productChatReference = FirebaseDatabase.instance
//           .reference()
//           .child("chat")
//           .child("productchat")
//           .child(chattingRoomId);

//       productChatMessageReference.set({
//         "idFrom": myId,
//         "idTo": {friendId: false},
//         //"idTo": friendId,
//         "timestamp": messageId,
//         "content": contentMsg,
//         "type": type,
//         //"isRead": false,
//       }).whenComplete(() {
//         switch (type) {
//           case 1:
//             contentMsg = "사진을 보냈습니다.";
//             break;
//           case 2:
//             contentMsg = "이모티콘을 보냈습니다.";
//             break;
//         }
//         productChatReference.update({
//           "recentText": contentMsg,
//           "timestamp": messageId,
//         });
//       });

//       listScrollController.animateTo(0.0,
//           duration: Duration(microseconds: 300), curve: Curves.easeOut);
//     } //if
//     else {
//       Fluttertoast.showToast(msg: 'Empty Message. Can not be send.');
//     }
//   }

//   Future<void> setToFirebaseProductChatCount(int chatCount) async {
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(googleSignIn.currentUser.id.toString())
//         .collection("chatcount")
//         .doc(googleSignIn.currentUser.id.toString())
//         .update({
//       "productchatcount": chatCount,
//     }).whenComplete(() {
//       //Fluttertoast.showToast(msg: '채팅방카운트를 업데이트했습니다.');
//       print("##챗카운트 업데이트 성공");
//     }).catchError((onError) {
//       Fluttertoast.showToast(msg: '채팅방카운트를 업데이트 실패.');
//       print(onError);
//     });
//   }

//   //Chat Main ChatCount
//   StreamBuilder getProductCountText() {
//     return StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(googleSignIn.currentUser.id.toString())
//             .collection("chatcount")
//             .doc(googleSignIn.currentUser.id.toString())
//             .snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasData) {
//             print(snapshot.data.toString());
//           } else
//             return Text("error");
//           if (snapshot.data.data()['productchatcount'] != null) {
//             //print("####누적 채팅 : ${snapshot.data.data()['nickname']}");
//           }
//           return Text(
//             snapshot.data.data()['productchatcount'].toString(),
//             style: TextStyle(fontSize: 8, color: Colors.white),
//           );
//         });
//   }

//   StreamBuilder getTotalChatCountInBottomBar() {
//     return StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(googleSignIn.currentUser.id.toString())
//             .collection("chatcount")
//             .doc(googleSignIn.currentUser.id.toString())
//             .snapshots(),
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           //return Text("dd");
//           // if (snapshot == null) {
//           //   return Text("d");
//           // } else
//           if (snapshot.hasData) {
//             print(snapshot.data.toString());
//           } else
//             return Text("error");

//           if (snapshot.data.data()['productchatcount'] == 0 &&
//               snapshot.data.data()['boardchatcount'] == 0) {
//             return Stack(
//               children: [
//                 new Icon(
//                   Icons.notifications_none,
//                   size: 25,
//                   color: Colors.black,
//                 ),
//                 Positioned(
//                   top: 1,
//                   right: 1,
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 15,
//                         height: 15,
//                         decoration: BoxDecoration(),
//                         child: Center(
//                           child: Text(""),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           } else if (snapshot.data.data()['productchatcount'] > 0 ||
//               snapshot.data.data()['boardchatcount'] > 0) {
//             return Stack(
//               children: [
//                 new Icon(
//                   Icons.notifications_none,
//                   size: 25,
//                   color: Colors.black,
//                 ),
//                 Positioned(
//                   top: 1,
//                   right: 1,
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 10,
//                         height: 10,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: Colors.red),
//                         child: Center(
//                           child: Text(""),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }
//           return Container();
//         });
//   }

//   Future<void> updateReadMessage(
//       String chattingRoomId, String messageId) async {
//     DatabaseReference productChatMessageReference = FirebaseDatabase.instance
//         .reference()
//         .child("chat")
//         .child("productchat")
//         .child(chattingRoomId)
//         .child("message")
//         .child(messageId)
//         .child("idTo");
//     productChatMessageReference.update({
//       googleSignIn.currentUser.id.toString(): true,
//     });
//   }
}
