import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final switchCheckPush = StateNotifierProvider<Push>((ref) {
  return Push();
});

class Push extends StateNotifier<bool> {
  Push() : super(false);

  void changeSwitch(bool value) async {
    state = value;
  }
}

final switchCheckMarketing = StateNotifierProvider<Marketing>((ref) {
  return Marketing();
});

class Marketing extends StateNotifier<bool> {
  Marketing() : super(false);

  void changeSwitch(bool value) async {
    state = value;
  }
}

final myinfoProvider = StateNotifierProvider<MyinfoProvider>((ref) {
  return MyinfoProvider();
});

class MyinfoProvider extends StateNotifier<bool> {
  MyinfoProvider() : super(false);

  bool _isNickNameChecked = false;
  bool _isNickNameUnderLine = true;
  String _resultNickName = '';

  setNickNameChecked(bool value) => _isNickNameChecked = value;
  setNickNameUnderLine(bool value) => _isNickNameUnderLine = value;
  setResultNickName(String value) => _resultNickName = value;
  bool get hasNickNameChecked => _isNickNameChecked;
  bool get hasNickNameUnderLine => _isNickNameUnderLine;
  String get hasResultNickName => _resultNickName;

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
