import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' as mf;
import 'package:onestep_rezero/home/pages/noticeDetailView.dart';
import 'package:onestep_rezero/moor/moor_database.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> mappedData;
  final String id;
  NotificationCard(this.mappedData, this.id);

  @override
  Widget build(BuildContext context) {
    NotificationChksDao p =
        Provider.of<AppDatabase>(context).notificationChksDao;

    return StreamBuilder<mf.QueryRow>(
      stream: p.watchsingleNotification(id, true),
      builder: (context, snapshot) {
        print("hasdata = ${snapshot.hasData}");
        return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
                color: snapshot.hasData ? Colors.black : Colors.grey[400]),
            child: GestureDetector(
              onTap: () {
                if (!snapshot.hasData) {
                  // 상세뷰 이동
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NoticeDetailView("Notification", id)));
                  p.updateNotification(NotificationChk(
                      readChecked: 'true',
                      firestoreid: id,
                      entireChecked: mappedData['notiEntire'].toString(),
                      uploadtime: DateTime.parse(
                          mappedData['time'].toDate().toString())));
                } else {
                  // 상세뷰 이동
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NoticeDetailView("Notification", id)));
                  // 추후에 삭제해야함
                  p.updateNotification(NotificationChk(
                      readChecked: 'false',
                      firestoreid: id,
                      entireChecked: mappedData['notiEntire'].toString(),
                      uploadtime: DateTime.parse(
                          mappedData['time'].toDate().toString())));
                }
              },
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                        border: Border(
                            right:
                                BorderSide(width: 1.0, color: Colors.white24))),
                    child: mappedData['notiEntire'] == true
                        // 개인공지
                        ? Icon(Icons.autorenew, color: Colors.white)
                        // 전체공지
                        : Icon(Icons.error_outline, color: Colors.white),
                  ),
                  title: Text(
                    "${mappedData['notiTitle']}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Text("${mappedData['notiContent']}",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                      Text(
                          "${DateTime.parse(mappedData['time'].toDate().toString())}",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Colors.white, size: 30.0)),
            ),
          ),
        );
      },
    );
  }
}
