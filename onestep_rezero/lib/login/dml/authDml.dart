import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onestep_rezero/login/model/user.dart' as MYUSER;
import '../../loggedInWidget.dart';

Future<void> authEmailDML(
    List<UserInfo> user, String uniName, String email) async {
  FirebaseFirestore.instance.collection('user').doc(user.single.uid).update({
    "auth": 2,
    "universityEmail": email,
    "university": uniName,
    "authTime": DateTime.now().millisecondsSinceEpoch
  });

  var ref = FirebaseFirestore.instance.collection('user');

  var time = DateTime.now().microsecondsSinceEpoch;
  DocumentSnapshot userRecord = await ref.doc(user.single.uid).get();
  currentUserModel = MYUSER.User.fromDocument(userRecord);
  ref.doc(currentUserModel.uid).collection("log").doc(time.toString()).set({
    "loginTime": time,
  });
}
