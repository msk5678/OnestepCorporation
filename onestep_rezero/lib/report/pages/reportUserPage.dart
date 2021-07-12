import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'User/case/userCase.dart';

class ReportUserPage extends StatelessWidget {
  final String chatId;
  final String reportedUid;
  ReportUserPage(this.chatId, this.reportedUid);

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
        child: FutureBuilder(
          future: FirebaseDatabase.instance
              .reference()
              .child('reportType')
              .child('user')
              .once(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                // Future.delayed(const Duration(seconds: 1));
                DataSnapshot dataValues = snapshot.data;
                Map<dynamic, dynamic> values = dataValues.value;
                List title = [];
                List content = [];
                List reportCase = [];
                values.forEach((key, value) {
                  title.add(value['title'].toString());
                  content.add(value['content'].toString());
                  reportCase.add(value['case'].toString());
                });
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: title.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0,
                              MediaQuery.of(context).size.height / 80,
                              0,
                              MediaQuery.of(context).size.height / 80),
                          child: Divider(
                            thickness: 1,
                            endIndent: 15,
                            indent: 15,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            int _reportCase = int.parse(reportCase[index]);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserCase(
                                    title[index],
                                    content[index],
                                    _reportCase,
                                    postUid,
                                    reportedUid)));
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width / 20,
                                0,
                                0,
                                0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "${title[index]}",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      MediaQuery.of(context).size.width / 20,
                                      0),
                                  child: Icon(Icons.keyboard_arrow_right),
                                ),
                              ],
                            ),
                          ),
                        ),
                        index == title.length - 1
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0,
                                    MediaQuery.of(context).size.height / 80,
                                    0,
                                    MediaQuery.of(context).size.height / 80),
                                child: Divider(
                                  thickness: 1,
                                  endIndent: 15,
                                  indent: 15,
                                ),
                              )
                            : Container(),
                      ],
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
