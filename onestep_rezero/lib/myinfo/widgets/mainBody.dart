import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/pages/myinfoSettingsPage.dart';
import 'package:onestep_rezero/myinfo/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyinfoMainBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 프사 변경도 에타처럼
              IconButton(
                icon:
                    // snapshot.data.data()['photoUrl'] != ""
                    //     // downloadURL != ""
                    //     ? ClipOval(
                    //         child: Image.network(
                    //         snapshot.data.data()['photoUrl'],
                    //         height: 100,
                    //         width: 100,
                    //         fit: BoxFit.cover,
                    //       ))
                    //     :
                    Icon(Icons.account_circle),
                color: Colors.black,
                iconSize: 100,
                onPressed: () async {
                  // // 프사 변경할때 image 가져오고 storage 저장 후 photoUrl 업데이트
                  // File image = await ImagePicker.pickImage(
                  //     source: ImageSource.gallery);
                  // StorageReference storageReference =
                  //     FirebaseStorage.instance.ref().child(
                  //         "user images/${randomAlphaNumeric(15)}");
                  // StorageUploadTask storageUploadTask =
                  //     storageReference.putFile(image);
                  // if (await storageUploadTask.onComplete !=
                  //     null) {
                  //   if (downloadURL != "") {
                  //     // firebase photourl 이용해서 storage 삭제
                  //     // 사진 데이터없애는거  이야기해서 생각 (ex) 이상한 사진 같은거 올리면 모름
                  //     FirebaseStorage.instance
                  //         .getReferenceFromUrl(downloadURL)
                  //         .then((reference) => reference.delete())
                  //         .catchError((e) => print(e));
                  //     // 그리고 photoUrl "" 리셋
                  //     FirebaseFirestore.instance
                  //         .collection("users")
                  //         .doc("${FirebaseApi.getId()}")
                  //         .update({
                  //       "photoUrl": "",
                  //     });
                  //     downloadURL =
                  //         await storageReference.getDownloadURL();
                  //     FirebaseFirestore.instance
                  //         .collection("users")
                  //         .doc("${FirebaseApi.getId()}")
                  //         .update({
                  //       "photoUrl": downloadURL,
                  //     });
                  //   } else {
                  //     downloadURL =
                  //         await storageReference.getDownloadURL();
                  //     FirebaseFirestore.instance
                  //         .collection("users")
                  //         .doc("${FirebaseApi.getId()}")
                  //         .update({
                  //       "photoUrl": downloadURL,
                  //     });
                  //   }
                  //   setState(() {});
                  // }
                },
              ),

              Column(
                children: [
                  Container(
                    child: Text(
                      "김성훈",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    child: Text(
                      "계명대학교",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(170, 0, 0, 0),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.black,
                  iconSize: 30,
                  onPressed: () async {
                    // test 초기화 나중에 회원가입 폼에서 푸시알림이나 이벤트알림 등 푸시알림 받을건지 물어보는 창 만들어서 거기서
                    // 수락하거나 거절하는 결과에 따라서 insert 하고 메인으로 넘어오게 만들어야함
                    // p.insertPushNotice(PushNoticeChk(
                    //     firestoreid: FirebaseApi.getId(),
                    //     pushChecked: 'true',
                    //     marketingChecked: 'true'));

                    // provider 쓰려면 이렇게 consumer로 넘겨줘야함
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             Consumer<MyinfoProvider>(
                    //               builder: (context,
                    //                       myinfoProvider,
                    //                       _) =>
                    //                   MyinfoSettingsPage(
                    //                 myinfoProvider:
                    //                     myinfoProvider,
                    //                 initPushSwitchedValue:
                    //                     snapshot1
                    //                         .data
                    //                         .first
                    //                         .pushChecked,
                    //                 initMarketingSwitchedValue:
                    //                     snapshot1
                    //                         .data
                    //                         .first
                    //                         .marketingChecked,
                    //               ),
                    //             )));

                    // SharedPreferences 내부 db
                    SharedPreferences _prefsPush;
                    SharedPreferences _prefsMarketing;
                    _prefsPush = await SharedPreferences.getInstance();
                    // set 부분은 추후에 회원가입할때 푸시 알림 받으시겠습니까? ok -> true, no -> false
                    // 줘서 로그인할때 set 해주는 코드 넣기 지금은 임시
                    _prefsPush.setBool('value', true);
                    context
                        .read(switchCheckPush)
                        .changeSwitch(_prefsPush.getBool('value'));
                    _prefsMarketing = await SharedPreferences.getInstance();
                    _prefsMarketing.setBool('value', true);
                    context
                        .read(switchCheckMarketing)
                        .changeSwitch(_prefsMarketing.getBool('value'));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MyinfoSettingsPage(_prefsPush, _prefsMarketing)));
                  },
                ),
              )
            ],
          ),
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
