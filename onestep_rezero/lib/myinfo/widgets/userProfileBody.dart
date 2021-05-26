import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/main.dart';

class UserProfileBody extends ConsumerWidget {
  Widget getUserName() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("user")
          .doc(googleSignIn.currentUser.id)
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
          .collection("user")
          .doc(googleSignIn.currentUser.id)
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
            return snapshot.data.data()['imageUrl'] != ""
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data.data()['imageUrl'].toString(),
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
    // final progressValue = watch(progressValueProvider.state);
    // final test = watch(testContaierPadding);
    // final a = watch(progressValueProvider3);

    // String _image = 'images/person_walking.gif';
    // double _pointerValue = 0;
    // final Brightness _brightness = Theme.of(context).brightness;

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
