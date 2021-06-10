import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductChatController {
  //Product Chat Count
  static final DatabaseReference productChatReference =
      FirebaseDatabase.instance
          .reference()
          .child("university")
          .child(currentUserModel.university) //향후 대학교 id값 가져와서 추가
          .child("chat")
          .child("productchat");

  int productChatcount = 0;

  //채팅방 생성 시 상대방 정보 내부 저장 / 채팅방 정보 fb 저장
  Future<void> createProductChatToRealtimeDatabase(
      String friendUid, String postId, String chatId, Product product) async {
    String myUid = googleSignIn.currentUser.id;
    print("proChatController-createProductChatToRealtimeDatabase 1. 채팅방 생성");
    try {
      //1.

      //2. users 판매자 정보 가져오기 : 판매자 닉네임, 이미지 가져오기
      FirebaseFirestore.instance
          .collection("user")
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
                "connectTime": nowTime,
                "hide": false,
              },
              friendUid: {
                "uid": friendUid,
                "connectTime": nowTime,
                "hide": false,
              },
            },
          }).whenComplete(() {
            print(
                "proChatController-createProductChatToRealtimeDatabase 2. 채팅방 생성 완료, 초기 메세지 생성");

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

  Future getUserId(String proUserId) async {
    return FirebaseFirestore.instance.collection('user').doc(proUserId).get();
  }

  _setChatUserimageUrl(String chatId, String imageUrl) async {
    print("1. 유저 이미지 내부 저장");
    SharedPreferences prefsChatUserImageUrls =
        await SharedPreferences.getInstance();
    await prefsChatUserImageUrls.setString(chatId, imageUrl);
  }

  getChatUserimageUrl(String chatId) async {
    String imageUrl;
    SharedPreferences prefsChatUserPhotoUrls =
        await SharedPreferences.getInstance();
    imageUrl = prefsChatUserPhotoUrls.getString(chatId);
    print("2. 내부 db 값 : GetChatUserPhotoUrl : $imageUrl");

    return imageUrl;
  }

  FutureBuilder getUserImagetoChatroom(String chatId) {
    return FutureBuilder(
        future: getChatUserimageUrl(chatId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasData == false) {
                print("YES ${snapshot.data.toString()}");
                return CircularProgressIndicator();
              } else {
                print("No ${snapshot.data.toString()}");
                return Material(
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data,
                    // productMessage.content.imageUrl,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                  clipBehavior: Clip.hardEdge,
                );
                Text("no");
              }
          }
        });
  }

  FutureBuilder getUserImage(String chatId, String proUserId) {
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

            if (snapshot.data['imageUrl'] == "") {
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
              _setChatUserimageUrl(chatId, snapshot.data['imageUrl']);
              print("1. 가져온 url  : ${snapshot.data['imageUrl']}");
              return Column(
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data['imageUrl'],
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                    // child: ExtendedImage.network(
                    //   snapshot.data['imageUrl'],
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

  // final AsyncMemoizer _memoizer = AsyncMemoizer();

  // _fetchData(String proUserId) {
  //   return this._memoizer.runOnce(() async {
  //     return await FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(proUserId)
  //         .get();
  //   });
  // }

  FutureBuilder getProductUserNickName(String proUserId, double fontSize) {
    return FutureBuilder(
      future: getUserId(proUserId),
      //_fetchData(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          //return CircularProgressIndicator();
          default:
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }
            //print("nick 대기완료.");
            else if (snapshot.hasError) {
              print("nick 에러.");
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: fontSize), //15
              );
            } else if (snapshot.data['nickName'] == "") {
              return Text("닉오류");
            } else {
              return AutoSizeText(
                snapshot.data.data()['nickName'],
                style: TextStyle(fontSize: fontSize, color: Colors.black), //15
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

  Future getProductInfo(String postId) async {
    return FirebaseFirestore.instance
        .collection('university')
        .doc('kmu')
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

  Future<void> setToFirebaseProductChatCount(int chatCount) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(googleSignIn.currentUser.id.toString())
        .collection("chatCount")
        .doc(googleSignIn.currentUser.id.toString())
        .update({
      "productChatCount": chatCount,
    }).whenComplete(() {
      //Fluttertoast.showToast(msg: '채팅방카운트를 업데이트했습니다.');
      // print("##챗카운트 업데이트 성공");
    }).catchError((onError) {
      //Fluttertoast.showToast(msg: '채팅방카운트를 업데이트 실패.');
      print(onError);
    });
  }

  bool onSendToProductMessage(
      String chatId, String friendId, var contentMsg, int type) {
    print(
        "proChatController-onSendToProductMessage 1. 받은 값 확인, 문제없으면 채팅 생성 $chatId $friendId ${contentMsg.runtimeType} $type ");
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
        print(
            "proChatController-onSendToProductMessage 2-1. contentMsg type이 product이면 map형식 생성");
        // 프로덕트 타입이면 contentMsg 변경
        Map<String, String> productContent = {
          'title': '${contentMsg.title}',
          'price': '${contentMsg.price}',
          'imageUrl': '${contentMsg.imagesUrl[0]}',
        };

        content = productContent;
        print("maptest $content");
      } else {
        print(
            "proChatController-onSendToProductMessage 2-2. contentMsg type이 string이면 그대로 생성");
        content = contentMsg;
      }
      print("maptest1 컨텐츠저장완");
      String messageId = DateTime.now().millisecondsSinceEpoch.toString();
      print("proChatController-onSendToProductMessage 2-3. 상대방 hide true면 변경함");
      reConnectProductChat(
          chatId, friendId, messageId); //상대방 hide = true 면 변경하고 수신시간도 바꿈

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
        print("proChatController-onSendToProductMessage 3. 메세지 저장 완료");
        switch (type) {
          case 1:
            content = "사진을 보냈습니다.";
            break;
          case 2:
            content = "이모티콘을 보냈습니다.";
            break;
        }
        if (contentMsg.runtimeType == String) {
          print(
              "proChatController-onSendToProductMessage 4. 채팅방 시간, 최근 정보 업데이트");

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

  void reConnectProductChat(String chatId, String friendId, String sendTime) {
    DatabaseReference productChatFriendRefernce =
        productChatReference.child(chatId).child("chatUsers").child(friendId);
    Map<String, dynamic> friendConnectState;
    productChatFriendRefernce.once().then((DataSnapshot snapshot) {
      if (snapshot.value['hide'] == true) {
        print("proChatContro ${snapshot.value['hide']}");
        print("proChatContro ${snapshot.value['uid']}");
        friendConnectState = {
          "hide": false,
          "connectTime": sendTime,
        };
        productChatFriendRefernce.update(friendConnectState);
      }
    });
  }

  void exitProductChat(String chatId) {
    print("채팅방 나가기. hide = true, currentTime = 0");
    productChatReference
        .child(chatId)
        .child("chatUsers")
        .child(googleSignIn.currentUser.id)
        .update({
      "hide": true,
      "connectTime": 0,
      //"111357489031227818227": true,
    });
  }

  StreamBuilder getTotalChatCountInBottomBar() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(googleSignIn.currentUser.id.toString())
            .collection("chatCount")
            .doc(googleSignIn.currentUser.id.toString())
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //return Text("dd");
          // if (snapshot == null) {
          //   return Text("d");
          // } else
          if (snapshot.hasData) {
            print(snapshot.data.toString());
          } else
            return Text("error");

          if (snapshot.data.data()['productChatCount'] == 0 &&
              snapshot.data.data()['boardChatCount'] == 0) {
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
          } else if (snapshot.data.data()['productChatCount'] > 0 ||
              snapshot.data.data()['boardChatCount'] > 0) {
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
                          shape: BoxShape.circle,
                          color: OnestepColors().secondColor, //red??
                        ),
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
