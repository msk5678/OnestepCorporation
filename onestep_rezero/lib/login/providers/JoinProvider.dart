import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailCheckProvider = StateNotifierProvider<EmailCheckProvider>((ref) {
  return EmailCheckProvider();
});

class EmailCheckProvider extends StateNotifier<bool> {
  EmailCheckProvider() : super(false);

  void authEmailNickNameCheck(String tempEmail) async {
    if (tempEmail == "") {
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
          .where("nickname", isEqualTo: tempNickName)
          .get();

      List<QueryDocumentSnapshot> docRef = ref.docs;
      state = docRef.isEmpty;
    }
  }
}
