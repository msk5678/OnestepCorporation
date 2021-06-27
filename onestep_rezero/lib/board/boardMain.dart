import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/StateManage/Provider/boardCategoryList.dart';

import 'package:onestep_rezero/board/Animation/Rive/AboutBoard/randomList.dart';
import 'package:onestep_rezero/board/StateManage/Provider/userProvider.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';

import "dart:math" as math;

final userBoardDataProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

class BoardMain extends StatefulWidget {
  BoardMain({
    Key key,
  }) : super(key: key);

  @override
  _BoardMainState createState() => _BoardMainState();
}

class _BoardMainState extends State<BoardMain> {
  double deviceWidth;
  double deviceHeight;
  List<BoardInitData> initIconData = [];
  // StreamController<bool> streamControllerIcon1;
  // StreamController<bool> streamControllerIcon2;
  // StreamController<bool> streamControllerIcon3;
  // StreamController<bool> streamControllerIcon4;
  // StreamController<bool> streamControllerIcon5;
  // StreamController<bool> streamControllerIcon6;
  // Timer _updateRandomAnimationInterval;
  // Timer _animationInterval;
  // CreateRandomNumberNotDuplicated randomClass;
  // List<int> randomNuberList = [];
  // int animationPivot;

  @override
  void dispose() {
    // if (_updateRandomAnimationInterval != null)
    //   _updateRandomAnimationInterval.cancel();
    // if (_animationInterval != null) _animationInterval.cancel();
    // streamControllerIcon1.close();
    // streamControllerIcon2.close();
    // streamControllerIcon3.close();
    // streamControllerIcon4.close();
    // streamControllerIcon5.close();
    // streamControllerIcon6.close();
    super.dispose();
  }

  ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    context.read(userBoardDataProvider).getUserData();
    // streamControllerIcon1 = StreamController<bool>();
    // streamControllerIcon2 = StreamController<bool>();
    // streamControllerIcon3 = StreamController<bool>();
    // streamControllerIcon4 = StreamController<bool>();
    // streamControllerIcon5 = StreamController<bool>();
    // streamControllerIcon6 = StreamController<bool>();
    // animationPivot = 0;
    context.read(boardListProvider).fetchBoards();
    setBoardIconData();
    // randomClass = CreateRandomNumberNotDuplicated(length: initIconData.length);

    super.initState();
  }

  manageAnimationTimer(bool isStart) {
    // if (isStart) {
    //   if (_updateRandomAnimationInterval == null)
    //     setRiveAnimationTimer();
    //   else {
    //     if (!_updateRandomAnimationInterval.isActive) setRiveAnimationTimer();
    //   }
    // } else {
    //   if (_updateRandomAnimationInterval !=
    //       null) if (_updateRandomAnimationInterval.isActive) {
    //     _updateRandomAnimationInterval.cancel();
    //     // if (_animationInterval != null) if (_animationInterval.isActive)
    //     _animationInterval.cancel();
    //     randomNuberList = [];
    //     animationPivot = 0;
    //   }
    // }
  }

  // setRiveAnimationTimer() {
  //   //Each Animation Interval 3 seconds(Animation 1 second and 2second  waiting next animation ) * 6 Icons

  //   _updateRandomAnimationInterval =
  //       Timer.periodic(Duration(seconds: 17), (timer) {
  //     if (currentBottomNaviIndex == 2) {
  //       randomNuberList = [];
  //       animationPivot = 0;
  //       randomClass =
  //           CreateRandomNumberNotDuplicated(length: initIconData.length);
  //       randomNuberList = randomClass.getRandomNumberList;
  //     }
  //   });
  //   _animationInterval = Timer.periodic((Duration(seconds: 3)), (timer) {
  //     if (currentBottomNaviIndex == 2) startAnimation();
  //   });
  // }

  // startAnimation() {
  //   print("Timer Live");
  //   if (randomNuberList.isNotEmpty) {
  //     if (randomNuberList.length != 0) {
  //       int animationNumber = randomNuberList[animationPivot++];

  //       if (animationNumber == 0)
  //         streamControllerIcon1.add(true);
  //       else if (animationNumber == 1)
  //         streamControllerIcon2.add(true);
  //       else if (animationNumber == 2)
  //         streamControllerIcon3.add(true);
  //       else if (animationNumber == 3)
  //         streamControllerIcon4.add(true);
  //       else if (animationNumber == 4)
  //         streamControllerIcon5.add(true);
  //       else if (animationNumber == 5)
  //         streamControllerIcon6.add(true);
  //       else {
  //         return null;
  //       }
  //     }
  //   }
  // }

  // setBoardIconData() {
  //   initIconData = [
  //     BoardInitData(
  //         icons: MyBoardCategoryIcon(
  //           riveFileData: RiveFileData(
  //               riveFile: 'rives/20210601.riv',
  //               riveStateMachine: "StateMachine"),
  //           stream: streamControllerIcon1.stream,
  //         ),
  //         explain: "나의 글"),
  //     BoardInitData(
  //         icons: MyBoardCategoryIcon(
  //           height: 50,
  //           width: 50,
  //           riveFileData: RiveFileData(
  //               riveFile: 'rives/20210601.riv',
  //               riveStateMachine: "StateMachine"),
  //           stream: streamControllerIcon2.stream,
  //         ),
  //         explain: "나의 댓글"),
  //     BoardInitData(
  //         // icons: Icon(
  //         //   Icons.book_rounded,
  //         //   size: 30,
  //         //   color: Colors.yellow[600],
  //         // ),
  //         icons: MyBoardCategoryIcon(
  //           riveFileData: RiveFileData(
  //               riveFile: 'rives/20210601.riv',
  //               riveStateMachine: "StateMachine"),
  //           stream: streamControllerIcon3.stream,
  //         ),
  //         explain: "나의 스크랩"),
  //     BoardInitData(
  //         // icons: Icon(
  //         //   Icons.favorite,
  //         //   size: 30,
  //         //   color: Colors.redAccent[100],
  //         // ),
  //         icons: MyBoardCategoryIcon(
  //           riveFileData: RiveFileData(
  //               riveFile: 'rives/new_file.riv',
  //               riveStateMachine: "StateMachine"),
  //           stream: streamControllerIcon4.stream,
  //         ),
  //         explain: "인기글"),
  //     BoardInitData(
  //         icons: MyBoardCategoryIcon(
  //           riveFileData: RiveFileData(
  //               riveFile: 'rives/new_file.riv',
  //               riveStateMachine: "StateMachine"),
  //           stream: streamControllerIcon5.stream,
  //         ),
  //         // icons:
  //         //  Container(
  //         //     child: Stack(children: [
  //         //   Container(
  //         //       child: Transform(
  //         //           alignment: Alignment.center,
  //         //           transform: Matrix4.rotationY(math.pi),
  //         //           child: Icon(
  //         //             Icons.mode_comment,
  //         //             color: Colors.red[100],
  //         //           )
  //         //           )),
  //         //   Container(
  //         //       margin: EdgeInsets.all(3),
  //         //       child: Icon(
  //         //         Icons.mode_comment,
  //         //         color: Colors.blue[100],
  //         //       )),
  //         //   Container(
  //         //       margin: EdgeInsets.all(6),
  //         //       child: Transform(
  //         //           alignment: Alignment.center,
  //         //           transform: Matrix4.rotationY(math.pi),
  //         //           child: Icon(Icons.mode_comment, color: Colors.red[100]))),
  //         //   Container(
  //         //       margin: EdgeInsets.only(left: 9, right: 9, top: 9),
  //         //       child: Icon(Icons.mode_comment, color: Colors.blue[100])),
  //         // ])
  //         // ),
  //         explain: "댓글 수"),
  //     BoardInitData(
  //         icons: MyBoardCategoryIcon(
  //           riveFileData: RiveFileData(
  //               riveFile: 'rives/new_file.riv',
  //               riveStateMachine: "StateMachine"),
  //           stream: streamControllerIcon6.stream,
  //         ),
  //         // icons: Container(
  //         //     child: Stack(
  //         //   children: [
  //         //     Container(
  //         //       margin: EdgeInsets.only(top: 5),
  //         //       child: Icon(
  //         //         Icons.shopping_cart,
  //         //         size: 30,
  //         //         color: Colors.red[200],
  //         //       ),
  //         //     ),
  //         //     Container(
  //         //       margin: EdgeInsets.only(left: 6),
  //         //       child: Transform.rotate(
  //         //         angle: math.pi / 4,
  //         //         child: Icon(
  //         //           Icons.card_giftcard,
  //         //           size: 20,
  //         //           color: Colors.red[200],
  //         //         ),
  //         //       ),
  //         //     ),
  //         //   ],
  //         // )
  //         // ),
  //         explain: "공동구매"),
  //   ];
  // }

  setBoardIconData() {
    initIconData = [
      BoardInitData(
          icons: Icon(
            Icons.article_outlined,
            size: 30,
            color: OnestepColors().mainColor,
          ),
          explain: "나의 글"),
      BoardInitData(
          icons: Icon(
            Icons.insert_comment_outlined,
            size: 30,
            color: OnestepColors().mainColor,
          ),
          explain: "나의 댓글"),
      BoardInitData(
          icons: Icon(
            Icons.favorite,
            size: 30,
            color: OnestepColors().mainColor,
          ),
          explain: "나의 좋아요"),
      BoardInitData(
          icons: Icon(
            Icons.favorite,
            size: 30,
            color: Colors.redAccent[100],
          ),
          explain: "인기글"),
      BoardInitData(
          icons: Container(
              child: Stack(children: [
            Container(
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(
                      Icons.mode_comment,
                      color: Colors.red[100],
                    ))),
            Container(
                margin: EdgeInsets.all(3),
                child: Icon(
                  Icons.mode_comment,
                  color: Colors.blue[100],
                )),
            Container(
                margin: EdgeInsets.all(6),
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Icons.mode_comment, color: Colors.red[100]))),
            Container(
                margin: EdgeInsets.only(left: 9, right: 9, top: 9),
                child: Icon(Icons.mode_comment, color: Colors.blue[100])),
          ])),
          explain: "댓글 수"),
      BoardInitData(
          icons: Container(
              child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.shopping_cart,
                  size: 30,
                  color: Colors.red[200],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 6),
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Icon(
                    Icons.card_giftcard,
                    size: 20,
                    color: Colors.red[200],
                  ),
                ),
              ),
            ],
          )),
          explain: "공동구매"),
    ];
  }

  @override
  void didChangeDependencies() {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // int bottomNaviIndex = currentBottomNaviIndex ?? 0;
    // manageAnimationTimer(bottomNaviIndex == 2);
    double mintColorContainerHeight = deviceHeight / 10;
    // Color pColor = Color.fromRGBO(164, 227, 210, 1);
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mintColorContainerHeight -
                  (mintColorContainerHeight / 2 + mintColorContainerHeight / 4),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 20,
              ),
              alignment: Alignment.centerLeft,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: deviceWidth / 10,
                  right: deviceWidth / 10,
                  bottom: 10,
                  top: deviceHeight / 150),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: 0.1,
                mainAxisSpacing: 0.1,
                crossAxisCount: 3,
                childAspectRatio: 1,
                children: List.generate(initIconData.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      String pageName = "";
                      Map<String, dynamic> arg = {
                        "DASHBOARDDATA": initIconData[index]
                      };
                      if (index == 0) {
                        pageName = "/UserPostingList";
                      } else if (index == 1) {
                        pageName = "/UserWrittenCommentList";
                      } else if (index == 2) {
                        pageName = "/UserFavoriteList";
                      } else if (index == 3) {
                        pageName = "/TopFavoritePostList";
                      } else if (index == 4) {
                        pageName = "/TopCommentPostList";
                      }
                      if (pageName != "")
                        Navigator.pushNamed(context, pageName, arguments: arg);
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: initIconData[index].icons,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                "${initIconData[index].explain}",
                              ),
                            )
                          ]),
                    ),
                  );
                }),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                  margin: EdgeInsets.all(deviceWidth / 50),
                  child: BoardListRiverpod(
                    animationStopCallback: manageAnimationTimer,
                  )
                  // BoardNameProvider().futureConsumerWidget
                  ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(
        '게시판',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: <Widget>[
        new IconButton(
          icon: new Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
