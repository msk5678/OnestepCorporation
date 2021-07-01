import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/signIn/google_sign_in.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoNickNameChagnePage.dart';
import 'package:onestep_rezero/utils/floatingSnackBar.dart';

import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialog.dart';
import 'package:random_string/random_string.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

String downloadURL = "";

class SettingsBody extends ConsumerWidget {
  // final SharedPreferences _prefsPush;
  // final SharedPreferences _prefsMarketing;
  // SettingsBody(this._prefsPush, this._prefsMarketing);
  SettingsBody();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final _isSwitchCheckPush = watch(switchCheckPush.state);
    // final _isSwitchCheckMarketing = watch(switchCheckMarketing.state);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 20,
          //       MediaQuery.of(context).size.width / 20, 0, 0),
          //   child: Container(
          //     child: Text(
          //       "알림 설정",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
          // InkWell(
          //   onTap: () {},
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(
          //         MediaQuery.of(context).size.width / 20,
          //         MediaQuery.of(context).size.width / 30,
          //         0,
          //         0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Container(
          //           child: Text(
          //             "푸시 알림 설정",
          //             style: TextStyle(fontSize: 15),
          //           ),
          //         ),
          //         // Switch(
          //         //   value: _isSwitchCheckPush,
          //         //   onChanged: (value) {
          //         //     context.read(switchCheckPush).changeSwitch(value);
          //         //     _prefsPush.setBool('value', value);
          //         //   },
          //         //   activeTrackColor: Colors.lightGreenAccent,
          //         //   activeColor: Colors.green,
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
          // InkWell(
          //   onTap: () {},
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(
          //         MediaQuery.of(context).size.width / 20, 0, 0, 0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Container(
          //           child: Text(
          //             "마케팅 알림 설정",
          //             style: TextStyle(fontSize: 15),
          //           ),
          //         ),
          //         // Switch(
          //         //   value: _isSwitchCheckMarketing,
          //         //   onChanged: (value) {
          //         //     context.read(switchCheckMarketing).changeSwitch(value);
          //         //     _prefsMarketing.setBool('value', value);
          //         //   },
          //         //   activeTrackColor: Colors.lightGreenAccent,
          //         //   activeColor: Colors.green,
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
          // Divider(
          //   thickness: 2,
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 20,
                MediaQuery.of(context).size.width / 20, 0, 0),
            child: Container(
              child: Text(
                "사용자 설정",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              // // storage 삭제 보류
              // Reference ref = FirebaseStorage.instance
              //     .refFromURL(
              //         snapshot.data.data()['imageUrl'].toString());
              // await ref.delete();

              // firebase_storage.FirebaseStorage.instance
              //     .refFromURL(
              //         snapshot.data.data()['imageUrl'].toString())
              //     .delete();

              // 프사 변경할때 image 가져오고 storage 저장 후 photoUrl 업데이트
              io.File _image;
              final picker = ImagePicker();
              final pickedFile =
                  await picker.getImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                _image = io.File(pickedFile.path);
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
                          .collection("user")
                          .doc(currentUserModel.uid)
                          .update({
                        "imageUrl": downloadURL,
                      }),
                    });
                print("_image = $_image");
              } else {
                print('No image selected.');
              }
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 20,
                  MediaQuery.of(context).size.width / 30,
                  0,
                  0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "프로필사진 변경",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () async {
                      // // storage 삭제 보류
                      // Reference ref = FirebaseStorage.instance
                      //     .refFromURL(
                      //         snapshot.data.data()['imageUrl'].toString());
                      // await ref.delete();

                      // firebase_storage.FirebaseStorage.instance
                      //     .refFromURL(
                      //         snapshot.data.data()['imageUrl'].toString())
                      //     .delete();

                      // 프사 변경할때 image 가져오고 storage 저장 후 photoUrl 업데이트
                      io.File _image;
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _image = io.File(pickedFile.path);
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
                                  .collection("user")
                                  .doc(currentUserModel.uid)
                                  .update({
                                "imageUrl": downloadURL,
                              }),
                            });
                        print("_image = $_image");
                      } else {
                        print('No image selected.');
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => MyinfoNickNameChangePage()),
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 20, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "닉네임 변경",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MyinfoNickNameChangePage()),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 20,
                MediaQuery.of(context).size.width / 20, 0, 0),
            child: Container(
              child: Text(
                "기타",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // InkWell(
          //   onTap: () {},
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(
          //         MediaQuery.of(context).size.width / 20,
          //         MediaQuery.of(context).size.width / 30,
          //         0,
          //         0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Container(
          //           child: Text(
          //             "언어설정",
          //             style: TextStyle(fontSize: 15),
          //           ),
          //         ),
          //         IconButton(
          //           icon: Icon(Icons.keyboard_arrow_right),
          //           onPressed: () {},
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              OnestepCustomDialog.show(context,
                  title: "로그아웃 하시겠습니까?",
                  confirmButtonText: "확인",
                  cancleButtonText: "취소", confirmButtonOnPress: () {
                context
                    .read(googleSignInProvider)
                    .logout()
                    .catchError((error, stackTrace) {
                  FloatingSnackBar.show(
                    context,
                    "로그아웃 실패",
                  );
                }).whenComplete(() {
                  FloatingSnackBar.show(
                    context,
                    "로그아웃 되었습니다.",
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainPage()));
                });
              });
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 20,
                  MediaQuery.of(context).size.width / 30,
                  0,
                  0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "로그아웃",
                      style: TextStyle(fontSize: 15, color: Colors.red[200]),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
