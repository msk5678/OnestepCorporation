import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/login/model/authFlag.dart';

final schoolEmailCheckProvider =
    ChangeNotifierProvider<SchoolEmailCheckProvider>((ref) {
  return SchoolEmailCheckProvider();
});

class SchoolEmailCheckProvider extends ChangeNotifier {
  AuthFlag authFlag = AuthFlag();

  void authEmailNickNameCheck(String tempEmail) async {
    QuerySnapshot ref = await FirebaseFirestore.instance
        .collection('user')
        .where("universityEmail", isEqualTo: tempEmail)
        .get();

    List<QueryDocumentSnapshot> docRef = ref.docs;

    if (docRef.isEmpty && tempEmail.contains("@stu.kmu.ac.kr")) {
      authFlag.isEmailChecked = true;
      authFlag.isEmailErrorUnderLine = true;
      authFlag.isEmailDupliCheckUnderLine = true;
      authFlag.isSendUnderLine = true;
      authFlag.isTimerChecked = false;
      notifyListeners();
    } else {
      authFlag.isEmailErrorUnderLine = false;
      authFlag.isEmailDupliCheckUnderLine = true;
      authFlag.isSendUnderLine = true;
      authFlag.isTimerChecked = false;
      authFlag.isSendClick = false;
      notifyListeners();
    }
  }

  void changedAuthEmailChecked(bool value) {
    authFlag.isEmailChecked = value;
    notifyListeners();
  }

  void changedAuthSendUnderLine(bool value) {
    authFlag.isSendUnderLine = value;
    notifyListeners();
  }

  void changedAuthEmailErrorUnderLine(bool value) {
    authFlag.isEmailErrorUnderLine = value;
    notifyListeners();
  }

  void changedAuthEmailDupliCheckUnderLine(bool value) {
    authFlag.isEmailDupliCheckUnderLine = value;
    notifyListeners();
  }

  void changedAuthTimerChecked(bool value) {
    authFlag.isTimerChecked = value;
    notifyListeners();
  }

  void changedAuthNumber(bool value) {
    authFlag.isAuthNumber = value;
    notifyListeners();
  }

  void changedAuthTimeOverChecked(bool value) {
    authFlag.isTimeOverChecked = value;
    notifyListeners();
  }

  void changedAuthSendClick(bool value) {
    authFlag.isSendClick = value;
    notifyListeners();
  }

  void changedShowBtn(bool value) {
    authFlag.isShowBtn = value;
    notifyListeners();
  }
}
