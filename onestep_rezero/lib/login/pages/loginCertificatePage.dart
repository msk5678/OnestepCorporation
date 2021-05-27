import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/main.dart';
import 'package:random_string/random_string.dart';
import '../../sendMail.dart';

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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        setState(() {
          downloadURL = "";
          _isDownloadCheck = false;
          _image = null;
        });
        return Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '증명서인증',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                downloadURL = "";
                _isDownloadCheck = false;
                _image = null;
              });
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
          ),
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
                onPressed: _image != null
                    ? () async {
                        _showDialog(context);
                        // // 증명서 storage 저장
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

                        // FirebaseFirestore.instance
                        //     .collection("user")
                        //     .doc(googleSignIn.currentUser.id)
                        //     .update({"auth": 1});
                      }
                    : null,
                child: Container(
                  child: Text("보내기"),
                ))
          ],
        ),
      ),
    );
  }
}
