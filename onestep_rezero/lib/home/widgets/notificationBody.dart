import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/home/models/notification.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationBody extends StatefulWidget {
  @override
  _NotificationBodyState createState() => _NotificationBodyState();
}

DatabaseReference notificationDB =
    FirebaseDatabase.instance.reference().child("notification");

List<NotificationModel> notificationModel = [];
RefreshController _refreshController = RefreshController(initialRefresh: false);

// Widget body(AsyncSnapshot snapshot) {

//   return SmartRefresher(
//     enablePullDown: true,
//         enablePullUp: true,
//         header: WaterDropHeader(
//           complete: Container(),
//           failed: Container(),
//         ),
//         footer: CustomFooter(
//           builder: (BuildContext context, LoadStatus mode) {
//             Widget body;
//             //
//             if (mode == LoadStatus.idle) {
//               body = Text("pull up load");
//             } else if (mode == LoadStatus.loading) {
//               body = CupertinoActivityIndicator();
//             } else if (mode == LoadStatus.failed) {
//               body = Text("Load Failed!Click retry!");
//             } else if (mode == LoadStatus.canLoading) {
//               body = Text("release to load more");
//             } else {
//               body = Text("No more Data");
//             }
//             return Container(
//               height: 55.0,
//               child: Center(child: body),
//             );
//           },
//         ),
//         controller: _refreshController,
//         onRefresh: _onRefresh,
//         onLoading: _onLoading,

//       child: Expanded(
//       child: ListView.builder(
//         itemExtent: 100.0,
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         itemCount:
//             notificationModel.length == null ? 0 : notificationModel.length,
//         itemBuilder: (BuildContext context, int index) {
//           return makeCard(index);
//         },
//       ),
//     ),
//   );
// }

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

  int testCount = 0;
  bool testFlag = false;

  // 개인알림, 전체알림 합치고 sort
  void method(AsyncSnapshot snapshot) {
    notificationModel = [];

    Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
    values.forEach((key, value) {
      // university
      if (key == 'KMU') {
        Map<dynamic, dynamic> values = value;
        values.forEach((key, value) {
          // user 개인 uid
          // googleSignIn.currentUser.id
          if (key == 'user3') {
            Map<dynamic, dynamic> values = value;
            values.values.forEach((element) {
              Map<dynamic, dynamic> values = element;
              // 현재 기준으로 1달전까지
              if (DateTime.now()
                  .subtract(Duration(days: 30))
                  .isBefore(DateTime.parse(values["time"]))) {
                print(
                    'DateTime.parse(values["time"]) ${DateTime.parse(values["time"])}');

                notificationModel.add(NotificationModel(
                    values["title"].toString(),
                    values["content"].toString(),
                    DateFormat('MM-dd kk:mm')
                        .format(DateTime.parse(values["time"])),
                    values["type"].toString(),
                    DateTime.parse(values["time"])));
              }
            });
          }
        });
      }
      // ALL
      if (key == 'ALL') {
        Map<dynamic, dynamic> values = value;
        values.values.forEach((element) {
          Map<dynamic, dynamic> values = element;
          if (DateTime.now()
              .subtract(Duration(days: 30))
              .isBefore(DateTime.parse(values["time"]))) {
            print(
                'DateTime.parse(values["time"]) ${DateTime.parse(values["time"])}');

            notificationModel.add(NotificationModel(
                values["title"].toString(),
                values["content"].toString(),
                DateFormat('MM-dd kk:mm')
                    .format(DateTime.parse(values["time"])),
                values["type"].toString(),
                DateTime.parse(values["time"])));
          }
        });
      }
    });
    notificationModel.sort((a, b) => b.sortTime.compareTo(a.sortTime));
    // 첫 화면 (onLoad에 setState 돌아가서 method 메서드도 돔, onLoad가 돌았다 안돌았다 판단하기 위한 flag == testFlag)
    // load 했을때 데이터 없을때 처리해야함
    if (testFlag == false) {
      testCount = notificationModel.length == null
          ? 0
          : (notificationModel.length >= 10 ? 10 : notificationModel.length);
    } else {
      testCount = notificationModel.length == null
          ? 0
          : (notificationModel.length == testCount
              ? testCount
              : (notificationModel.length <= testCount + 5
                  ? notificationModel.length
                  : testCount += 5));
    }
    print("notificationModel.length ${notificationModel.length}");
  }

  void _onRefresh() async {
    print("!!!!!!!!!!!!!!!");

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    // _refreshController.refreshFailed();
  }

  void _onLoading() async {
    print("??????????");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    testFlag = true;
    if (mounted) setState(() {});
    _refreshController.loadComplete();
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
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                complete: Container(),
                failed: Container(),
              ),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  //
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: testCount,
                itemBuilder: (BuildContext context, int index) {
                  return makeCard(index);
                },
              ),
            );
        }
      },
    );

    // Column(
    //   children: [
    //     ElevatedButton(
    //       onPressed: () {
    //         FirebaseDatabase.instance
    //             .reference()
    //             .child('notification')
    //             .child("KMU")
    //             .child('user3')
    //             .child(DateTime.now().millisecondsSinceEpoch.toString())
    //             .set({
    //           'time': DateTime.now().toString(),
    //           'title': 'ungchun',
    //           'content': '내용없음',
    //           'type': '댓글',
    //           'postId': ''
    //         });
    //       },
    //       child: Text("댓글 알림"),
    //     ),
    //     ElevatedButton(
    //       onPressed: () {
    //         FirebaseDatabase.instance
    //             .reference()
    //             .child('notification')
    //             .child("ALL")
    //             .child(DateTime.now().millisecondsSinceEpoch.toString())
    //             .set({
    //           'time': DateTime.now().toString(),
    //           'title': 'sunghun',
    //           'content': '내용없음',
    //           'type': '공지',
    //           'postId': ''
    //         });
    //       },
    //       child: Text("공지 알림"),
    //     )
    //   ],
    // );
  }
}
