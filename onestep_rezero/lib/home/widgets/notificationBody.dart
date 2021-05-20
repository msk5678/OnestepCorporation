import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/home/models/notification.dart';
import 'package:intl/intl.dart';

class NotificationBody extends StatefulWidget {
  @override
  _NotificationBodyState createState() => _NotificationBodyState();
}

DatabaseReference notificationDB =
    FirebaseDatabase.instance.reference().child("notification");

List<NotificationModel> notificationModel = [];

Widget test(AsyncSnapshot snapshot) {
  return Expanded(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount:
          notificationModel.length == null ? 0 : notificationModel.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(index);
      },
    ),
  );
}

Widget makeCard(int index) {
  return GestureDetector(
    onTap: () {
      print("click");
    },
    child: Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white54),
        child: makeListTile(index),
      ),
    ),
  );
}

Widget makeListTile(int index) {
  return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1.0, color: Colors.black))),
        child: Icon(
            notificationModel[index].type == '댓글'
                ? Icons.chat_bubble_outline_outlined
                : Icons.flag_outlined,
            color: notificationModel[index].type == '댓글'
                ? Colors.green
                : Colors.orange),
      ),
      title: Text(
        "${notificationModel[index].title}",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Text(
              " type : ${notificationModel[index].type}, time : ${notificationModel[index].time}",
              style: TextStyle(color: Colors.black))
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0));
}

class _NotificationBodyState extends State<NotificationBody> {
  final streamtest = notificationDB.onValue;
  @override
  void initState() {
    super.initState();
  }

  void method(AsyncSnapshot snapshot) {
    notificationModel = [];

    Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
    values.forEach((key, value) {
      // university
      if (key == 'KMU') {
        Map<dynamic, dynamic> values = value;
        values.forEach((key, value) {
          // user 개인 uid
          if (key == 'user3') {
            Map<dynamic, dynamic> values = value;
            values.values.forEach((element) {
              Map<dynamic, dynamic> values = element;
              notificationModel.add(NotificationModel(
                  values["title"].toString(),
                  values["content"].toString(),
                  DateFormat('MM-dd kk:mm')
                      .format(DateTime.parse(values["time"])),
                  values["type"].toString(),
                  DateTime.parse(values["time"])));
            });
          }
        });
      }
      // ALL
      if (key == 'ALL') {
        Map<dynamic, dynamic> values = value;
        values.values.forEach((element) {
          Map<dynamic, dynamic> values = element;
          notificationModel.add(NotificationModel(
              values["title"].toString(),
              values["content"].toString(),
              DateFormat('MM-dd kk:mm').format(DateTime.parse(values["time"])),
              values["type"].toString(),
              DateTime.parse(values["time"])));
        });
      }
    });
    notificationModel.sort((a, b) => b.sortTime.compareTo(a.sortTime));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamtest,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            method(snapshot);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        FirebaseDatabase.instance
                            .reference()
                            .child('notification')
                            .child("KMU")
                            .child('user3')
                            .child(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString())
                            .set({
                          'time': DateTime.now().toString(),
                          'title': 'ungchun',
                          'content': '내용없음',
                          'type': '댓글',
                          'postId': ''
                        });
                      },
                      child: Text("댓글 알림"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseDatabase.instance
                            .reference()
                            .child('notification')
                            .child("ALL")
                            .child(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString())
                            .set({
                          'time': DateTime.now().toString(),
                          'title': 'sunghun',
                          'content': '내용없음',
                          'type': '공지',
                          'postId': ''
                        });
                      },
                      child: Text("공지 알림"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("test"),
                    ),
                  ],
                ),
                test(snapshot),
              ],
            );
        }
      },
    );
  }
}
