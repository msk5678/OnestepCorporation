import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "공지사항",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('notice')
              .orderBy('time', descending: true)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container();
              default:
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: ListView(
                    // QureySnapshot -> Document 데이터 접근할 때 이런식으로
                    children: snapshot.data.docs.map((DocumentSnapshot doc) {
                      Timestamp tempTime = doc.data()['time'];
                      return InkWell(
                        onTap: () {
                          print("doc id = ${doc.id}");
                          // 찬섭이형 게시글 형식으로 넘어가야함, 이야기해보기
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(doc.data()['title']),
                              subtitle: Text(
                                  DateTime.parse(tempTime.toDate().toString())
                                      .toString()),
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
            }
          },
        ));
  }
}
