import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
class ProductChatMainController {
  //Chat Main ChatCount
  StreamBuilder getNewProductChatCountText() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(currentUserModel.uid)
            .collection("chatCount")
            .doc(currentUserModel.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data.toString());
          } else
            return Text("error");
          if (snapshot.data.data()['productChatCount'] != null) {
            //print("####누적 채팅 : ${snapshot.data.data()['nickname']}");
          }
          return Text(
            snapshot.data.data()['productChatCount'].toString() + '개',
            style: TextStyle(
              color: //
                  // OnestepColors().mainColor,
                  snapshot.data.data()['productChatCount'] == 0
                      ? Colors.grey
                      : Colors.green,
              // Colors.green,
              fontSize: 10,
            ),
          );
        });
  }

  StreamBuilder getTotalChatCountInBottomBar() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(currentUserModel.uid)
            .collection("chatCount")
            .doc(currentUserModel.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //return Text("dd");
          // if (snapshot == null) {
          //   return Text("d");
          // } else
          if (snapshot.hasData) {
            // print(snapshot.data.toString());
          } else
            return Icon(
              Icons.notifications_none,
              size: 25,
              // color: Colors.black,
            );

          if (snapshot.data.data()['productChatCount'] == 0 &&
              snapshot.data.data()['boardChatCount'] == 0) {
            return Stack(
              children: [
                new Icon(
                  Icons.notifications_none,
                  size: 25,
                  // color: Colors.black,
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
                  // color: Colors.black,
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
