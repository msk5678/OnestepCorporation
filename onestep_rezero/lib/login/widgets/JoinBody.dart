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
    _emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: _emailController.text.length));

    final TextEditingController _nicknameController =
        TextEditingController(text: _tempNickName);
    final _isNickNameCheck = watch(nickNameProvider.state);
    _nicknameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nicknameController.text.length));

    final _isStatusCheck = watch(statusProvider.state);

    // dropdown btn 주는게 나은지 없는게 나은지 물어보기
    // final _emailTest = watch(emailValueProvider);
    // final _emailList = ['naver.com', 'gmail.com', 'hanmail.net'];
    // final _emailFirstValue = 'naver.com';

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
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.fromLTRB(
              //             0, 0, (MediaQuery.of(context).size.width / 40), 0),
              //         child: Container(
              //           child: Text("@"),
              //         ),
              //       ),
              //       DropdownButton(
              //         value: _emailTest.state,
              //         items: _emailList.map(
              //           (value) {
              //             return DropdownMenuItem(
              //               child: Text(value),
              //               value: value,
              //             );
              //           },
              //         ).toList(),
              //         onChanged: (value) {
              //           _emailTest.state = value;
              //         },
              //       )
              //     ],
              //   ),
              // ),
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
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: _isStatusCheck == true
                                  ? MaterialStateProperty.all<Color>(Colors.red)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.black)),
                          onPressed: () {
                            context.read(statusProvider).changeStatus("재학생");
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Center(child: Text("재학생")),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: _isStatusCheck == false
                                  ? MaterialStateProperty.all<Color>(Colors.red)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.black)),
                          onPressed: () {
                            context.read(statusProvider).changeStatus("졸업생");
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Center(child: Text("졸업생")),
                          )),
                    ),
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
                      //  졸업생, 재학생 value 도 추가해서 db에 update 하기
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
