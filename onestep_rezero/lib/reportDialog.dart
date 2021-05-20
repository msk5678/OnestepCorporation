import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// report -> postUid -> data (신고한사람 uid 포함)
// 낚시/도배
void reportFirstDialog(String content, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "낚시/도배",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, MediaQuery.of(context).size.width / 50, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('report')
                              .doc('postUid')
                              .set({
                            'reportUserUid': "sunghun",
                            'time': DateTime.now(),
                            "title": content,
                            "content": "test"
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 욕설/비하
void reportSecondDialog(String content, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Title",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, MediaQuery.of(context).size.width / 50, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // FirebaseFirestore.instance
                          //     .collection('report')
                          //     .doc('postUid')
                          //     .set({
                          //   'reportUserUid': "sunghun",
                          //   'time': DateTime.now(),
                          //   "title": content,
                          //   "content" : "test"
                          // });
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 상업적 광고 및 피해
void reportThirdDialog(String content, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Title",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, MediaQuery.of(context).size.width / 50, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // FirebaseFirestore.instance
                          //     .collection('report')
                          //     .doc('postUid')
                          //     .set({
                          //   'reportUserUid': "sunghun",
                          //   'time': DateTime.now(),
                          //   "title": content,
                          //   "content" : "test"
                          // });
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 정당/정치인 비하 및 선거운동
void reportFourthDialog(String content, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Title",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, MediaQuery.of(context).size.width / 50, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // FirebaseFirestore.instance
                          //     .collection('report')
                          //     .doc('postUid')
                          //     .set({
                          //   'reportUserUid': "sunghun",
                          //   'time': DateTime.now(),
                          //   "title": content,
                          //   "content" : "test"
                          // });
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// 기타
final myController = TextEditingController();
Widget buildBottomEtcSheet(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
        height: 330,
        color: Color(0xFF737373),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    MediaQuery.of(context).size.width / 30,
                    0,
                    0),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ("내용을 입력해주세요"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      reportFifthDialog(myController.text, context);
                    },
                    child: Text("보내기"),
                  ),
                ),
              )
            ],
          ),
        )),
  );
}

// 기타
void reportFifthDialog(String content, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Title",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, MediaQuery.of(context).size.width / 50, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // FirebaseFirestore.instance
                          //     .collection('report')
                          //     .doc('postUid')
                          //     .set({
                          //   'reportUserUid': "sunghun",
                          //   'time': DateTime.now(),
                          //   "title": content,
                          //   "content" : "test"
                          // });
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
