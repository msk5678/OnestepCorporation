import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/main.dart';

class ChatBlockController {
  static final DatabaseReference blockToChatReference = FirebaseDatabase
          .instance
          .reference()
          .child("blackList")
          .child("productBlackList")
      //향후 대학교 추가
      ;

  //Product Chat Count
  void blockToUser(String friendId) {
    try {
      var nowTime = DateTime.now().millisecondsSinceEpoch.toString();
      //2. users 판매자 정보 가져오기 : 판매자 닉네임, 이미지 가져오기
      blockToChatReference.child(nowTime).set({
        "blockFromUid": googleSignIn.currentUser.id,
        "blockToUid": friendId,
        "blockTime": nowTime,
      }).then((uservalue) {
        //읽어온 상대방 정보 내부db 저장
        print("FriendNickname test");
        Fluttertoast.showToast(
            msg: "$friendId 유저가 차단되었습니다. 채팅 송수신이 불가하며, 차단유저 목록에서 확인할 수 있습니다.");
      });
    } catch (e) {
      print(e.message);
    }
  }

  getblackList(String friendId) {
    try {
      blockToChatReference
          .orderByChild("blockFromUid")
          .equalTo(googleSignIn.currentUser.id)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value == null) {
          blockToUser(friendId);
          print("차단한 유저가 없습니다.");
        } else {
          Map<dynamic, dynamic> values = snapshot.value;
          //retest(values);
          //retest2();
          print("차단한 유저가 있습니다.");
          values.forEach((key, values) {
            print(key);
            print(values['blockToUid']);
            if (values['blockToUid'] == friendId) {
              Fluttertoast.showToast(msg: "이미 차단된 유저입니다.");
            } else {
              blockToUser(friendId);
              Fluttertoast.showToast(msg: "해당 유저를 차단합니다...");
            }
          });
        }
      }).whenComplete(() => print("차단 기다림"));
    } catch (e) {
      print(e.message);
    }
  }
}
