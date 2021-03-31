import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoSettingsPage.dart';
import 'package:onestep_rezero/myinfo/providers/providers.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

String downloadURL = "";

class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc('ciih53tTaJa1Q3wB1xjqxeJavEC3')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            return Row(
              children: [
                // 프사 변경도 에타처럼
                IconButton(
                    icon: snapshot.data.data()['photoUrl'].toString() != ""
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  snapshot.data.data()['photoUrl'].toString(),
                              width: 100,
                              // width: MediaQuery.of(context).size.width,
                              // height: MediaQuery.of(context).size.height,
                              height: 100,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error), // 로딩 오류 시 이미지
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.account_circle),
                    color: Colors.black,
                    iconSize: 100,
                    onPressed: () async {
                      // storage 삭제 보류
                      // Reference ref = FirebaseStorage.instance
                      //     .refFromURL(
                      //         snapshot.data.data()['photoUrl'].toString());
                      // await ref.delete();

                      // firebase_storage.FirebaseStorage.instance
                      //     .refFromURL(
                      //         snapshot.data.data()['photoUrl'].toString())
                      //     .delete();

                      // 프사 변경할때 image 가져오고 storage 저장 후 photoUrl 업데이트
                      io.File _image;
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _image = io.File(pickedFile.path);
                        print("_image = $_image");
                      } else {
                        print('No image selected.');
                      }
                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref()
                          .child("user images/${randomAlphaNumeric(15)}");
                      ref.putFile(io.File(_image.path));
                      firebase_storage.UploadTask storageUploadTask =
                          ref.putFile(io.File(_image.path));

                      await storageUploadTask.whenComplete(() async => {
                            downloadURL = await ref.getDownloadURL(),
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc("ciih53tTaJa1Q3wB1xjqxeJavEC3")
                                .update({
                              "photoUrl": downloadURL,
                            }),
                          });
                    }),

                Column(
                  children: [
                    Container(
                      child: Text(
                        "김성훈",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        "계명대학교",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(170, 0, 0, 0),
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    color: Colors.black,
                    iconSize: 30,
                    onPressed: () async {
                      // SharedPreferences 내부 db
                      SharedPreferences _prefsPush;
                      SharedPreferences _prefsMarketing;
                      _prefsPush = await SharedPreferences.getInstance();
                      // set 부분은 추후에 회원가입할때 푸시 알림 받으시겠습니까? ok -> true, no -> false
                      // 줘서 로그인할때 set 해주는 코드 넣기 지금은 임시
                      _prefsPush.setBool('value', true);
                      context
                          .read(switchCheckPush)
                          .changeSwitch(_prefsPush.getBool('value'));
                      _prefsMarketing = await SharedPreferences.getInstance();
                      _prefsMarketing.setBool('value', true);
                      context
                          .read(switchCheckMarketing)
                          .changeSwitch(_prefsMarketing.getBool('value'));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MyinfoSettingsPage(_prefsPush, _prefsMarketing)));
                    },
                  ),
                )
              ],
            );
        }
      },
    );
  }
}
