import 'package:flutter/material.dart';

import 'User/reportUserController.dart';

class ReportUserPage extends StatelessWidget {
  final String uid;
  ReportUserPage(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '사용자신고 테스트',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                reportUserController(context, 1);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    MediaQuery.of(context).size.width / 40,
                    0,
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "신고유형 1",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        reportUserController(context, 1);
                      },
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    MediaQuery.of(context).size.width / 40,
                    0,
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "신고유형 2",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    MediaQuery.of(context).size.width / 40,
                    0,
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "신고유형 3",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    MediaQuery.of(context).size.width / 40,
                    0,
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "신고유형 4",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
