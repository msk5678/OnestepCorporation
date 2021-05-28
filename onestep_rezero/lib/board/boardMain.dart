import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/board/Animation/Rive/boardMyPostIcon.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';
import 'boardCategoryList.dart';

class BoardMain extends StatefulWidget {
  BoardMain({
    Key key,
  }) : super(key: key);

  @override
  _BoardMainState createState() => _BoardMainState();
}

class _BoardMainState extends State<BoardMain> {
  List<BoardInitData> initItems = [];
  double deviceWidth;
  double deviceHeight;
  var temp = MyBoardCategoryIcon(
    riveFile: RiveFileData(
        riveFile: 'rives/myPost.riv', riveAnimation: "StateMachine"),
  );

  ScrollController scrollController = new ScrollController();
  @override
  void initState() {
    context.read(boardListProvider).fetchBoards();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<BoardInitData> initialItems = [
      BoardInitData(
          icons: Icon(
            Icons.library_books_outlined,
            size: 30,
            color: Colors.green[100],
          ),
          explain: "나의 글"),
      BoardInitData(
          icons: Icon(
            Icons.mode_comment_rounded,
            size: 30,
            color: Colors.green[100],
          ),
          explain: "나의 댓글"),
      BoardInitData(
          icons: Icon(
            Icons.book_rounded,
            size: 30,
            color: Colors.yellow[600],
          ),
          explain: "나의 스크랩"),
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
                  children: List.generate(initialItems.length, (index) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            initialItems[index].icons,
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                "${initialItems[index].explain}",
                              ),
                            )
                          ],
                        ),
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
              Container(child: temp),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      temp = MyBoardCategoryIcon(
                        riveFile: RiveFileData(
                            riveFile: 'rives/myPost.riv',
                            riveAnimation: "StateMachine"),
                      );
                    });
                  },
                  child: Text("DONE"))
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
        // new IconButton(
        //   icon: new Icon(
        //     Icons.refresh,
        //     color: Colors.black,
        //   ),
        //   onPressed: () => {
        //     // setState(() {
        //     _scrollController.position
        //         .moveTo(0.5, duration: Duration(milliseconds: 500)),
        //     context.read(productMainService).fetchProducts(),
        //     // })
        //   },
        // ),
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
