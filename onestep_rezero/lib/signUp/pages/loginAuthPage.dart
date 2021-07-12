import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBA;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/signUp/model/user.dart';
import 'package:onestep_rezero/signUp/providers/providers.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialogNotCancel.dart';
import 'package:onestep_rezero/login/dml/authDml.dart';
import 'package:onestep_rezero/login/providers/providers.dart';

import '../../main.dart';
import '../../sendMail.dart';

String _tempEmail;
bool _firstEmailEnter;
String checkPassword;
AnimationController _controller;
bool timeOver;

const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

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
  _tempEmail = "";
  checkPassword = "";
  timeOver = false;
  _firstEmailEnter = true;
}

class LoginAuthPage extends StatefulWidget {
  final List<FBA.UserInfo> user;
  LoginAuthPage(this.user);

  @override
  _LoginAuthPageState createState() => _LoginAuthPageState(user);
}

class _LoginAuthPageState extends State<LoginAuthPage>
    with TickerProviderStateMixin {
  final List<FBA.UserInfo> user;
  _LoginAuthPageState(this.user);

  @override
  void initState() {
    super.initState();
    init();
    _controller = AnimationController(
        // duration: Duration(seconds: 30),
        duration: Duration(seconds: 300),
        vsync:
            this // gameData.levelClock is a user entered number elsewhere in the applciation
        );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController =
        TextEditingController(text: _tempEmail);
    final _authNumberController = TextEditingController();

    // StatefulWidget 쓰면서 riverpod (consumer) 쓰기
    return Consumer(
      builder: (context, ScopedReader watch, _) {
        final _isEmailCheck = watch(schoolEmailCheckProvider);
        return WillPopScope(
          // ignore: missing_return
          onWillPop: () {
            // 추후에 증명서 들어오면 뒤로가기 필요함
            // Navigator.pop(context, false);
            // setState(() {
            //   _isEmailCheck.changedAuthEmailChecked(false);
            //   _isEmailCheck.changedAuthEmailErrorUnderLine(true);
            //   _isEmailCheck.changedAuthEmailDupliCheckUnderLine(true);
            //   _isEmailCheck.changedAuthSendUnderLine(true);
            //   _isEmailCheck.changedAuthNumber(true);
            //   _isEmailCheck.changedAuthTimeOverChecked(true);
            //   _isEmailCheck.changedAuthTimerChecked(false);
            //   _isEmailCheck.changedAuthSendClick(false);
            //   _isEmailCheck.changedShowBtn(false);
            // });
            // return Future(() => false);
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Text(
                "대학교인증",
                style: TextStyle(color: Colors.black),
              ),
              // 뒤로가기
              // leading: IconButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //     setState(() {
              //       _isEmailCheck.changedAuthEmailChecked(false);
              //       _isEmailCheck.changedAuthEmailErrorUnderLine(true);
              //       _isEmailCheck.changedAuthEmailDupliCheckUnderLine(true);
              //       _isEmailCheck.changedAuthSendUnderLine(true);
              //       _isEmailCheck.changedAuthNumber(true);
              //       _isEmailCheck.changedAuthTimeOverChecked(true);
              //       _isEmailCheck.changedAuthTimerChecked(false);
              //       _isEmailCheck.changedAuthSendClick(false);
              //       _isEmailCheck.changedShowBtn(false);
              //     });
              //   },
              //   icon: Icon(Icons.arrow_back),
              //   color: Colors.black,
              // ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        (MediaQuery.of(context).size.width / 15),
                        (MediaQuery.of(context).size.height / 20),
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
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    child: Center(
                      child: Container(
                        child: Text("대학교 off365 email을 적어주세요"),
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
                              style: TextStyle(color: Colors.black),
                              controller: _emailController,
                              onChanged: (text) {
                                _tempEmail = text;

                                if (_isEmailCheck.authFlag.isEmailChecked) {
                                  _firstEmailEnter = true;
                                  _isEmailCheck.changedAuthEmailChecked(false);

                                  _isEmailCheck
                                      .changedAuthEmailErrorUnderLine(true);
                                  _isEmailCheck
                                      .changedAuthEmailDupliCheckUnderLine(
                                          true);
                                  _isEmailCheck.changedAuthSendUnderLine(true);
                                  _isEmailCheck.changedAuthNumber(true);
                                  _isEmailCheck
                                      .changedAuthTimeOverChecked(true);
                                  _isEmailCheck.changedAuthTimerChecked(false);
                                  _isEmailCheck.changedAuthSendClick(false);
                                  _isEmailCheck.changedShowBtn(false);
                                  _isEmailCheck.authFlag.levelClock = 300;
                                  _authNumberController.text = "";
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "대학교 이메일",
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
                                          _isEmailCheck
                                              .changedAuthEmailChecked(true);
                                          _isEmailCheck
                                              .changedAuthEmailErrorUnderLine(
                                                  true);
                                          _isEmailCheck
                                              .changedAuthEmailDupliCheckUnderLine(
                                                  true);
                                          _isEmailCheck
                                              .changedAuthSendUnderLine(true);
                                          _isEmailCheck.changedAuthNumber(true);
                                          _isEmailCheck
                                              .changedAuthTimeOverChecked(true);
                                          _isEmailCheck
                                              .changedAuthTimerChecked(false);
                                          _isEmailCheck
                                              .changedAuthSendClick(false);
                                          _isEmailCheck.changedShowBtn(false);
                                          context
                                              .read(schoolEmailCheckProvider)
                                              .authEmailNickNameCheck(
                                                  _tempEmail);
                                          _authNumberController.text = "";
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
                                          _authNumberController.text = "";
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
                                style: ElevatedButton.styleFrom(
                                    primary: OnestepColors().mainColor),
                                onPressed: (_isEmailCheck
                                                .authFlag.isEmailChecked ==
                                            true &&
                                        _isEmailCheck.authFlag.isSendClick ==
                                            false)
                                    ? () async {
                                        checkPassword =
                                            await getRandomString(6);
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

                                        timeOver = false;
                                        // _isEmailCheck.authFlag.levelClock = 30;
                                        _isEmailCheck.authFlag.levelClock = 300;
                                        _controller = AnimationController(
                                            duration: Duration(
                                                seconds: _isEmailCheck
                                                    .authFlag.levelClock),
                                            vsync:
                                                this // gameData.levelClock is a user entered number elsewhere in the applciation
                                            );

                                        _controller.forward();
                                        sendEmailAuth(checkPassword,
                                            _emailController.text);
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
                                              begin: _isEmailCheck.authFlag
                                                  .levelClock, // THIS IS A USER ENTERED NUMBER
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
                              style: ElevatedButton.styleFrom(
                                  primary: OnestepColors().mainColor),
                              onPressed: _isEmailCheck.authFlag.isShowBtn ==
                                      true
                                  ? () async {
                                      _authNumberController.text = "";
                                      checkPassword = await getRandomString(6);
                                      Fluttertoast.showToast(
                                          msg: '인증번호가 재전송 되었습니다',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM);
                                      _isEmailCheck.changedAuthSendClick(true);
                                      _isEmailCheck
                                          .changedAuthTimeOverChecked(true);
                                      _isEmailCheck.changedAuthNumber(true);

                                      timeOver = false;
                                      // _isEmailCheck.authFlag.levelClock = 30;
                                      _isEmailCheck.authFlag.levelClock = 300;
                                      _controller = AnimationController(
                                          duration: Duration(
                                              seconds: _isEmailCheck
                                                  .authFlag.levelClock),
                                          vsync:
                                              this // gameData.levelClock is a user entered number elsewhere in the applciation
                                          );

                                      _controller.forward();

                                      sendEmailAuth(
                                          checkPassword, _emailController.text);
                                    }
                                  : null,
                              child: Text("재전송"),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: OnestepColors().mainColor),
                            onPressed: _isEmailCheck.authFlag.isShowBtn == true
                                ? () async {
                                    // 5분 안에 인증해야함
                                    if (timeOver == false &&
                                        checkPassword ==
                                            _authNumberController.text) {
                                      final QuerySnapshot result =
                                          await FirebaseFirestore.instance
                                              .collection('university')
                                              .get();
                                      final List<DocumentSnapshot> documents =
                                          result.docs;
                                      documents.forEach((data) => {
                                            if (_emailController.text.contains(
                                                "@${data.data()['email']}"))
                                              {
                                                authEmailDML(
                                                    user,
                                                    data.id.toString(),
                                                    _emailController.text)
                                              }
                                          });

                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        OnestepCustomDialogNotCancel.show(
                                          context,
                                          title: '한발자국 대학교인증 성공!',
                                          description:
                                              '이제 한발자국의 모든 기능들을 이용할 수 있습니다.',
                                          confirmButtonText: '확인',
                                          confirmButtonOnPress: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage()));
                                          },
                                        );
                                      });
                                    } else if (timeOver == true) {
                                      _isEmailCheck
                                          .changedAuthTimeOverChecked(false);
                                      _isEmailCheck.changedAuthNumber(true);
                                    } else {
                                      _isEmailCheck
                                          .changedAuthTimeOverChecked(true);
                                      _isEmailCheck.changedAuthNumber(false);
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
