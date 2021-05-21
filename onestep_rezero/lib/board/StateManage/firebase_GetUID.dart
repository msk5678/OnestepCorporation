import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserUID {
  static String getId() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // print(_auth.currentUser.uid + "uid 출력");
    return _auth.currentUser.uid;
  }
}
