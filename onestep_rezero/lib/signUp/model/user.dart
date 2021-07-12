import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final int auth;
  final int authTime;

  final String uid;
  final String nickName;
  final String imageUrl;
  // final String email;
  final int reportState;
  // final Timestamp reportTime;

  final String university;
  final String universityEmail;

  final int joinTime;
  final int pushCheck;

  const User({
    this.auth,
    this.authTime,
    this.uid,
    this.nickName,
    this.imageUrl,
    // this.email,
    this.reportState,
    this.university,
    this.universityEmail,
    this.joinTime,
    // this.reportTime,
    this.pushCheck,
  });

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      auth: document['auth'],
      authTime: document['authTime'],
      uid: document['uid'],
      nickName: document['nickName'],
      imageUrl: document['imageUrl'],
      // email: document['email'],
      reportState: document['reportState'],
      // reportTime: document['reportTime'],
      university: document['university'],
      universityEmail: document['universityEmail'],
      joinTime: document['joinTime'],
      pushCheck: document['pushCheck'],
    );
  }
}
