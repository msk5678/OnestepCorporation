import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/login/models/joinFlag.dart';

final emailCheckProvider = StateNotifierProvider<EmailCheckProvider>((ref) {
  return EmailCheckProvider();
});

class EmailCheckProvider extends StateNotifier<bool> {
  EmailCheckProvider() : super(false);

  void authEmailNickNameCheck(String tempEmail) async {
    if (tempEmail == "" || !tempEmail.contains("@")) {
      state = false;
    } else {
      QuerySnapshot ref = await FirebaseFirestore.instance
          .collection('users')
          .where("userEmail", isEqualTo: tempEmail)
          .get();

      List<QueryDocumentSnapshot> docRef = ref.docs;
      state = docRef.isEmpty;
    }
  }
}

// final emailCheckProvider = ChangeNotifierProvider<EmailCheckProvider>((ref) {
//   return EmailCheckProvider();
// });

// class EmailCheckProvider extends ChangeNotifier {
//   JoinFlag joinFlag = JoinFlag();

//   void authEmailNickNameCheck(String tempEmail) async {
//     if (tempEmail == "") {
//     } else {
//       QuerySnapshot ref = await FirebaseFirestore.instance
//           .collection('users')
//           .where("userEmail", isEqualTo: tempEmail)
//           .get();

//       List<QueryDocumentSnapshot> docRef = ref.docs;
//       if (docRef.isEmpty) {
//         joinFlag.isEmailChecked = true;
//         notifyListeners();
//       } else {
//         joinFlag.isEmailChecked = false;
//         notifyListeners();
//       }
//     }
//   }
// }

final nickNameProvider = StateNotifierProvider<NickNameProvider>((ref) {
  return NickNameProvider();
});

class NickNameProvider extends StateNotifier<bool> {
  NickNameProvider() : super(false);

  void authEmailNickNameCheck(String tempNickName) async {
    if (tempNickName == "") {
      state = false;
    } else {
      QuerySnapshot ref = await FirebaseFirestore.instance
          .collection('users')
          .where("nickName", isEqualTo: tempNickName)
          .get();
      List<QueryDocumentSnapshot> docRef = ref.docs;
      state = docRef.isEmpty;
    }
  }
}

final emailValueProvider = StateProvider<String>((ref) {
  return 'naver.com';
});

final statusProvider = StateNotifierProvider<StatusProvider>((ref) {
  return StatusProvider();
});

class StatusProvider extends StateNotifier<bool> {
  StatusProvider() : super(true);

  void changeStatus(String value) {
    if (value == "재학생") {
      state = true;
    } else {
      state = false;
    }
  }
}
