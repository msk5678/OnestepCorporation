import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoSettingsPage.dart';
import 'package:onestep_rezero/myinfo/providers/providers.dart';
import 'package:onestep_rezero/notification/realtime/firebase_api.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

String downloadURL = "";

// final _storage = FirebaseStorage.instanceFor(
//     bucket: 'gs://onestep-project.appspot.com/user images');
//
class MyProfileImage extends ConsumerWidget {
  // stroage 삭제 보류
  // Future<void> deleteImageFromDB(String imageUrl) async {
  //   var photo = _storage.refFromURL(imageUrl);
  //   await photo.delete();
  // }
  // Future<void> deleteFile(String url) async {
  //   try {
  //     await FirebaseStorage.instance.refFromURL(url).delete();
  //   } catch (e) {
  //     print("Error deleting db from cloud: $e");
  //   }
  // }
  //
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseApi.getId())
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 30,
                  MediaQuery.of(context).size.width / 30,
                  0,
                  0),
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data.data()['photoUrl'].toString(),
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.height / 9,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error), // 로딩 오류 시 이미지
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }
}
