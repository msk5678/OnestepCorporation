import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/home/widgets/notificationCard.dart';
import 'package:onestep_rezero/moor/moor_database.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

Stream<QuerySnapshot> mergedStream;
ScrollController _scrollController = ScrollController();

// 공지 (알림) -> notiEntire true (전체공지) or userUid 으로 판별하는 개인알림
// 추후에 id 값 변경해야함
Stream<List<QuerySnapshot>> combineStream() {
  Stream a = FirebaseFirestore.instance
      .collection('notification')
      .where('userUid', isEqualTo: "ciih53tTaJa1Q3wB1xjqxeJavEC3")
      .snapshots();
  Stream b = FirebaseFirestore.instance
      .collection('notification')
      .where('notiEntire', isEqualTo: true)
      .snapshots();

  return Rx.combineLatestList([a, b]);
}

class NotificationBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationChksDao p =
        Provider.of<AppDatabase>(context).notificationChksDao;
    return StreamBuilder(
      stream: combineStream(),
      builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot1) {
        return StreamBuilder(
          stream: p.watchNotification(),
          builder: (context, snapshot2) {
            switch (snapshot1.connectionState) {
              case ConnectionState.waiting:
                return Container();
              default:
                // // 알림 내부 DB에 아무것도 없으면
                if (snapshot2.data.length == 0)
                  return Center(
                      child: Container(
                    child: Text("알림이 없습니다"),
                  ));
                print("snapshot data = ${snapshot1.data}");
                List<DocumentSnapshot> documentSnapshot = [];

                List<dynamic> querySnapshot = snapshot1.data.toList();

                querySnapshot.forEach((query) {
                  documentSnapshot.addAll(query.docs);
                });

                List<DocumentSnapshot> documentSnapshot1 = [];
                print("document length ${documentSnapshot.length}");
                if (documentSnapshot.length > 1) {
                  documentSnapshot1 = documentSnapshot.toList()
                    ..sort((key1, key2) {
                      Timestamp a = key2.data()['time'];
                      Timestamp b = key1.data()['time'];
                      return a.compareTo(b);
                    });
                } else {
                  documentSnapshot1 = documentSnapshot;
                }
                List<Map<String, dynamic>> mappedData = [];
                for (QueryDocumentSnapshot doc in documentSnapshot1) {
                  mappedData.add(doc.data());
                  print("document data ${doc.data()}");

                  // 내부 DB 최근 알림(moor watch 보면 orderby) 보다
                  // 최근 알림이 오면 내부DB insert 하고 check 필드는 default false
                  // 밑에 onTap 부분 -> 읽음처리 부분 변경(check 필드 이용해서)
                  // 홈에서 빨간 버튼, 안읽은 알림 확인 내부 DB 다 돌려서 check 필드
                  // 1개라도 false 있으면 빨간색 띄우기

                  // // 아직 내부 DB에 아무것도 없음 밑에꺼 돌리면 다 들어감
                  // p.insertNotification(NotificationChk(
                  //     firestoreid: doc.id,
                  //     readChecked: 'false',
                  //     entireChecked: doc.data()['notiEntire'].toString(),
                  //     uploadtime: DateTime.parse(
                  //         doc.data()['time'].toDate().toString())));

                  NotificationChk latestTime =
                      snapshot2.data[0] as NotificationChk;
                  print("lastestTime ${latestTime.uploadtime}");
                  print(
                      "docTime ${DateTime.parse(doc.data()['time'].toDate().toString())}");
                  print(
                      "compareTime ${DateTime.parse(doc.data()['time'].toDate().toString()).isAfter(latestTime.uploadtime)}");

                  // 현재 내부DB에 저장된 최근 알림보다 더 최신 알림이면 insert
                  if (!DateTime.parse(doc.data()['time'].toDate().toString())
                      .isAfter(latestTime.uploadtime)) {
                    // p.insertNotification(NotificationChk(
                    //   firestoreid: doc.id,
                    //   readChecked: 'false',
                    //   uploadtime:
                    //       DateTime.parse(doc.data()['time'].toDate().toString())));
                  }
                }
                return ListView.builder(
                  key: PageStorageKey("any_text_here"),
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: mappedData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NotificationCard(
                        mappedData[index], documentSnapshot1[index].id);
                  },
                );
            }
          },
        );
      },
    );
  }
}
