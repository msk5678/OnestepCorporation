import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:onestep_rezero/myinfo/providers/providers.dart';
import 'package:onestep_rezero/notification/realtime/firebase_api.dart';

class UserProfileBody extends ConsumerWidget {
  Widget getUserName() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseApi.getId())
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return Text(
              snapshot.data['nickName'],
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
        }
      },
    );
  }

  Widget getUserImage() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseApi.getId())
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              width: 100,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            return snapshot.data.data()['photoUrl'] != ""
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data.data()['photoUrl'].toString(),
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 7,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error), // 로딩 오류 시 이미지
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.account_circle,
                    size: 100,
                  );
        }
      },
    );
  }

  Widget getImageTest() {
    return Image(
      image: AssetImage(
        getBackgroundImg(),
      ),
      fit: BoxFit.fitWidth,
    );
  }

  // Widget getUserGrade() {
  //   return FutureBuilder(
  //     future: null,
  //     // FirebaseFirestore.instance
  //     //     .collection("users")
  //     //     .doc(FirebaseApi.getId())
  //     //     .get(),
  //     builder:
  //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting:
  //           return Text("");
  //         default:
  //           return Container(
  //               height: 10,
  //               child: Text("${snapshot.data.data()['userLevel']}"));
  //       }
  //     },
  //   );
  // }

  String getBackgroundImg() {
    print("cex 확인");
    var backgroundImages = [
      "images/profile_back1.png",
      "images/profile_back2.png",
      "images/profile_back3.png",
      "images/profile_back4.png",
    ];
    int randomIndex = Random().nextInt(backgroundImages.length);

    return backgroundImages[randomIndex];
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final test2 = watch(progressValueProvider2);
    final progressValue = watch(progressValueProvider.state);
    final test = watch(testContaierPadding);
    final a = watch(progressValueProvider3);

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                // child: getImageTest(),
                child: Image(
                  image: AssetImage(
                    getBackgroundImg(),
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 50,
                    MediaQuery.of(context).size.height / 12,
                    0,
                    0),
                child: Row(
                  children: <Widget>[
                    getUserImage(),
                    SizedBox(width: 10),
                    getUserName(),
                  ],
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            // 이거 test -> 추후에 progressBar value db에 저장해서 세팅하고 거기에 맞춰서 다시 값 바꿔줘야함
            // context.read(progressValueProvider).increment();
            // test2.state += 0.1;
            // test.state += 29;
            a.increment();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(color: Colors.red),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 50, 0, 0, 0),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 100,
                  ),
                  // progress bar
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB((20 + test.state), 0, 0, 0),
                        child: Stack(
                          children: [
                            Positioned(
                                // bottom: 10,
                                // left: 1.5,
                                // right: 50,
                                // top: 10,
                                child: Container(
                                    child: Text(
                              "cex",
                              // style: TextStyle(fontSize: 1),
                            ))),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: 300,
                        height: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            semanticsValue: "cex",
                            // value: test2.state,
                            // value: progressValue,
                            value: a.a,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: ListTile.divideTiles(tiles: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text("판매 상품"),
                        onTap: () => {},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {},
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text("구매 상품"),
                        onTap: () => {
                          print("구매상품"),
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {},
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text("후기"),
                        onTap: () => {print("후기")},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {},
                    )
                  ],
                ),
              ], context: context)
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
