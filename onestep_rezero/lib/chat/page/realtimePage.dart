import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/boardchat/model/productChat.dart';
import 'package:onestep_rezero/chat/boardchat/model/productChatCount.dart';
import 'package:onestep_rezero/chat/boardchat/realtimeProductChatController.dart';
import 'package:onestep_rezero/chat/navigator/chatNavigationManager.dart';
import 'package:onestep_rezero/chat/widget/chatBadge.dart';
import 'package:onestep_rezero/chat/widget/chat_list_time.dart';
import 'package:onestep_rezero/main.dart';

class RealTimePage extends StatefulWidget {
  @override
  _RealTimePageState createState() => _RealTimePageState();
}

class _RealTimePageState extends State<RealTimePage>
    with AutomaticKeepAliveClientMixin<RealTimePage> {
  _RealTimePageState();

  ProductChat productChat;

  List<ProductChat> listProductChat = [];
  List<ProductChatCount> listProductChatCount = [];

  DatabaseReference databasereference =
      FirebaseDatabase.instance.reference().child("path");

  DatabaseReference productchatdatabasereference = FirebaseDatabase.instance
          .reference()
          .child("chattingroom")
          .child("productchat")
      //.child("roominfo")
      ;

  String uId;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    productChat = ProductChat();
    uId = googleSignIn.currentUser.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('채팅&알림'),
      //   actions: [
      //     _buildsave(context),
      //     _buildload(context),
      //     _buildjson(context),
      //     _buildupdate(context),
      //   ],
      // ),
      body:
          // Column(
          //   children: [
          //_buildOnlyStream(),
          //_buildChatListStream(),
          _buildChatListListTileStream(),
      //  ],
      // ),
    );
  }

  Widget _buildChatListListTileStream() {
    bool userExist = false;
    //final chatCount = Provider.of<ChatCount>(context); //카운트 프로바이더

    return StreamBuilder(
      stream:
          //comments
          productchatdatabasereference
              // .child("roominfo")
              // .orderByChild("users/1")
              .orderByChild("users/${googleSignIn.currentUser.id.toString()}")
              .equalTo(true)
              .onValue, //조건1.  타임스탬프 기준
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            print("연결상태 : " + snapshot.connectionState.toString());
            return CircularProgressIndicator();
          // case ConnectionState.active:
          //   Future.delayed(const Duration(seconds: 1));
          //   print("연결되었지만 대기중! : " + snapshot.connectionState.toString());
          //   return CircularProgressIndicator();
          default:
            Future.delayed(const Duration(seconds: 1));
            print("연결상태 : " + snapshot.connectionState.toString());
            if (snapshot == null ||
                !snapshot.hasData ||
                snapshot.data.snapshot.value == null) {
              print("stream values if0 null : ${snapshot.data.snapshot.value}");
              return Container(child: Center(child: Text("No data")));
            } else {
              //chatCount.initChatCount();

              print("stream values else1 : ${snapshot.data.snapshot.value}");
              print(
                  "stream values else1 : ${snapshot.data.snapshot.value['message']}");
              // print("stream values else1 : ${snapshot.data}");
              // print("stream values else1 : ${snapshot.toString()}");

              print(
                  "stream values else1 message@@ : ${snapshot.data.snapshot.value['message']}");
              listProductChat.clear(); //리스트 챗리스트 클리어
              listProductChatCount.clear(); //리스트 챗리스트 카운트 클리어
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic> values = dataValues.value;
              Map<dynamic, dynamic> mesageValues;
              Map<dynamic, dynamic> mesageInValues;
              print("##걍StrTest" + values.toString());
              values.forEach((key, values) {
                // print("걍프린트" + values['users'].toString());
                print("stream values else1 message :" +
                    values['message'].length.toString());
                mesageValues = values['message'];

                print("stream values else2 bo :" +
                    values['boardtype'].toString());

                print("stream values else3-1 :" + key.toString());
                print("stream values else3-2 :" + values['users'].toString());
                print("stream values else3-3 :" +
                    values['users'][uId].toString());
                print("stream values else3-3 :" + values['users'].toString());
                var obj = values['users'].keys.toString();
                var obj3 = values['users'].keys.toList()[0];
                var obj4 = values['users'].keys.toList()[1];

                print("stream values else3-4 $obj :" +
                    values['users'][0].toString());
                print("stream values else3-5 $obj3 :");
                print("stream values else3-6 $obj4 :");

                userExist = true;
                listProductChat.add(
                    ProductChat.forMapSnapshot(values)); //조건2. 유저 포함된 것만 저장

                print(
                    "##stream values else length${listProductChat.length.toString()}");
                print("##stream values else length${values.toString()}");

                print("stream values else1 message Values :" +
                    mesageValues.toString());
                int len = 0;
                mesageValues.forEach((mkey, mesageValues) {
                  //메시지 내부 분해,
                  print("stream values else1 message ForEach: Origin Key : " +
                      key.toString() +
                      " / Length : " +
                      mesageValues.length.toString() +
                      " // M_Key : " +
                      mkey.toString() +
                      " / idTo : " +
                      mesageValues['idTo'].toString());
                  mesageInValues = mesageValues['idTo'];
                  mesageInValues.forEach((mIkey, mIvalue) {
                    //보낸 사람 분해.
                    print(
                        "stream values else1 message ForEach: MyUid : ${googleSignIn.currentUser.id.toString()}");

                    if (mIvalue == false &&
                        mIkey == googleSignIn.currentUser.id.toString()) {
                      len++;
                      print(
                          "stream values else1 message ForEach: 읽지 않은 메세지 있음. len : $len");
                    }
                    print(
                        "stream values else1 message ForEach: InMessageKey : ${mIkey} // InMessageValue : ${mIvalue}");
                  });
                }); //메시지 내부 분해 종료
                print("리얼타임 메세지 처리 1 : $key /// $len /// $values");
                listProductChatCount
                    .add(ProductChatCount.forMapSnapshot(key, len, values));
                print("리얼타임 메세지 처리 반복 진행중");
              }); //채팅방 반복 종료
              print("리얼타임 메세지 처리 완료 ");
              //1. 챗 리스트 정렬
              listProductChat.sort((b, a) =>
                  a.timeStamp.compareTo(b.timeStamp)); //정렬3. 시간 순 정렬 가능.
              print("stream values else : 솔트완료");
              //2. 챗 카운트 정렬
              listProductChatCount
                  .sort((b, a) => a.timeStamp.compareTo(b.timeStamp));
              int sum = 0;
              listProductChatCount.forEach((count) {
                sum += count.chatCount;
              });
              RealtimeProductChatController()
                  .setToFirebaseProductChatCount(sum);
              return userExist == true
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: listProductChat.length,
                      itemBuilder: (context, index) {
                        String productsUserId; //장터 상대방 Id
                        listProductChat[index].user1 ==
                                googleSignIn.currentUser.id
                            ? productsUserId = listProductChat[index].user2
                            : productsUserId = listProductChat[index].user1;
                        print(
                            "##dd $productsUserId : '${listProductChat[index].chatId.toString()}/message'");
                        "$productsUserId" //시발왜다름
                                ==
                                "108438757310040285856"
                            ? print(
                                "같음 pro Id : $productsUserId // 108438757310040285856")
                            : print(
                                "다름 pro Id : $productsUserId !// 108438757310040285856");

                        return ListTile(
                          leading: Material(
                            child: RealtimeProductChatController()
                                .getUserImage(productsUserId),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          //leading end
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                RealtimeProductChatController()
                                    .getProductUserNickname(productsUserId),

                                SizedBox(width: 10, height: 10),
                                Spacer(),
                                //시간
                                getChatListTime(
                                    listProductChat[index].timeStamp),
                              ],
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //SizedBox(width: 10, height: 10),
                              Text(
                                  listProductChat[index].recentText.toString()),
                              SizedBox(width: 10, height: 10),
                              Spacer(),
                              chatCountBadge(
                                  listProductChatCount[index].chatCount),
                            ],
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Material(
                                  child: CachedNetworkImage(
                                    imageUrl: listProductChat[index]
                                        .productImage
                                        .toString(),
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            ChatNavigationManager
                                .navigateToRealTimeChattingRoom(
                              context,
                              listProductChat[index].user1,
                              listProductChat[index].user2,
                              listProductChat[index].postId,
                            );
                          },
                        );
                      },
                    )
                  : Text("생성된 채팅방이 없습니다. . !");
            }
        }
      },
    );
  }

  DatabaseReference productChatMessageReference2 = FirebaseDatabase.instance
      .reference()
      .child("chattingroom")
      .child("productchat")
      .child("1615196869418/message");

  // RealTimeChatNavigationManager.navigateToChattingRoom(
  //   context,
  //   googleSignIn.currentUser.id.toString(),
  //   widget.product.uid,
  //   widget.product.firestoreid,
  // );

  // Widget _buildsave(var context) {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: <Widget>[
  //       IconButton(
  //           icon: Icon(Icons.save),
  //           onPressed: () {
  //             initData();
  //           }),
  //       Positioned(
  //         top: 12.0,
  //         right: 10.0,
  //         width: 10.0,
  //         height: 10.0,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             //color: AppColors.notification,
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
