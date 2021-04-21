import 'package:algolia/algolia.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onestep_rezero/home/pages/homeNotificationPage.dart';
import 'package:onestep_rezero/moor/moor_database.dart';
import 'package:onestep_rezero/notification/realtime/firebase_api.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';
import 'package:provider/provider.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  search() async {
    List<AlgoliaObjectSnapshot> _results = [];

    Algolia algolia = Algolia.init(
      applicationId: 'SM0LVJM1EL',
      apiKey: '67bfc3f1aa7f241789e0a88b2c90a3b9',
    );

    AlgoliaQuery query = algolia.instance.index('products');
    query = query.query("duck");

    _results = (await query.getObjects()).hits;

    print("@@@@@@@@@@@@ length : ${_results.length}");
    _results.forEach((e) => print("@@@@@@@@@ data : ${e.data}"));
  }

  Widget a() {
    search();
    return Container();
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
    );
  }
}
