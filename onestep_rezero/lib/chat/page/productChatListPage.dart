import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/chat/navigator/chatNavigationManager.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatListController.dart';

import 'package:onestep_rezero/chat/productchat/model/productChatList.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatListCount.dart';
import 'package:onestep_rezero/chat/widget/chatBadge.dart';
import 'package:onestep_rezero/chat/widget/chat_list_time.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductChatListPage extends StatefulWidget {
  @override
  _ProductChatListPageState createState() => _ProductChatListPageState();
}

class _ProductChatListPageState extends State<ProductChatListPage>
    with AutomaticKeepAliveClientMixin<ProductChatListPage> {
  _ProductChatListPageState();

  List<ProductChatList> listProductChat = [];
  List<ProductChatListCount> listProductChatCount = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _buildChatListListTileStream(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 30.0,
        ),
        child: FloatingActionButton(
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildChatListListTileStream() {
    bool userExist = false;
    return
        // ConstrainedBox(
        //   constraints: new BoxConstraints(
        //     minHeight: 50.0,
        //     maxHeight: 260.0,
        //   ),
        //   child:
        StreamBuilder(
      stream: ProductChatController.productChatReference
          .orderByChild("chatUsers/${currentUserModel.uid}/hide")
          .equalTo(false)
          .onValue, //조건1.  타임스탬프 기준
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  "채팅방을 불러오고 있습니다..!",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            );

          default:
            if (snapshot == null ||
                !snapshot.hasData ||
                snapshot.data.snapshot.value == null) {
              // print("stream values if0 null : ${snapshot.data.snapshot.value}");
              return Center(
                child: Container(
                  width: 200.h,
                  height: 200.h,
                  color: Colors.white,
                  child: Center(
                    child: Text("생성된 채팅이 없습니다..!"),
                  ),
                ),
              );
            } else {
              //print("stream values else1 : ${snapshot.data.snapshot.value}");
              //print("stream values else1 : ${snapshot.data.snapshot.value['message']}");

              //print("stream values else1 message@@ : ${snapshot.data.snapshot.value['message']}");
              listProductChat.clear(); //리스트 챗리스트 클리어
              listProductChatCount.clear(); //리스트 챗리스트 카운트 클리어
              DataSnapshot dataValues = snapshot.data.snapshot;
              Map<dynamic, dynamic> values = dataValues.value;
              Map<dynamic, dynamic> mesageValues;
              Map<dynamic, dynamic> mesageInValues;
              // print("##ProductMessage 1 / chatId 내부의 메세지 값 들고오기 : " +values.toString());
              values.forEach((key, values) {
                // print("걍프린트" + values['user'].toString());
                //print("##ProductMessage 2-1 / key : $key , values : $values ");
                // print("##ProductMessage 3 / chatId - message 내부 값 : " +values.toString());
                //print("##ProductMessage 4 / chatId의 key 값 : " + key.toString());
                // print("##ProductMessage 5 / chatId - ChatUsers 목록 : " +values['chatUsers'].toString());
                // print("##ProductMessage 6 / chatId - ChatUsers - MyUid 값 : " +
                //     values['chatUsers'][googleSignIn.currentUser.id]
                //         .toString());

                // var obj = values['chatUsers'].keys.toString();
                // var obj3 = values['chatUsers'].keys.toList()[0];
                // var obj4 = values['chatUsers'].keys.toList()[1];

                // print("##ProductMessage 7 / chatId의 keys : $obj , [0] : $obj3, [1] : $obj4");

                userExist = true;
                listProductChat.add(
                    ProductChatList.forMapSnapshot(values)); //조건2. 유저 포함된 것만 저장
                // print(
                //     "####ProductMessage 8 / chatId에 유저정보 보유, 챗리스트 추가, 현재 length : ${listProductChat.length.toString()}");
                // print(
                //     "####ProductMessage 9 / chatId에 추가된 value : ${values.toString()}");

// //여기서 부터 메세지 다
//                 print("stream values else1 message Values :" +
//                     mesageValues.toString());

                int len = 0;

                if (values['message'] != null) {
                  // print(
                  //     "####ProductMessage 9999999 : message Exist Check : $mesageValues");
                  // print(
                  //     "####ProductMessage 9999999 Top : message Exist Check : $mesageValues");
                  // print("##ProductMessage 2-2 / chatId - message Length 반환 : " +
                  //     values['message'].length.toString());
                  mesageValues = values['message'];

                  mesageValues.forEach(
                    (mkey, mesageValues) {
                      //메시지 내부 분해,
                      // print("####ProductMessage 10 / message 내부 : " +
                      //     key.toString() +
                      //     " / Length : " +
                      //     mesageValues.length.toString() +
                      //     " // M_Key : " +
                      //     mkey.toString() +
                      //     " / idTo : " +
                      //     mesageValues['idTo'].toString());

                      mesageInValues =
                          mesageValues['idTo']; //메세지 수신 유저 정보 map 으로 변경
                      //print("@@@@@@얘 오류 메시지 인 벨류 ??? $mesageInValues");

                      mesageInValues.forEach((mIkey, mIvalue) {
                        //보낸 사람 분해.
                        if (mIvalue == false && mIkey == currentUserModel.uid) {
                          //수신 유저 정보가 나 and 읽음 false 이면
                          len++; //인트형 len 의 사이즈를 증가시킨다.
                          //print("stream values else1 message ForEach: 읽지 않은 메세지 있음. len : $len");
                          //print("@@@@@@ 내가 안읽은 메세지 있음 길이 증가");
                        }

                        //print("stream values else1 message ForEach:  : ${mIkey} // InMessageValue : ${mIvalue}");
                      });
                    }, //메세지 분해 - 한 챗리스트의 메세지 반복 완료
                  ); //메시지 내부 분해 종료
                }
                //print("리얼타임 메세지 처리 - 프로덕트 리스트 1 : $key /// $len /// $values");

                //분해 완료 뒤 chatID, 나한테 수신된 안읽은 메세지의 길이, 채팅방 벨류 정보를 넘겨준다.
                listProductChatCount
                    .add(ProductChatListCount.forMapSnapshot(key, len, values));

                //이를 챗카운트 리스트에 추가한다.
                //print("리얼타임 메세지 처리 반복 진행중 - 프로덕트 리스트");
              }); //채팅방 반복 종료
              //print("리얼타임 메세지 처리 완료 - 프로덕트 리스트");
              //1. 챗 리스트 정렬
              listProductChat
                  .sort((b, a) => a.recentTime.compareTo(b.recentTime));
              ////정렬3. 시간 순 정렬 가능.
              //print("stream values else : 솔트완료");
              //2. 챗 카운트 정렬
              listProductChatCount
                  .sort((b, a) => a.sendTime.compareTo(b.sendTime));
              int sum = 0;
              listProductChatCount.forEach((count) {
                sum += count.chatCount;
              });
              ProductChatListController().setToFirebaseProductChatCount(sum);
              return userExist == true
                  ? Center(
                      child: Container(
                        color: Colors.white,
                        child: CustomScrollView(
                          shrinkWrap: false,
                          // anchor: 0.5,
                          // dragStartBehavior: DragStartBehavior.down,
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  String productsUserId; //장터 상대방 Id
                                  listProductChat[index].chatUsers.user1Uid ==
                                          currentUserModel.uid
                                      ? productsUserId = listProductChat[index]
                                          .chatUsers
                                          .user2Uid
                                      : productsUserId = listProductChat[index]
                                          .chatUsers
                                          .user1Uid;
                                  String chatId = listProductChat[index].chatId;
                                  return Column(
                                    children: [
                                      // Text('.'),
                                      ListTile(
                                        contentPadding: EdgeInsets.fromLTRB(
                                          12,
                                          5,
                                          12,
                                          5,
                                        ),
                                        // tileColor: Colors.red,
                                        onLongPress: () {
                                          Fluttertoast.showToast(msg: "꾹");
                                        },
                                        // selected: true,
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: ProductChatListController()
                                              .getUserImage(
                                                  chatId, productsUserId),
                                        ),
                                        // borderRadius: Bo
                                        title: Container(
                                          // color: Colors.blue,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                ProductChatListController()
                                                    .getProductUserNickName(
                                                  chatId,
                                                  productsUserId,
                                                  14,
                                                ),
                                                SizedBox(
                                                    width: 10.h, height: 10.h),
                                                Spacer(),
                                                getChatListTime(
                                                    listProductChat[index]
                                                        .recentTime),
                                              ],
                                            ),
                                          ),
                                        ),
                                        subtitle: Center(
                                          child: Container(
                                            // color: Colors.blue,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 3,
                                                  ),
                                                  child: Container(
                                                    // color: Colors.pink,
                                                    width: 220.h,
                                                    height: 30.h,
                                                    child: Text(
                                                      listProductChat[index]
                                                          .recentText,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: 10.h, height: 10.h),
                                                Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 0,
                                                  ),
                                                  child: chatCountBadge(
                                                      listProductChatCount[
                                                              index]
                                                          .chatCount),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // trailing: Padding(
                                        //   padding: const EdgeInsets.fromLTRB(
                                        //       0, 0, 0, 0),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     children: <Widget>[
                                        //       Text("menu"),
                                        //     ],
                                        //   ),
                                        // ),
                                        onTap: () {
                                          ChatNavigationManager
                                              .navigateToProductChattingRoom(
                                            context,
                                            listProductChat[index]
                                                .chatUsers
                                                .user1Uid,
                                            listProductChat[index]
                                                .chatUsers
                                                .user2Uid,
                                            listProductChat[index].postId,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                                childCount: listProductChat.length,
                              ),
                            ),
                          ],
                          // ),
                        ),
                      ),
                    )
                  : Container(
                      width: 30.h,
                      height: 30.h,
                      color: Colors.blue,
                      // child: Center(
                      child: Text("생성된 채팅방이 없습니다. . !"),
                      // ),
                    );
            }
        }
      },
      // ),
    );
  }
}
