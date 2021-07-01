import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_platform_interface/src/user_info.dart';

Future<void> joinNickNameDML(List<UserInfo> user, String text) async {
  await FirebaseFirestore.instance
      .collection('user')
      .doc(user.single.uid)
      .set({
        // 원래 0 이었는데 일단 1로 변경
        "auth": 1, // 대학인증여부 0 : 안됨, 1 : 인증대기중, 2 : 인증 완료
        "authTime": 0, // 학교 인증시간
        "uid": user.single.uid, // uid
        "nickName": text, // 닉네임
        "imageUrl": user.single.photoURL, // 사진
        // "email": _emailController.text, // 이메일
        "reportState": 0, // 제재 확인
        // "reportTime": 0, // 제재 시간
        "university": "", // 학교이름
        "universityEmail": "", // 학교이메일
        "joinTime": DateTime.now().microsecondsSinceEpoch, // 가입시간
      })
      .whenComplete(() => {
            FirebaseFirestore.instance
                .collection('user')
                .doc(user.single.uid)
                .collection("chatCount")
                .doc(user.single.uid)
                .set({
              "productChatCount": 0,
              "boardChatCount": 0,
            })
          })
      .whenComplete(() => {
            FirebaseFirestore.instance
                .collection('user')
                .doc(user.single.uid)
                .collection("notification")
                .doc(user.single.uid)
                .set({
              "marketing": 0,
              "push": 0,
            })
          });
}
