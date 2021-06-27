import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/login/pages/termsPersonalDataPage.dart';
import 'package:onestep_rezero/login/pages/termsServicePage.dart';

import 'loginJoinPage.dart';

class TermsPage extends StatefulWidget {
  final List<UserInfo>  user;
  TermsPage(this.user);

  @override
  _TermsPageState createState() => _TermsPageState(user);
}

bool serviceFlag = false;
bool personalFlag = false;
bool allCheckFlag = false;

class _TermsPageState extends State<TermsPage> {
  List<UserInfo> user;
  _TermsPageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          if ((allCheckFlag == true) ||
              (serviceFlag == true && personalFlag == true)) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginJoinPage(user)));
          } else {}
        },
        child: Container(
          height: 50,
          child: BottomAppBar(
            color: (allCheckFlag == true) ||
                    (serviceFlag == true && personalFlag == true) == true
                ? OnestepColors().mainColor
                : Colors.grey[300],
            child: Center(
                child: Text('확인', style: TextStyle(color: Colors.white))),
            elevation: 0,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            0, MediaQuery.of(context).size.height / 8, 0, 0),
        child: Column(
          children: [
            Center(
              child: Container(
                child: Text(
                  '한발자국',
                  style: TextStyle(fontSize: 35, fontWeight: (FontWeight.bold)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height / 50, 0, 0),
              child: Center(
                child: Container(
                  child: Text(
                    '한발자국에 오신 것을 환영합니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height / 30, 0, 0),
              child: Center(
                child: Container(
                  child: Text(
                    '한발자국에 관한 기능을 이용하시려면',
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height / 200, 0, 0),
              child: Center(
                child: Container(
                  child: Text(
                    '약관 동의가 필요합니다. 약관에 동의하시고',
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height / 200, 0, 0),
              child: Center(
                child: Container(
                  child: Text(
                    '한발자국을 즐겨보세요.',
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 10,
                  MediaQuery.of(context).size.height / 13,
                  0,
                  0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              serviceFlag = !serviceFlag;
                              if (personalFlag == true && serviceFlag == true) {
                                allCheckFlag = true;
                              } else {
                                allCheckFlag = false;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2,
                                    color: serviceFlag == true
                                        ? OnestepColors().mainColor
                                        : Colors.black.withOpacity(0.3)),
                                color: serviceFlag == true
                                    ? OnestepColors().mainColor
                                    : Colors.white),
                            child: Padding(
                              // 동그라미 크기
                              padding: const EdgeInsets.all(5.0),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 30, 0, 0, 0),
                        child: Container(
                          child: Text(
                            '(필수)',
                            style: TextStyle(
                                color: serviceFlag == true
                                    ? OnestepColors().mainColor
                                    : Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 100, 0, 0, 0),
                        child: Container(
                          child: Text('서비스 이용약관',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TermsServicePage()));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, MediaQuery.of(context).size.width / 10, 0),
                      child: Container(
                        child: Text('보기',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.3))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 10,
                  MediaQuery.of(context).size.height / 30,
                  0,
                  0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              personalFlag = !personalFlag;
                              if (serviceFlag == true && personalFlag == true) {
                                allCheckFlag = true;
                              } else {
                                allCheckFlag = false;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2,
                                    color: personalFlag == true
                                        ? OnestepColors().mainColor
                                        : Colors.black.withOpacity(0.3)),
                                color: personalFlag == true
                                    ? OnestepColors().mainColor
                                    : Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 30, 0, 0, 0),
                        child: Container(
                          child: Text('(필수)',
                              style: TextStyle(
                                  color: personalFlag == true
                                      ? OnestepColors().mainColor
                                      : Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 100, 0, 0, 0),
                        child: Container(
                          child: Text('개인정보 수집 및 이용 안내',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TermsPersonalDataPage()));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, MediaQuery.of(context).size.width / 10, 0),
                      child: Container(
                        child: Text('보기',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.3))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 10, 0, 0, 0),
              child: Divider(
                height: 60.0,
                color: Colors.grey,
                thickness: 0.5,
                endIndent: MediaQuery.of(context).size.width / 10,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 10, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              allCheckFlag = !allCheckFlag;
                              if (allCheckFlag == true) {
                                serviceFlag = true;
                                personalFlag = true;
                              } else {
                                serviceFlag = false;
                                personalFlag = false;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2,
                                    color: allCheckFlag == true
                                        ? OnestepColors().mainColor
                                        : Colors.black.withOpacity(0.3)),
                                color: allCheckFlag == true
                                    ? OnestepColors().mainColor
                                    : Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 30, 0, 0, 0),
                        child: Container(
                          child: Text(
                            '전체동의',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 13,
                        MediaQuery.of(context).size.height / 100,
                        0,
                        0),
                    child: Container(
                      child: Text(
                        '모든 약관에 대하여 동의합니다.',
                        style: TextStyle(color: Colors.black.withOpacity(0.3)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
