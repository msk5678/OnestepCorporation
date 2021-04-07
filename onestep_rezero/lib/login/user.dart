import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String authUniversity;

  final String uid;
  final String nickName;
  final String photoUrl;

  final String userEmail;
  final int userLevel;
  final int userScore;
  final String userUniversity;
  final String userUniversityEmail;

  final DateTime timeStamp;

  const User({
    this.authUniversity,
    this.uid,
    this.nickName,
    this.photoUrl,
    this.userEmail,
    this.userLevel,
    this.userScore,
    this.userUniversity,
    this.userUniversityEmail,
    this.timeStamp,
  });

  factory User.fromDocument(DocumentSnapshot document) {
    return User(
      authUniversity: document['authUniversity'],
      uid: document['uid'],
      nickName: document['nickName'],
      photoUrl: document['photoUrl'],
      userEmail: document['userEmail'],
      userLevel: document['userLevel'],
      userScore: document['userScore'],
      userUniversity: document['userUniversity'],
      userUniversityEmail: document['userUniversityEmail'],
      timeStamp: document['timeStamp'].toDate(),
    );
  }
}
