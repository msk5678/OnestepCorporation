import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/notification/realtime/firebase_api.dart';
import 'package:onestep_rezero/sendMail.dart';
import 'package:random_string/random_string.dart';

String downloadURL = "";
bool _isDownloadCheck = false;
io.File _image;

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("증명서"),
        content: Text("메일 보내기 성공"),
        actions: <Widget>[
          ElevatedButton(
            child: Text("확인"),
            onPressed: () {
              // 메모장확인
              // FirebaseFirestore.instance
              //     .collection('users')
              //     .doc(FirebaseApi.getId())
              //     .update({"authUniversity": wait});
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      );
    },
  );
}

class LoginCertificatePage extends StatefulWidget {
  @override
  _LoginCertificatePageState createState() => _LoginCertificatePageState();
}

class _LoginCertificatePageState extends State<LoginCertificatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '증명서인증',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _isDownloadCheck == true
                ? Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(_image),
                            fit: BoxFit.fill // here add your image file path
                            )),
                  )
                : IconButton(
                    icon: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                    color: Colors.black,
                    iconSize: 300,
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _image = io.File(pickedFile.path);
                        _isDownloadCheck = true;

                        print("_image = $_image");
                      } else {
                        print('No image selected.');
                      }
                      setState(() {});
                    }),
          ),
          ElevatedButton(
              onPressed: () async {
                _showDialog(context);
                // 증명서 storage 저장
                // String ramdomNum = randomAlphaNumeric(15);
                // firebase_storage.Reference ref = firebase_storage
                //     .FirebaseStorage.instance
                //     .ref()
                //     .child("certificate images/$ramdomNum}");
                // ref.putFile(io.File(_image.path));
                // firebase_storage.UploadTask storageUploadTask =
                //     ref.putFile(io.File(_image.path));
                // await storageUploadTask.whenComplete(() async => {
                //       downloadURL = await ref.getDownloadURL(),
                //       sendCertificateAuth(downloadURL, ramdomNum)
                //     });

                // authUniversity : wait 로 update
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseApi.getId())
                    .update({"authUniversity": 'wait'});
              },
              child: Container(
                child: Text("보내기"),
              ))
        ],
      ),
    );
  }
}
