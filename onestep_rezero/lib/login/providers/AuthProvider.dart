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

    // onestep 남은 부분 2번
    // const str = "@stu.kmu.ac.kr";
    // const start = "@stu.";
    // const end = ".ac";

    // final startIndex = tempEmail.indexOf(start);
    // final endIndex = tempEmail.indexOf(end, startIndex + start.length);

    // print(tempEmail.substring(startIndex + start.length, endIndex)); // kmu

    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('university').get();
    final List<DocumentSnapshot> documents = result.docs;
    bool universityCheck = false;
    documents.forEach((data) => {
          if (tempEmail.contains("@stu.${data.id}.ac.kr"))
            {universityCheck = true}
        });
    // print("test = $universityCheck");

    // 경대 : @stu.knu.ac.kr, 영대 : @stu.yu.ac.kr, 대구대 : @stu.daegu.ac.kr, 대가대 : @stu.cu.ac.kr
    if (docRef.isEmpty && universityCheck == true) {
      authFlag.isEmailChecked = true;
      authFlag.isEmailErrorUnderLine = true;
      authFlag.isEmailDupliCheckUnderLine = true;
      authFlag.isSendUnderLine = true;
      authFlag.isTimerChecked = false;
      // authFlag.levelClock = 30;
      authFlag.levelClock = 300;
      notifyListeners();
    } else {
      authFlag.isEmailChecked = false;
      authFlag.isEmailErrorUnderLine = false;
      authFlag.isEmailDupliCheckUnderLine = true;
      authFlag.isSendUnderLine = true;
      authFlag.isTimerChecked = false;
      authFlag.isSendClick = false;
      authFlag.isShowBtn = false;
      // authFlag.levelClock = 30;
      authFlag.levelClock = 300;
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
