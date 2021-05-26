import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/login/pages/choiceAuthWayPage.dart';
import 'package:onestep_rezero/login/providers/providers.dart';
import 'package:onestep_rezero/main.dart';

String _tempEmail = "";
String _tempNickName = "";
bool _firstEmailEnter = true;
bool _firstNickNameEnter = true;

class JoinBody extends ConsumerWidget {
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
                    "OneStep 과 함께",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  child: Text(
                    "즐거운 대학생활을",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  child: Text(
                    "지금 바로 RUN",
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
                      MediaQuery.of(context).size.width / 3,
                      0),
                  // child: Text(
                  //   "이메일 형식이 잘못되었거나 중복입니다.",
                  //   style: TextStyle(color: Colors.red),
                  // ),
                  child: Text(
                    "아이디가 공백이거나 중복입니다.",
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
                        ? () {
                            if (_isEmailCheck == true &&
                                _isNickNameCheck == true) {
                              // FirebaseFirestore.instance
                              //             .collection('user')
                              //             .doc(googleSignIn.currentUser.id)
                              //             .update({
                              //           "nickName": _nicknameController.text,
                              //           "email":
                              //               _emailController.text,
                              //         });

                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => ChoiceAuthWayPage()));
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
