import 'package:algolia/algolia.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onestep_rezero/home/pages/homeNotificationPage.dart';
import 'package:onestep_rezero/moor/moor_database.dart';
import 'package:onestep_rezero/notification/realtime/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';
import 'package:provider/provider.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  // Widget search() {
  //   return StreamBuilder<List<AlgoliaObjectSnapshot>>(
  //     stream: Stream.fromFuture(operation("리거")),
  //     builder: (BuildContext context,
  //         AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting:
  //           return Container(
  //             child: Text("@@@"),
  //           );
  //         default:
  //           // print(snapshot.data.length);
  //           snapshot.data.forEach((e) => print(e.data.toString()));
  //           return ListView.builder(
  //             itemCount: snapshot.data.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return ListTile(
  //                 title: Text(snapshot.data[index].data['title']),
  //               );
  //             },
  //           );
  //       }
  //     },
  //   );
  // }

  Widget a() {
    return Column(
      children: <Widget>[
        TextButton(
          onPressed: () {
            int time = DateTime.now().microsecondsSinceEpoch;
            FirebaseFirestore.instance
                .collection("products")
                .doc(time.toString())
                .set({
              'uid': googleSignIn.currentUser.id.toString(),
              'price': "22,000",
              'title': "트리거 테스트40",
              'category': "테스트",
              'explain': "테스트",
              'images': [
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtzfgVAiFqLmcrULkb5qDJ16hlDgsMsB83EQ&usqp=CAU"
              ],
              'favorites': 0,
              'hide': false,
              'deleted': false,
              'views': {},
              'uploadtime': time,
              'updatetime': time,
              'bumptime': time,
            });
          },
          child: Text("생성"),
        ),
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection("products")
                .where('title', isEqualTo: "트리거 테스트")
                .get()
                .then((value) => value.docs.forEach((e) => FirebaseFirestore
                    .instance
                    .collection("products")
                    .doc(e.id)
                    .delete()));
          },
          child: Text("삭제"),
        ),
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection("products")
                .where('title', isEqualTo: "트리거 테스트")
                .get()
                .then((value) => value.docs.forEach((e) => FirebaseFirestore
                    .instance
                    .collection("products")
                    .doc(e.id)
                    .update({'title': "트리거트리거"})));
          },
          child: Text("갱신"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    NotificationChksDao p =
        Provider.of<AppDatabase>(context).notificationChksDao;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: Text("홈", style: TextStyle(color: Colors.black)),
        title: Text(FirebaseApi.getId(), style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => SearchAllMain(searchKey: 0)),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none),
                    color: Colors.black,
                    onPressed: () {
                      // 알림으로 넘어가는 부분
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeNotificationPage(),
                      ));
                      // 신고 test
                      // showModalBottomSheet(
                      //     context: context,
                      //     builder: buildBottomSheet,
                      //     isScrollControlled: false);
                      // 쪽지 form 보려고 test
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => MessagePage(),
                      // ));
                    },
                  ),
                  StreamBuilder(
                      stream: p.watchNotificationAll(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Positioned(
                              top: 8,
                              right: 10,
                              child: Icon(
                                  // check 다 했으면 아이콘이 없는 쪽으로 코드 변경
                                  null),
                            );

                          default:
                            bool chk = true;
                            if (snapshot.data != null) {
                              List<NotificationChk> notiList = snapshot.data;
                              chk = notiList.isEmpty;
                            }
                            return Positioned(
                              top: 8,
                              right: 10,
                              child: chk
                                  ? Container()
                                  : Icon(
                                      Icons.brightness_1,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                            );
                        }
                      }),
                ]),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: a(),
      // a(),
    );
  }
}
