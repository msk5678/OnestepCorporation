import 'package:flutter/material.dart';
import 'package:onestep_rezero/report/pages/Deal/reportDealController.dart';

class ReportDealPage extends StatelessWidget {
  final String postUid;
  ReportDealPage(this.postUid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '거래신고 테스트',
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
                reportDealController(context, 1, postUid);
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
                        reportDealController(context, 1, postUid);
                      },
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                reportDealController(context, 2, postUid);
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
                        "신고유형 2",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        reportDealController(context, 2, postUid);
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
                        "신고유형 3",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        reportDealController(context, 3, postUid);
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
                        "신고유형 4",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        reportDealController(context, 4, postUid);
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
                        "신고유형 5",
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
                        "신고유형 6",
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
                        "신고유형 7",
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
