import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => SearchAllMain(searchKey: 0)),
              ),
            },
          ),
        ],
      ),
      body: a(),
      // a(),
    );
  }
}
