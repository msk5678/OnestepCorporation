import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep_rezero/home/homeMain.dart';
import 'package:onestep_rezero/login/model/user.dart';
import 'package:onestep_rezero/login/providers/providers.dart';

import '../../main.dart';

String _tempEmail;
bool _firstEmailEnter;
String checkPassword;
int levelClock;
AnimationController _controller;
bool timeOver;

Future getRandomNumber() async {
  var _random = Random();
  var numMin = 0x30;
  var charMax = 0x5A;
  var skipCharacter = [0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F, 0x40];
  var checkNumber = [];

  while (checkNumber.length <= 6) {
    var tmp = numMin + _random.nextInt(charMax - numMin);
    if (skipCharacter.contains(skipCharacter)) {
      continue;
    }
    checkNumber.add(tmp);
  }
  return String.fromCharCodes(checkNumber.cast<int>());
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    // timer 0초
    if (animation.value == 0) {
      timeOver = true;
    }

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 15,
        color: Colors.red,
      ),
    );
  }
}

void init() {
  // levelClock = 300;
  levelClock = 10;
  _tempEmail = "";
  checkPassword = "";
  timeOver = false;
  _firstEmailEnter = true;
}

class LoginAuthPage extends StatefulWidget {
  final GoogleSignInAccount user;
  LoginAuthPage(this.user);

  @override
  _LoginAuthPageState createState() => _LoginAuthPageState(user);
}

class _LoginAuthPageState extends State<LoginAuthPage>
    with TickerProviderStateMixin {
  final GoogleSignInAccount user;
  _LoginAuthPageState(this.user);

  @override
  void initState() {
    super.initState();
    init();
    _controller = AnimationController(
        duration: Duration(seconds: levelClock),
        vsync:
            this // gameData.levelClock is a user entered number elsewhere in the applciation
        );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController =
        TextEditingController(text: _tempEmail);
    // _emailController.selection = TextSelection.fromPosition(
    //     TextPosition(offset: _emailController.text.length));
    final _authNumberController = TextEditingController();

    // StatefulWidget 쓰면서 riverpod (consumer) 쓰기
    return Consumer(
      builder: (context, ScopedReader watch, _) {
        final _isEmailCheck = watch(schoolEmailCheckProvider);
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context, false);
            setState(() {
              _isEmailCheck.changedAuthEmailChecked(false);
              _isEmailCheck.changedAuthEmailErrorUnderLine(true);
              _isEmailCheck.changedAuthEmailDupliCheckUnderLine(true);
              _isEmailCheck.changedAuthSendUnderLine(true);
              _isEmailCheck.changedAuthNumber(true);
              _isEmailCheck.changedAuthTimeOverChecked(true);
              _isEmailCheck.changedAuthTimerChecked(false);
              _isEmailCheck.changedAuthSendClick(false);
              _isEmailCheck.changedShowBtn(false);
            });
            return Future(() => false);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "이메일인증",
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isEmailCheck.changedAuthEmailChecked(false);
                    _isEmailCheck.changedAuthEmailErrorUnderLine(true);
                    _isEmailCheck.changedAuthEmailDupliCheckUnderLine(true);
                    _isEmailCheck.changedAuthSendUnderLine(true);
                    _isEmailCheck.changedAuthNumber(true);
                    _isEmailCheck.changedAuthTimeOverChecked(true);
                    _isEmailCheck.changedAuthTimerChecked(false);
                    _isEmailCheck.changedAuthSendClick(false);
                    _isEmailCheck.changedShowBtn(false);
                  });
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
              ),
            ),
            body: SingleChildScrollView(
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
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Center(
                      child: Container(
                        child: Text("학교 off365 email을 적어주세요"),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Text("ex) 학번@stu.kmu.ac.kr"),
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 50),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: TextField(
                              style: TextStyle(
                                  color: _isEmailCheck.authFlag.isEmailChecked
                                      ? Colors.grey
                                      : Colors.black),
                              enabled: _isEmailCheck.authFlag.isEmailChecked
                                  ? false
                                  : true,
                              controller: _emailController,
                              onChanged: (text) {
                                _tempEmail = text;
                              },
                              decoration: InputDecoration(
                                hintText: "학교 이메일",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _firstEmailEnter == true ||
                                                _isEmailCheck.authFlag
                                                        .isEmailChecked ==
                                                    true
                                            ? Colors.grey
                                            : Colors.red)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _firstEmailEnter == true ||
                                                _isEmailCheck.authFlag
                                                        .isEmailChecked ==
                                                    true
                                            ? Colors.grey
                                            : Colors.red)),
                                suffix: _isEmailCheck.authFlag.isEmailChecked
                                    ? GestureDetector(
                                        child: Text("확인완료"),
                                        onTap: () {
                                          context
                                              .read(schoolEmailCheckProvider)
                                              .authEmailNickNameCheck(
                                                  _tempEmail);
                                          _firstEmailEnter = false;
                                        },
                                      )
                                    : GestureDetector(
                                        child: Text("중복확인"),
                                        onTap: () {
                                          context
                                              .read(schoolEmailCheckProvider)
                                              .authEmailNickNameCheck(
                                                  _tempEmail);
                                          _firstEmailEnter = false;
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
                                  MediaQuery.of(context).size.height / 50,
                                  0,
                                  0),
                              child: Text(
                                "이메일 형식이 잘못되었거나 중복입니다.",
                                style: TextStyle(color: Colors.red),
                              )),
                          offstage:
                              _isEmailCheck.authFlag.isEmailErrorUnderLine ==
                                      true
                                  ? true
                                  : false,
                        ),
                        Offstage(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0,
                                  MediaQuery.of(context).size.height / 50,
                                  0,
                                  0),
                              child: Text(
                                "인증번호가 메일로 전송되었습니다.",
                                style: TextStyle(color: Colors.grey),
                              )),
                          offstage:
                              _isEmailCheck.authFlag.isSendUnderLine == true
                                  ? true
                                  : false,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, MediaQuery.of(context).size.height / 50, 0, 0),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: ElevatedButton(
                                onPressed: (_isEmailCheck
                                                .authFlag.isEmailChecked ==
                                            true &&
                                        _isEmailCheck.authFlag.isSendClick ==
                                            false)
                                    ? () async {
                                        checkPassword = await getRandomNumber();
                                        print("checkPassword = $checkPassword");
                                        _isEmailCheck
                                            .changedAuthSendUnderLine(false);
                                        _isEmailCheck
                                            .changedAuthEmailErrorUnderLine(
                                                true);
                                        _isEmailCheck
                                            .changedAuthEmailDupliCheckUnderLine(
                                                true);
                                        _isEmailCheck
                                            .changedAuthTimerChecked(true);
                                        _isEmailCheck.changedAuthNumber(true);
                                        _isEmailCheck
                                            .changedAuthTimeOverChecked(true);
                                        _isEmailCheck
                                            .changedAuthSendClick(true);

                                        _isEmailCheck.changedShowBtn(true);
                                        _controller.forward();
                                      }
                                    : null,
                                child: Text("전송"),
                              )),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 60),
                            child: TextField(
                              controller: _authNumberController,
                              decoration: InputDecoration(
                                hintText: "인증번호",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isEmailCheck.authFlag
                                                        .isAuthNumber ==
                                                    false ||
                                                _isEmailCheck.authFlag
                                                        .isTimeOverChecked ==
                                                    false
                                            ? Colors.red
                                            : Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: _isEmailCheck.authFlag
                                                        .isAuthNumber ==
                                                    false ||
                                                _isEmailCheck.authFlag
                                                        .isTimeOverChecked ==
                                                    false
                                            ? Colors.red
                                            : Colors.grey)),
                                isDense: true,
                                suffixIconConstraints:
                                    BoxConstraints(minWidth: 0, minHeight: 0),
                                suffixIcon:
                                    _isEmailCheck.authFlag.isTimerChecked
                                        ? Countdown(
                                            animation: StepTween(
                                              begin:
                                                  levelClock, // THIS IS A USER ENTERED NUMBER
                                              end: 0,
                                            ).animate(_controller),
                                          )
                                        : Text(""),
                              ),
                            ),
                          ),
                        ),
                        Offstage(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0,
                                MediaQuery.of(context).size.height / 50, 0, 0),
                            child: Text(
                              "잘못된 인증번호입니다.",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          offstage: _isEmailCheck.authFlag.isAuthNumber == true
                              ? true
                              : false,
                        ),
                        Offstage(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0,
                                MediaQuery.of(context).size.height / 50, 0, 0),
                            child: Text(
                              "제한시간이 경과하였습니다.",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          offstage:
                              _isEmailCheck.authFlag.isTimeOverChecked == true
                                  ? true
                                  : false,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, MediaQuery.of(context).size.height / 40, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: ElevatedButton(
                              onPressed: _isEmailCheck.authFlag.isShowBtn ==
                                      true
                                  ? () async {
                                      checkPassword = await getRandomNumber();
                                      Fluttertoast.showToast(
                                          msg: '인증번호가 재전송 되었습니다',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM);
                                      _isEmailCheck.changedAuthSendClick(true);
                                      _isEmailCheck
                                          .changedAuthTimeOverChecked(true);
                                      _isEmailCheck.changedAuthNumber(true);

                                      timeOver = false;
                                      // levelClock = 300;
                                      levelClock = 10;
                                      _controller = AnimationController(
                                          duration:
                                              Duration(seconds: levelClock),
                                          vsync:
                                              this // gameData.levelClock is a user entered number elsewhere in the applciation
                                          );

                                      _controller.forward();

                                      // sendEmailAuth(
                                      //     checkPassword, _emailController.text);
                                    }
                                  : null,
                              child: Text("재전송"),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: ElevatedButton(
                            onPressed: _isEmailCheck.authFlag.isShowBtn == true
                                ? () async {
                                    // 5분 안에 인증해야함
                                    if (timeOver == false &&
                                        checkPassword ==
                                            _authNumberController.text) {
                                      print("성공");
                                      // university 는 지금 계명대학교라고 줬는데, 나중에 학교이메일 판단해서 넣어줘야함
                                      // ex) stu.kmu -> 계명대학교 이런식으로
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(user.id)
                                          .update({
                                        "auth": 2,
                                        "univerisityEmail":
                                            _emailController.text,
                                        "university": "kmu",
                                        "authTime": DateTime.now()
                                            .millisecondsSinceEpoch
                                      });

                                      var time =
                                          DateTime.now().microsecondsSinceEpoch;
                                      DocumentSnapshot userRecord =
                                          await ref.doc(user.id).get();
                                      currentUserModel =
                                          User.fromDocument(userRecord);
                                      ref
                                          .doc(currentUserModel.uid)
                                          .collection("log")
                                          .doc(time.toString())
                                          .set({
                                        "loginTime": time,
                                      });
                                      categoryList = FirebaseFirestore.instance
                                          .collection('category')
                                          .get();

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeMain()));
                                    } else if (timeOver == true) {
                                      print("time over 실패");
                                      _isEmailCheck
                                          .changedAuthTimeOverChecked(false);
                                      _isEmailCheck.changedAuthNumber(true);

                                      // setState(() {
                                      //   _isTimeOverChecked = false;
                                      //   _isAuthNumber = true;
                                      // });
                                      // print("${snapshot.data.data()['authTest']}");
                                      // Navigator.of(context).pop();
                                    } else {
                                      print("인증번호 매칭 실패");
                                      _isEmailCheck
                                          .changedAuthTimeOverChecked(true);
                                      _isEmailCheck.changedAuthNumber(false);

                                      // setState(() {
                                      //   _isTimeOverChecked = true;
                                      //   _isAuthNumber = false;
                                      // });
                                    }
                                  }
                                : null,
                            child: Text("인증"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
