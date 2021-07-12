import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:random_string/random_string.dart';
import '../../loggedInWidget.dart';

String downloadURL = "";

Future<void> profileChange() async {
  // 프사 변경할때 image 가져오고 storage 저장 후 photoUrl 업데이트
  io.File _image;
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    _image = io.File(pickedFile.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
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
}

void nickNameChange(String text) {
  FirebaseFirestore.instance
      .collection("user")
      .doc(currentUserModel.uid)
      .update({"nickName": text});
}
