import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep_rezero/login/pages/choiceAuthWayPage.dart';
import 'package:onestep_rezero/login/providers/providers.dart';

String _tempEmail = "";
String _tempNickName = "";
bool _firstEmailEnter = true;
bool _firstNickNameEnter = true;

class JoinBody extends ConsumerWidget {
  final GoogleSignInAccount user;
  JoinBody(this.user);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final TextEditingController _emailController =
        TextEditingController(text: _tempEmail);
    final _isEmailCheck = watch(emailCheckProvider.state);
    _emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: _emailController.text.length));

    final TextEditingController _nicknameController =
        TextEditingController(text: _tempNickName);
    final _isNickNameCheck = watch(nickNameProvider.state);
    _nicknameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nicknameController.text.length));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                (MediaQuery.of(context).size.width / 15),
                (MediaQuery.of(context).size.height / 40),
                0,
                0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "한발자국 거리의",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  child: Text(
                    "캠퍼스 내에서",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  child: Text(
                    "즐거운 중고거래!",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height / 15, 0, 0),
                child: Center(
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: _emailController,
                      onChanged: (text) {
                        _tempEmail = text;
                      },
                      decoration: InputDecoration(
                        hintText: "아이디",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _firstEmailEnter == true ||
                                        _isEmailCheck == true
                                    ? Colors.grey
                                    : Colors.red)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: _firstEmailEnter == true ||
                                        _isEmailCheck == true
                                    ? Colors.grey
                                    : Colors.red)),
                        suffix: _isEmailCheck
                            ? GestureDetector(
                                child: Text("확인완료"),
                                onTap: () {
                                  context
                                      .read(emailCheckProvider)
                                      .authEmailNickNameCheck(_tempEmail);
                                  _firstEmailEnter = false;
                                },
                              )
                            : GestureDetector(
                                child: Text("중복확인"),
                                onTap: () {
                                  context
                                      .read(emailCheckProvider)
                                      .authEmailNickNameCheck(_tempEmail);
                                  _firstEmailEnter = false;
                                },
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Offstage(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.width / 40,
                      MediaQuery.of(context).size.width / 4,
                      0),
                  child: Text(
                    "이메일 형식이 잘못되었거나 중복입니다.",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                offstage: _firstEmailEnter == true || _isEmailCheck == true
                    ? true
                    : false,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height / 50, 0, 0),
                child: Container(
                  width: 300,
                  child: TextField(
                    maxLength: 8,
                    controller: _nicknameController,
                    onChanged: (text) {
                      _tempNickName = text;
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "닉네임",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _firstNickNameEnter == true ||
                                      _isNickNameCheck == true
                                  ? Colors.grey
                                  : Colors.red)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: _firstNickNameEnter == true ||
                                      _isNickNameCheck == true
                                  ? Colors.grey
                                  : Colors.red)),
                      suffix: _isNickNameCheck
                          ? GestureDetector(
                              child: Text("확인완료"),
                              onTap: () {
                                context
                                    .read(nickNameProvider)
                                    .authEmailNickNameCheck(_tempNickName);
                                _firstNickNameEnter = false;
                              },
                            )
                          : GestureDetector(
                              child: Text("중복확인"),
                              onTap: () {
                                context
                                    .read(nickNameProvider)
                                    .authEmailNickNameCheck(_tempNickName);
                                _firstNickNameEnter = false;
                              },
                            ),
                    ),
                  ),
                ),
              ),
              Offstage(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.width / 40,
                      MediaQuery.of(context).size.width / 2,
                      0),
                  child: Text(
                    "닉네임이 중복입니다.",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                offstage:
                    _firstNickNameEnter == true || _isNickNameCheck == true
                        ? true
                        : false,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Container(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white70),
                    onPressed: _isEmailCheck == true && _isNickNameCheck == true
                        ? () async {
                            if (_isEmailCheck == true &&
                                _isNickNameCheck == true) {
                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(user.id)
                                  .set({
                                    "auth":
                                        0, // 대학인증여부 0 : 안됨, 1 : 인증대기중, 2 : 인증 완료
                                    "authTime": 0, // 학교 인증시간
                                    "uid": user.id, // uid
                                    "nickName": _nicknameController.text, // 닉네임
                                    "imageUrl": user.photoUrl, // 사진
                                    "email": _emailController.text, // 이메일
                                    "reportPoint": 0, // 신고 점수
                                    "university": "", // 학교이름
                                    "universityEmail": "", // 학교이메일
                                    "joinTime": DateTime.now()
                                        .microsecondsSinceEpoch, // 가입시간
                                  })
                                  .whenComplete(() => {
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(user.id)
                                            .collection("chatCount")
                                            .doc(user.id)
                                            .set({
                                          "productChatCount": 0,
                                          "boardChatCount": 0,
                                        })
                                      })
                                  .whenComplete(() => {
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(user.id)
                                            .collection("report")
                                            .doc(user.id)
                                            .set({
                                          "reportPoint": 0,
                                        })
                                      });

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ChoiceAuthWayPage(user)));
                            }
                          }
                        : null,
                    child: Text(
                      "가입완료",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
