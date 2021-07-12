import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signUp/dml/joinDml.dart';
import 'package:onestep_rezero/signUp/pages/loginAuthPage.dart';

import 'package:onestep_rezero/signUp/providers/providers.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialogNotCancel.dart';

// String _tempEmail = "";
String _tempNickName = "";
// bool _firstEmailEnter = true;
bool _firstNickNameEnter = true;

class JoinBody extends ConsumerWidget {
  final List<UserInfo> user;
  JoinBody(this.user);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final TextEditingController _emailController =
    //     TextEditingController(text: _tempEmail);
    // final _isEmailCheck = watch(emailCheckProvider.state);
    // _emailController.selection = TextSelection.fromPosition(
    //     TextPosition(offset: _emailController.text.length));

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
                (MediaQuery.of(context).size.height / 15),
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
              // Padding(
              //   padding: EdgeInsets.fromLTRB(
              //       0, MediaQuery.of(context).size.height / 15, 0, 0),
              //   child: Center(
              //     child: Container(
              //       width: 300,
              //       child: TextField(
              //         controller: _emailController,
              //         onChanged: (text) {
              //           _tempEmail = text;
              //         },
              //         decoration: InputDecoration(
              //           hintText: "아이디",
              //           enabledBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(
              //                   color: _firstEmailEnter == true ||
              //                           _isEmailCheck == true
              //                       ? Colors.grey
              //                       : Colors.red)),
              //           focusedBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(
              //                   color: _firstEmailEnter == true ||
              //                           _isEmailCheck == true
              //                       ? Colors.grey
              //                       : Colors.red)),
              //           suffix: _isEmailCheck
              //               ? GestureDetector(
              //                   child: Text("확인완료"),
              //                   onTap: () {
              //                     context
              //                         .read(emailCheckProvider)
              //                         .authEmailNickNameCheck(_tempEmail);
              //                     _firstEmailEnter = false;
              //                   },
              //                 )
              //               : GestureDetector(
              //                   child: Text("중복확인"),
              //                   onTap: () {
              //                     context
              //                         .read(emailCheckProvider)
              //                         .authEmailNickNameCheck(_tempEmail);
              //                     _firstEmailEnter = false;
              //                   },
              //                 ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Offstage(
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(
              //         0,
              //         MediaQuery.of(context).size.width / 40,
              //         MediaQuery.of(context).size.width / 4,
              //         0),
              //     child: Text(
              //       "아이디 형식이 잘못되었거나 중복입니다.",
              //       style: TextStyle(color: Colors.red),
              //     ),
              //   ),
              //   offstage: _firstEmailEnter == true || _isEmailCheck == true
              //       ? true
              //       : false,
              // ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height / 10, 0, 0),
                  child: Container(
                    width: 300,
                    child: TextField(
                      maxLength: 8,
                      controller: _nicknameController,
                      onChanged: (text) {
                        _tempNickName = text;
                        if (_isNickNameCheck) {
                          context.read(nickNameProvider).resetCheck(false);
                          _firstNickNameEnter = true;
                        }
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
                    style: ElevatedButton.styleFrom(
                      primary: OnestepColors().mainColor,
                    ),
                    onPressed: _isNickNameCheck == true
                        ? () async {
                            if (_isNickNameCheck == true) {
                              joinNickNameDML(user, _nicknameController.text);
                              OnestepCustomDialogNotCancel.show(
                                context,
                                title: '한발자국 회원가입을 환영합니다!',
                                description:
                                    '한발자국을 이용하기 위해서는 \n 학교이메일 인증이 필수입니다. \n모든 서비스는 대학교인증을 하고 난 뒤에 \n 이용이 가능합니다.',
                                confirmButtonText: '확인',
                                confirmButtonOnPress: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          LoginAuthPage(user)));
                                },
                              );
                            }
                          }
                        : null,
                    child: Text(
                      "가입완료",
                      style: TextStyle(color: Colors.white),
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
