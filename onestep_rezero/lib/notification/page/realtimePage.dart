// import 'package:flutter/material.dart';

// class RealTimePage extends StatefulWidget {
//   @override
//   _RealTimePageState createState() => _RealTimePageState();
// }

// class _RealTimePageState extends State<RealTimePage>
//     with AutomaticKeepAliveClientMixin<RealTimePage> {
//   _RealTimePageState();

//   ProductChat productChat;

//   List<ProductChat> listProductChat = List();

//   DatabaseReference databasereference =
//       FirebaseDatabase.instance.reference().child("path");

//   DatabaseReference productchatdatabasereference = FirebaseDatabase.instance
//           .reference()
//           .child("chattingroom")
//           .child("productchat")
//       //.child("roominfo")
//       ;

//   String uId;
//   int d;
//   @override
//   bool get wantKeepAlive => true;

//   Future<int> test() async {
//     d = await RealtimeProductChatController().fuckShitChatCount("ddd");
//     print("@@@@@@@@@dd $d");
//     return Future.delayed(Duration(seconds: 1), () => d);
//   }

//   @override
//   void initState() {
//     super.initState();
//     productChat = ProductChat();
//     uId = FirebaseApi.getId();

//     // databasereference.onChildAdded.listen((_onAddData));
//     // databasereference.onChildAdded.listen((_onChanged));

//     // databasereference.onValue.listen((_onAddData));
//     // databasereference.onValue.listen((_onChanged));
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('채팅&알림'),
//       //   actions: [
//       //     _buildsave(context),
//       //     _buildload(context),
//       //     _buildjson(context),
//       //     _buildupdate(context),
//       //   ],
//       // ),
//       body:
//           // Column(
//           //   children: [
//           //_buildOnlyStream(),
//           //_buildChatListStream(),
//           _buildChatListListTileStream(),
//       //  ],
//       // ),
//     );
//   }

//   void _onAddData(Event event) {
//     setState(() {
//       print("####에드 스테이트 실행" + event.snapshot.value.toString());

//       listProductChat.add(ProductChat.forSnapshot(event.snapshot));
//     });
//   }

//   void _onChanged(Event event) {
//     print("####체인치 스테이트 실행11111");
//     // var oldData = listProductChat.singleWhere((entry) {
//     //   return entry.key == event.snapshot.key;
//     // });
//     // setState(() {
//     //   print("####체인치 스테이트 실행");
//     //   listProductChat[listProductChat.indexOf(oldData)] =
//     //       ProductChat.forSnapshot(event.snapshot);
//     // });
//   }

//   Widget _buildChatListListTileStream() {
//     bool userExist = false;
//     final chatCount = Provider.of<ChatCount>(context); //카운트 프로바이더

//     return StreamBuilder(
//       stream:
//           //comments
//           productchatdatabasereference
//               // .child("roominfo")
//               // .orderByChild("users/1")
//               .orderByChild("users/${FirebaseApi.getId()}")
//               .equalTo(true)
//               .onValue, //조건1.  타임스탬프 기준
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return CircularProgressIndicator();
//           default:
//             if (snapshot == null ||
//                 !snapshot.hasData ||
//                 snapshot.data.snapshot.value == null) {
//               print("stream values if0 null : ${snapshot.data.snapshot.value}");
//               return Container(child: Center(child: Text("No data")));
//             } else {
//               chatCount.initChatCount();

//               print("stream values else1 : ${snapshot.data.snapshot.value}");
//               listProductChat.clear(); //리스트 클리어
//               DataSnapshot dataValues = snapshot.data.snapshot;
//               Map<dynamic, dynamic> values = dataValues.value;
//               print("##걍StrTest" + values.toString());
//               values.forEach((key, values) {
//                 // print("걍프린트" + values['users'].toString());
//                 print("stream values else2 bo :" +
//                     values['boardtype'].toString());

//                 print("stream values else3-1 :" + key.toString());
//                 print("stream values else3-2 :" + values['users'].toString());
//                 print("stream values else3-3 :" +
//                     values['users'][uId].toString());
//                 print("stream values else3-3 :" + values['users'].toString());
//                 var obj = values['users'].keys.toString();
//                 var obj3 = values['users'].keys.toList()[0];
//                 var obj4 = values['users'].keys.toList()[1];

//                 print("stream values else3-4 $obj :" +
//                     values['users'][0].toString());
//                 print("stream values else3-5 $obj3 :");
//                 print("stream values else3-6 $obj4 :");

//                 //수정 전 전부 불러와서 처리
//                 //유저 포함과정을 쿼리문에 사용했으므로 사용하지 않음
//                 // if (values['users'][0] == FirebaseApi.getId() ||
//                 //     values['users'][1] == FirebaseApi.getId()) {
//                 //   userExist = true;
//                 //   print("##stream values else4 : 아이디 확인 ${FirebaseApi.getId()}");

//                 //   listProductChat
//                 //       .add(ProductChat.forMapSnapshot(values)); //조건2. 유저 포함된 것만 저장
//                 // }
//                 //수정 후 쿼리문 처리
//                 userExist = true;
//                 listProductChat.add(
//                     ProductChat.forMapSnapshot(values)); //조건2. 유저 포함된 것만 저장

//                 print(
//                     "##stream values else length${listProductChat.length.toString()}");
//                 print("##stream values else length${values.toString()}");
//               });

//               listProductChat.sort((b, a) =>
//                   a.timeStamp.compareTo(b.timeStamp)); //정렬3. 시간 순 정렬 가능.
//               print("stream values else : 솔트완료");

//               return userExist == true
//                   ? ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: listProductChat.length,
//                       itemBuilder: (context, index) {
//                         String productsUserId; //장터 상대방 Id
//                         listProductChat[index].user1 == FirebaseApi.getId()
//                             ? productsUserId = listProductChat[index].user2
//                             : productsUserId = listProductChat[index].user1;
//                         print(
//                             "##dd'${listProductChat[index].chatId.toString()}/message'");
//                         return ListTile(
//                           leading: ProductChatController()
//                               .getUserImage(productsUserId),
//                           //leading end
//                           title: Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: <Widget>[
//                                 ProductChatController()
//                                     .getProductUserNickname(productsUserId),
//                                 SizedBox(width: 10, height: 10),
//                                 Spacer(),

//                                 //Text(listProductChat[index].timeStamp.toString()),
//                                 GetRealTime(listProductChat[index].timeStamp),
//                                 //GetTime(chatroomData),
//                               ],
//                             ),
//                           ),
//                           subtitle: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               //SizedBox(width: 10, height: 10),
//                               Text(
//                                   listProductChat[index].recentText.toString()),
//                               SizedBox(width: 10, height: 10),
//                               Spacer(),
//                               // readCount

//                               // ProductChatController().getProductChatReadCounts(
//                               //     chatroomData.id, snapshot.data.size),
//                               //Text(listProductChat[index].chatId.toString()),
//                               //Text(chatKey),

//                               Text(test().toString()),
//                               RealtimeProductChatController()
//                                   .getRealtimeFutureProductChatReadCounts(
//                                       listProductChat[index].chatId.toString()),

// //원본 3줄
//                               // RealtimeProductChatController()
//                               //     .getRealtimeProductChatReadCounts(
//                               //         listProductChat[index].chatId.toString()),

//                               // getChatReadCounts(),
//                             ],
//                           ),
//                           trailing: Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Material(
//                                   child: ExtendedImage.network(
//                                     listProductChat[index]
//                                         .productImage
//                                         .toString(),
//                                     width: 55,
//                                     height: 55,
//                                     fit: BoxFit.cover,
//                                     cache: true,
//                                   ),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(6.0)),
//                                   clipBehavior: Clip.hardEdge,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           onTap: () {
//                             RealTimeChatNavigationManager
//                                 .navigateToRealTimeChattingRoom(
//                               context,
//                               listProductChat[index].user1,
//                               listProductChat[index].user2,
//                               listProductChat[index].postId,
//                             );
//                           },
//                         );
//                       },
//                     )
//                   : Text("생성된 채팅방이 없습니다. . !");
//             }
//         }
//       },
//     );
//   }

//   DatabaseReference productChatMessageReference2 = FirebaseDatabase.instance
//       .reference()
//       .child("chattingroom")
//       .child("productchat")
//       .child("1615196869418/message");

//   // RealTimeChatNavigationManager.navigateToChattingRoom(
//   //   context,
//   //   FirebaseApi.getId(),
//   //   widget.product.uid,
//   //   widget.product.firestoreid,
//   // );

//   Widget _buildChatListStream() {
//     bool userExist = false;
//     return StreamBuilder(
//       stream: databasereference
//           //.orderByChild("boardtype")
//           //.equalTo("22번")
//           .onValue, //조건1.  타임스탬프 기준

//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           listProductChat.clear(); //리스트 클리어
//           DataSnapshot dataValues = snapshot.data.snapshot;
//           Map<dynamic, dynamic> values = dataValues.value;
//           print("##StrTest" + values.toString());
//           values.forEach((key, values) {
//             if (values['users'][0] == '유저11' || values['users'][1] == '유저11') {
//               userExist = true;
//               listProductChat
//                   .add(ProductChat.forMapSnapshot(values)); //조건2. 유저 포함된 것만 저장
//             }
//             print("##stream length${listProductChat.length.toString()}");
//             print(values.runtimeType);
//             print("##stream length${values.toString()}");

//             // print("##stream ${values.toString()}");
//             // print("##stream value${values['boardtype'].toString()}");

//             // print("##stream 언제찍힘? 1" + dss[0].boardType);
//             //return Text("시발");
//             // return Column(
//             //   children: [
//             //     Text(values['boardtype'].toString()),
//             //     Text(values['users'].toString()),
//             //     // Text(listProductChat[index].key.toString() + "$index"),
//             //     // Text("기여운 깡통유저 : " + snapshot.value['users'][0]),
//             //     // Text(snapshot.value['users'][1]),
//             //     // Text(snapshot2.data.toString()),
//             //     SizedBox(
//             //       height: 10,
//             //       width: 10,
//             //     ),
//             //   ],
//             // );
//           });

//           listProductChat.sort(
//               (a, b) => a.boardType.compareTo(b.boardType)); //정렬3. 시간 순 정렬 가능.
//           return userExist == true
//               ? ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: listProductChat.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       child: Column(
//                         children: <Widget>[
//                           Text(listProductChat[index].boardType.toString()),
//                           Text(listProductChat[index].postId.toString()),
//                         ],
//                       ),
//                     );
//                   },
//                 )
//               : Text("생성된 채팅방이 없습니다. . !");
//         } else
//           return Text(
//               "데이터 없음데이터 없음데이터 없음데이터 없음데이터 없음데이터 없음데이터 없음데이터 없음데이터 없음데이터 없음");
//       },
//     );
//   }

//   void initData() {
//     productChat.boardType = "2번";
//     productChat.postId = 'ㅇㄶㅁㄴㅇㅎ';
//     productChat.productImage = '경로없음';
//     productChat.recentText = '7번 추가';
//     productChat.title = '제목';
//     productChat.timeStamp = '내일';
//     productChat.user1 = '유저11';
//     productChat.user2 = '유저22';
//     //productChat.users = ['멀티1', '멀티2'];
//     print("리얼타임 이니트");
//   }

//   Widget _buildsave(var context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         IconButton(
//             icon: Icon(Icons.save),
//             onPressed: () {
//               initData();
//             }),
//         Positioned(
//           top: 12.0,
//           right: 10.0,
//           width: 10.0,
//           height: 10.0,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               //color: AppColors.notification,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildload(var context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         IconButton(
//             icon: Icon(Icons.read_more),
//             onPressed: () {
//               productChat.load();
//               print("불러오기");
//             }),
//         Positioned(
//           top: 12.0,
//           right: 10.0,
//           width: 10.0,
//           height: 10.0,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               //color: AppColors.notification,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildupdate(var context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         IconButton(
//             icon: Icon(Icons.read_more),
//             onPressed: () {
//               setState(() {
//                 var t = {"boardtype": "멀티 3"};
//                 FirebaseDatabase.instance
//                     .reference()
//                     .child("path")
//                     .child("testSS_Mul3번")
//                     .update(t);
//                 print("수정하기");
//               });
//             }),
//         Positioned(
//           top: 12.0,
//           right: 10.0,
//           width: 10.0,
//           height: 10.0,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               //color: AppColors.notification,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildjson(var context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         IconButton(
//             icon: Icon(Icons.ac_unit),
//             onPressed: () {
//               //productChat.toJson();
//               print("JSON 실행");
//               productChat.createChat("testSS_Mul3");
// //              database.child("test").set(productChat.toJson());

//               //print(productChat.toJson());
//               print("JSON");
//             }),
//         Positioned(
//           top: 12.0,
//           right: 10.0,
//           width: 10.0,
//           height: 10.0,
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               //color: AppColors.notification,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
