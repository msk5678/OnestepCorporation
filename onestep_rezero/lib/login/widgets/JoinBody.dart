import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/login/pages/loginAuthPage.dart';
import 'package:onestep_rezero/login/providers/providers.dart';

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

    final TextEditingController _nicknameController =
        TextEditingController(text: _tempNickName);
    final _isNickNameCheck = watch(nickNameProvider.state);

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
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Center(
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: _emailController,
                      onChanged: (text) {
                        _tempEmail = text;
                      },
                      decoration: InputDecoration(
                        hintText: "이메일",
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
                  padding: const EdgeInsets.fromLTRB(0, 15, 50, 0),
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
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
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
                  padding: const EdgeInsets.fromLTRB(0, 15, 150, 0),
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
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Text("학교인증 (선택사항)"),
                    ),
                    Container(
                        width: 100,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white70),
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginAuthPage()));
                            },
                            child: Text(
                              "하러가기",
                              style: TextStyle(color: Colors.black),
                            ))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Container(
                  width: 200,
                  // 이메일, 별명 (중복확인까지) 적혀있어야 가입완료 o
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white70),
                    onPressed: () {
                      // test : email text 공백 아니면 넘어감
                      // if (_isEmailChecked == true &&
                      //     _isNickNameChecked == true) {
                      //   print("성공");
                      //   updateUser(
                      //       emailController.text, nicknameController.text);
                      //   Navigator.of(context).pushReplacementNamed(
                      //       '/MainPage?UID=${widget.currentUserId}');
                      // } else {
                      //   // 일단 넘어가게해놈
                      //   print("실패");
                      //   Navigator.of(context).pushReplacementNamed(
                      //       '/MainPage?UID=${widget.currentUserId}');
                      // }
                    },
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
