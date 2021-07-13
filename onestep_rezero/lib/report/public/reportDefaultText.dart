import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatLocalController.dart';

FutureBuilder getReportDefaulBodytText() {
  return FutureBuilder(
      future: FirebaseDatabase.instance
          .reference()
          .child('reportDefaultText')
          .child('content')
          .once(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            DataSnapshot dataValues = snapshot.data;
            Map<dynamic, dynamic> values = dataValues.value;
            String body;
            values.forEach((key, value) {
              if (key == 'body') {
                body = value;
              }
            });
            return Text(body,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.grey));
        }
      });
}

FutureBuilder getReportDefaulTailtText() {
  return FutureBuilder(
      future: FirebaseDatabase.instance
          .reference()
          .child('reportDefaultText')
          .child('content')
          .once(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            DataSnapshot dataValues = snapshot.data;
            Map<dynamic, dynamic> values = dataValues.value;
            String tail;
            values.forEach((key, value) {
              if (key == 'tail') {
                tail = value;
              }
            });
            return Text(
              tail,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.3,
              ),
            );
        }
      });
}

Future getUserId(String proUserId) async {
  // return this._memoizer.runOnce(() async {
  return FirebaseFirestore.instance.collection('user').doc(proUserId).get();
  // });
}

// 채팅 -> 유저 신고
FutureBuilder getReportUserNickName(
    String chatId, String proUserId, double fontSize) {
  return FutureBuilder(
      future: getUserId(proUserId),
      //_fetchData(proUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          String name =
              ProductChatLocalController().getChatUserNickName(chatId);

          if (chatId == null || name == null) {
            return Text("");
          } else {
            return AutoSizeText(
              ProductChatLocalController().getChatUserNickName(chatId),
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
              ), //15
              minFontSize: 10,
              stepGranularity: 10,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }
        } else {
          if (snapshot.hasData == false) {
            return Text("불러오기 실패");
          } else if (snapshot.hasError) {
            return Text("불러오기 실패");
          } else {
            ProductChatLocalController()
                .setChatUserNickName(chatId, snapshot.data.data()['nickName']);
            return AutoSizeText(
              snapshot.data.data()['nickName'],
              style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold), //15
              minFontSize: 10,
              stepGranularity: 10,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }
        }
      });
}
