import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailCheckProvider = StateNotifierProvider<EmailCheckProvider>((ref) {
  return EmailCheckProvider();
});

class EmailCheckProvider extends StateNotifier<bool> {
  EmailCheckProvider() : super(false);

  void authEmailNickNameCheck(String tempEmail) async {
    // String email = tempEmail;
    // final bool isValid = EmailValidator.validate(email);

    // if (tempEmail == "" || !isValid) {
    int emailLength = tempEmail.length;
    bool emailFlag = false;
    (emailLength >= 2 && emailLength < 10)
        ? emailFlag = true
        : emailFlag = false;
    if (tempEmail == "" || emailFlag == false) {
      state = false;
    } else {
      QuerySnapshot ref = await FirebaseFirestore.instance
          .collection('user')
          .where("email", isEqualTo: tempEmail)
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
    int nickNameLength = tempNickName.length;
    bool nickNameFlag = false;
    (nickNameLength >= 2 && nickNameLength < 10)
        ? nickNameFlag = true
        : nickNameFlag = false;
    if (tempNickName == "" || nickNameFlag == false) {
      state = false;
    } else {
      QuerySnapshot ref = await FirebaseFirestore.instance
          .collection('user')
          .where("nickName", isEqualTo: tempNickName)
          .get();
      List<QueryDocumentSnapshot> docRef = ref.docs;
      state = docRef.isEmpty;
    }
  }
}
