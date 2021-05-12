import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onestep_rezero/main.dart';

class ProductChatController {
  final databaseReference = FirebaseDatabase.instance.reference();
  //Product Chat Count
  DatabaseReference productChatMessageReference = FirebaseDatabase.instance
      .reference()
      .child("university")
      .child("계명대학교") //향후 대학교 id값 가져와서 추가
      .child("chat")
      .child("productchat");

  DatabaseReference productChatMessageReference2;
  int productChatcount = 0;

  //채팅방 생성 시 상대방 정보 내부 저장 / 채팅방 정보 fb 저장
  Future<void> createProductChattingRoomToRealtimeDatabase(
      String friendUid, String postId, String chattingRoomId) async {
    String myUid = googleSignIn.currentUser.id;
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
          productChatMessageReference.child(chattingRoomId)
              //.child("roominfo")
              .set({
            "chatId": chattingRoomId,
            "postId": postId,
            "createTime": nowTime,
            "recentTime": nowTime,
            "recentText": "채팅방이 생성되었습니다.",
            "chatUsers": {
              "user1": {
                "uid": myUid,
                "connextTime": nowTime,
                "hide": true,
              },
              "user2": {
                "uid": myUid,
                "connextTime": nowTime,
                "hide": true,
              },
            },
          }).whenComplete(() {
            databaseReference
                .child("chat")
                .child("productchat")
                .child(chattingRoomId)
                //.child("roominfo")
                .once()
                .then((DataSnapshot snapshot) {
              print('Data : ${snapshot.value}');
            });

            //onSendToProductMessage(productSendMessage);
          }); //채팅방 생성 whenComplete
        },
      ); //product whencomplete
    } //users whencomplete
    catch (e) {
      print(e.message);
    }
  }

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
