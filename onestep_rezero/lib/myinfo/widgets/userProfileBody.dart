import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfileBody extends StatelessWidget {
  Widget getUserName() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc('ciih53tTaJa1Q3wB1xjqxeJavEC3')
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return Text(
              snapshot.data['nickname'],
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
          .doc('ciih53tTaJa1Q3wB1xjqxeJavEC3')
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
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
                : Icon(Icons.account_circle);
        }
      },
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
  Widget build(BuildContext context) {
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
                child: Image(
                  image: AssetImage(
                    getBackgroundImg(),
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Row(
                children: <Widget>[
                  getUserImage(),
                  SizedBox(width: 10),
                  getUserName(),
                ],
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            print("확인");
          },
          child: Container(
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(color: Colors.red),
            child: Column(
              children: [
                // Text("5티어"),
                // getUserGrade(),
              ],
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
