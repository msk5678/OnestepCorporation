import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final myController = TextEditingController();

Widget buildBottomSheet(BuildContext context) {
  print("???");
  return Container(
    color: Color(0xFF737373),
    child: Container(
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
          )),
      child: Column(
        children: [
          ListTile(
            title: Center(
                child: Text(
              "낚시/도배",
              style: TextStyle(fontSize: 20),
            )),
            onTap: () => reportDialog("낚시/도배", context),
          ),
          Divider(
            height: 10,
            thickness: 2,
          ),
          ListTile(
            title: Center(
                child: Text(
              "욕설/비하",
              style: TextStyle(fontSize: 20),
            )),
            onTap: () => reportDialog("욕설/비하", context),
          ),
          Divider(
            height: 10,
            thickness: 2,
          ),
          ListTile(
            title: Center(
                child: Text(
              "상업적 광고 및 피해",
              style: TextStyle(fontSize: 20),
            )),
            onTap: () => reportDialog("상업적 광고 및 피해", context),
          ),
          Divider(
            height: 10,
            thickness: 2,
          ),
          ListTile(
            title: Center(
                child: Text(
              "정당/정치인 비하 및 선거운동",
              style: TextStyle(fontSize: 20),
            )),
            onTap: () => reportDialog("정당/정치인 비하 및 선거운동", context),
          ),
          Divider(
            height: 10,
            thickness: 2,
          ),
          ListTile(
            title: Center(
                child: Text(
              "기타",
              style: TextStyle(fontSize: 20),
            )),
            onTap: () => showModalBottomSheet(
                context: context,
                builder: buildBottomEtcSheet,
                isScrollControlled: false),
          )
        ],
      ),
    ),
  );
}

Widget buildBottomEtcSheet(BuildContext context) {
  return Container(
      height: 500,
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
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
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
                    reportDialog(myController.text, context);
                  },
                  child: Text("보내기"),
                ),
              ),
            )
          ],
        ),
      ));
}

void reportDialog(String content, BuildContext context) {
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('report')
                              .doc()
                              .set({
                            'content': "test",
                            'time': DateTime.now(),
                            "title": content,
                            "userUid": ""
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
