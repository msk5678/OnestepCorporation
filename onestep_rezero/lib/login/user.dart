import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final int auth;
  final int authTime;

  final String uid;
  final String nickName;
  final String imageUrl;
  final String email;
  final int reportPoint;

  final String university;
  final String universityEmail;

  final int joinTime;

  const User({
    this.auth,
    this.authTime,
    this.uid,
    this.nickName,
    this.imageUrl,
    this.email,
    this.reportPoint,
    this.university,
    this.universityEmail,
    this.joinTime,
  });

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      auth: document['auth'],
      authTime: document['authTime'],
      uid: document['uid'],
      nickName: document['nickName'],
      imageUrl: document['imageUrl'],
      email: document['email'],
      reportPoint: document['reportPoint'],
      university: document['university'],
      universityEmail: document['universityEmail'],
      joinTime: document['joinTime'],
    );
  }
}
