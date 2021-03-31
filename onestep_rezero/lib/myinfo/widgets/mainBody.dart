import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/widgets/userProfile.dart';

// final _storage = FirebaseStorage.instanceFor(
//     bucket: 'gs://onestep-project.appspot.com/user images');

class MyinfoMainBody extends ConsumerWidget {
  // stroage 삭제 보류
  // Future<void> deleteImageFromDB(String imageUrl) async {
  //   var photo = _storage.refFromURL(imageUrl);
  //   await photo.delete();
  // }
  // Future<void> deleteFile(String url) async {
  //   try {
  //     await FirebaseStorage.instance.refFromURL(url).delete();
  //   } catch (e) {
  //     print("Error deleting db from cloud: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserProfile(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           ProfileWidget(
                        //             uid: FirebaseApi
                        //                 .getId(),
                        //           )),
                        // );
                      },
                      icon: Icon(Icons.error_outline),
                    ),
                    Text("프로필보기"),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Navigator.of(context)
                        //     .push(MaterialPageRoute(
                        //   builder: (context) =>
                        //       Consumer<MyProductProvider>(
                        //     builder: (context,
                        //             myProductProvider,
                        //             _) =>
                        //         MyinfoMyWrite(
                        //       myProductProvider:
                        //           myProductProvider,
                        //     ),
                        //   ),
                        // ));
                      },
                      icon: Icon(Icons.error_outline),
                    ),
                    Text("내가쓴글"),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         Consumer<
                        //             FavoriteProvider>(
                        //       builder: (context,
                        //               favoriteProvider,
                        //               _) =>
                        //           FavoriteWidget(
                        //         favoriteProvider:
                        //             favoriteProvider,
                        //       ),
                        //     ),
                        //   ),
                        // );
                      },
                      icon: Icon(Icons.error_outline),
                    ),
                    Text("찜목록"),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Container(
              child: Text(
                "인증",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "학교 인증",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      // p.deleteAllPushNotice();
                    },
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Container(
              child: Text(
                "정보",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              print("click");
              // Navigator.of(context).push(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             NotificationPage()));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      "공지사항",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "문의사항",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "고객센터",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "개인정보 처리방침",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "서비스 이용약관",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "버전정보",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
