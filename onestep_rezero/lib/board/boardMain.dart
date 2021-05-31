import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/board/AboutBoard/boardCategoryList.dart';
import 'package:onestep_rezero/board/Animation/Rive/boardMyPostIcon.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';

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
  StreamController<bool> streamControllerIcon1;
  StreamController<bool> streamControllerIcon2;
  StreamController<bool> streamControllerIcon3;
  StreamController<bool> streamControllerIcon4;
  StreamController<bool> streamControllerIcon5;
  StreamController<bool> streamControllerIcon6;

  @override
  void dispose() {
    streamControllerIcon1.close();
    streamControllerIcon2.close();
    streamControllerIcon3.close();
    streamControllerIcon4.close();
    streamControllerIcon5.close();
    streamControllerIcon6.close();
    super.dispose();
  }

  ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    streamControllerIcon1 = StreamController<bool>();
    streamControllerIcon2 = StreamController<bool>();
    streamControllerIcon3 = StreamController<bool>();
    streamControllerIcon4 = StreamController<bool>();
    streamControllerIcon5 = StreamController<bool>();
    streamControllerIcon6 = StreamController<bool>();

    context.read(boardListProvider).fetchBoards();
    super.initState();
    initIconData = [
      BoardInitData(
          icons: MyBoardCategoryIcon(
            riveFileData: RiveFileData(
                riveFile: 'rives/new_file.riv',
                riveStateMachine: "StateMachine"),
            stream: streamControllerIcon1.stream,
          ),
          explain: "나의 글"),
      BoardInitData(
          icons: MyBoardCategoryIcon(
            height: 50,
            width: 50,
            riveFileData: RiveFileData(
                riveFile: 'rives/new_file.riv',
                riveStateMachine: "StateMachine"),
            stream: streamControllerIcon2.stream,
          ),
          explain: "나의 댓글"),
      BoardInitData(
          // icons: Icon(
          //   Icons.book_rounded,
          //   size: 30,
          //   color: Colors.yellow[600],
          // ),
          icons: MyBoardCategoryIcon(
            riveFileData: RiveFileData(
                riveFile: 'rives/new_file.riv',
                riveStateMachine: "StateMachine"),
            stream: streamControllerIcon3.stream,
          ),
          explain: "나의 스크랩"),
      BoardInitData(
          // icons: Icon(
          //   Icons.favorite,
          //   size: 30,
          //   color: Colors.redAccent[100],
          // ),
          icons: MyBoardCategoryIcon(
            riveFileData: RiveFileData(
                riveFile: 'rives/new_file.riv',
                riveStateMachine: "StateMachine"),
            stream: streamControllerIcon4.stream,
          ),
          explain: "인기글"),
      BoardInitData(
          icons: MyBoardCategoryIcon(
            riveFileData: RiveFileData(
                riveFile: 'rives/new_file.riv',
                riveStateMachine: "StateMachine"),
            stream: streamControllerIcon5.stream,
          ),
          // icons:
          //  Container(
          //     child: Stack(children: [
          //   Container(
          //       child: Transform(
          //           alignment: Alignment.center,
          //           transform: Matrix4.rotationY(math.pi),
          //           child: Icon(
          //             Icons.mode_comment,
          //             color: Colors.red[100],
          //           )
          //           )),
          //   Container(
          //       margin: EdgeInsets.all(3),
          //       child: Icon(
          //         Icons.mode_comment,
          //         color: Colors.blue[100],
          //       )),
          //   Container(
          //       margin: EdgeInsets.all(6),
          //       child: Transform(
          //           alignment: Alignment.center,
          //           transform: Matrix4.rotationY(math.pi),
          //           child: Icon(Icons.mode_comment, color: Colors.red[100]))),
          //   Container(
          //       margin: EdgeInsets.only(left: 9, right: 9, top: 9),
          //       child: Icon(Icons.mode_comment, color: Colors.blue[100])),
          // ])
          // ),
          explain: "댓글 수"),
      BoardInitData(
          icons: MyBoardCategoryIcon(
            riveFileData: RiveFileData(
                riveFile: 'rives/new_file.riv',
                riveStateMachine: "StateMachine"),
            stream: streamControllerIcon6.stream,
          ),
          // icons: Container(
          //     child: Stack(
          //   children: [
          //     Container(
          //       margin: EdgeInsets.only(top: 5),
          //       child: Icon(
          //         Icons.shopping_cart,
          //         size: 30,
          //         color: Colors.red[200],
          //       ),
          //     ),
          //     Container(
          //       margin: EdgeInsets.only(left: 6),
          //       child: Transform.rotate(
          //         angle: math.pi / 4,
          //         child: Icon(
          //           Icons.card_giftcard,
          //           size: 20,
          //           color: Colors.red[200],
          //         ),
          //       ),
          //     ),
          //   ],
          // )
          // ),
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
    double mintColorContainerHeight = deviceHeight / 10;
    Color pColor = Color.fromRGBO(164, 227, 210, 1);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: appBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: mintColorContainerHeight -
                    (mintColorContainerHeight / 2 +
                        mintColorContainerHeight / 4),
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
                  shrinkWrap: true,
                  crossAxisSpacing: 0.1,
                  mainAxisSpacing: 0.1,
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  children: List.generate(initIconData.length, (index) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: initIconData[index].icons,
                        // Container(
                        //   padding: EdgeInsets.only(top: 5),
                        //   child: Text(
                        //     "${initIconData[index].explain}",
                        //   ),
                        // )
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
                    child: BoardListRiverpod()
                    // BoardNameProvider().futureConsumerWidget
                    ),
              ),
              ElevatedButton(
                  onPressed: () {
                    streamControllerIcon1.add(true);
                  },
                  child: Text("1")),
              ElevatedButton(
                  onPressed: () {
                    streamControllerIcon2.add(true);
                  },
                  child: Text("2")),
              ElevatedButton(
                  onPressed: () {
                    streamControllerIcon3.add(true);
                  },
                  child: Text("3")),
              ElevatedButton(
                  onPressed: () {
                    streamControllerIcon4.add(true);
                  },
                  child: Text("4")),
            ],
          ),
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
          onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SearchAllMain(searchKey: 1)),
            ),
          },
        ),
      ],
    );
  }
}
