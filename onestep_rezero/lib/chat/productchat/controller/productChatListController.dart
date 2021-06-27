import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatLocalController.dart';
import 'package:onestep_rezero/loggedInWidget.dart';

class ProductChatListController {
  //Chat List
  Future<void> setToFirebaseProductChatCount(int chatCount) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(currentUserModel.uid)
        .collection("chatCount")
        .doc(currentUserModel.uid)
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

  Future getUserId(String proUserId) async {
    // return this._memoizer.runOnce(() async {
    return FirebaseFirestore.instance.collection('user').doc(proUserId).get();
    // });
  }

  FutureBuilder getUserImage(String chatId, String proUserId) {
    return FutureBuilder(
      future: getUserId(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            //return CircularProgressIndicator();

            return
                // Text("dd");
                // Material(child: Text("대기1"));
                Material(
              child: CachedNetworkImage(
                imageUrl:
                    ProductChatLocalController().getChatUserimageUrl(chatId),
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              clipBehavior: Clip.hardEdge,
            );
          default:
            if (snapshot.hasData == false) {
              return Material(
                child: CachedNetworkImage(
                  imageUrl: chatId,
                  // productMessage.content.imageUrl,
                  fit: BoxFit.cover,
                  height: 35,
                  width: 35,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
                clipBehavior: Clip.hardEdge,
              );
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
              print("@@@@url");
              // Hive.box('localChatList')
              //     .put('$chatId + image', snapshot.data['imageUrl']);
              ProductChatLocalController()
                  .setChatUserimageUrl(chatId, snapshot.data['imageUrl']);
              // print("1. 가져온 url  : ${snapshot.data['imageUrl']}");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Material(
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data['imageUrl'],
                      // productMessage.content.imageUrl,
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                ],
              );
            }
        }
      },
    );
  }

  FutureBuilder getProductUserNickName(
      String chatId, String proUserId, double fontSize) {
    return FutureBuilder(
      future: getUserId(proUserId),
      //_fetchData(proUserId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // return Text("대기");

            return AutoSizeText(
              //
              "장터 -> 채팅 넘어가면 null임 "
              // +Hive.box('localChatList').get('$chatId + nickName')
              ,
              style: TextStyle(fontSize: fontSize, color: Colors.black), //15
              minFontSize: 10,
              stepGranularity: 10,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          // return Text("");
          default:
            if (snapshot.hasData == false) {
              return AutoSizeText(
                ProductChatLocalController().getChatUserNickName(chatId),
                style: TextStyle(fontSize: fontSize, color: Colors.black), //15
                minFontSize: 10,
                stepGranularity: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            } else if (snapshot.hasError) {
              print("nick 에러.");
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: fontSize), //15
              );
            } else if (snapshot.data['nickName'] == "") {
              return Text("닉오류");
            } else {
              print("@@@@name");
              ProductChatLocalController().setChatUserNickName(
                  chatId, snapshot.data.data()['nickName']);
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
}
