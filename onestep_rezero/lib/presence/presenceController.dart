import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class PresenceController {
  DocumentReference userDocumentReference =
      FirebaseFirestore.instance.collection('user').doc(currentUserModel.uid);

  CollectionReference userDocumentReference2 =
      FirebaseFirestore.instance.collection('user');

  final DatabaseReference userRealtimeDatabaseReference = FirebaseDatabase
      .instance
      .reference()
      .child('user')
      .child("${currentUserModel.uid}");

  storeUserData() async {
    //초기 값 저장
    Map<String, dynamic> presenceData = {
      "presence": true,
      "lastConnectTime": DateTime.now().millisecondsSinceEpoch.toString(),
    };

    await userDocumentReference.update(presenceData).whenComplete(() {
      print("User data added");
    }).catchError((e) => print(e));
  }

  Stream<QuerySnapshot> retrieveUsers() {
    //모든 유저
    Stream<QuerySnapshot> queryUsers = userDocumentReference2
        .orderBy('last_seen', descending: true)
        .snapshots();
    return queryUsers;
  }

  updateUserPresence() async {
    Map<String, dynamic> presenceStatusTrue = {
      'presence': true,
      'lastConnectTime': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    await userRealtimeDatabaseReference
        .update(presenceStatusTrue)
        .whenComplete(() => print('Updated your presence.'))
        .catchError((e) => print(e));

    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };

    userRealtimeDatabaseReference.onDisconnect().update(presenceStatusFalse);
  }
}
