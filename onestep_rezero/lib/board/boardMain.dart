import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
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
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "게시판",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(164, 227, 210, 1),
        ),
        body: Stack(
          children: [
            Container(
              height: mintColorContainerHeight,
              decoration: BoxDecoration(
                  color: pColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
            ),
            Column(
              children: [
                SizedBox(
                  height: mintColorContainerHeight / 4,
                ),
                // Container(
                //     padding: EdgeInsets.only(left: 10),
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "게시판 검색",
                //       style: TextStyle(
                //           fontFamily: 'GamjaFlower',
                //           fontWeight: FontWeight.bold,
                //           fontSize: 19),
                //     )),
                Container(
                  padding: EdgeInsets.only(
                      left: deviceWidth / 5, right: deviceWidth / 5, top: 10),
                  height: mintColorContainerHeight / 1.5,
                  child: TextField(
                    decoration: InputDecoration(
                        fillColor: Colors.tealAccent[100],
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                  ),
                ),
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
                  // child: Text(
                  //   "Categories",
                  //   style: TextStyle(fontSize: 18, fontFamily: 'Ubuntu'),
                  // ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 16, right: 16, bottom: 10, top: deviceHeight / 150),
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
                  // child: Text(
                  //   "게시판",
                  //   style: TextStyle(fontSize: 18),
                  // ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.grey),
                      //     borderRadius: BorderRadius.all(Radius.circular(5))),
                      margin: EdgeInsets.all(deviceWidth / 50),
                      child: BoardListRiverpod()
                      // BoardNameProvider().futureConsumerWidget
                      ),
                )
              ],
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     title: Text("게시판"),
    //   ),
    //   body: SingleChildScrollView(
    //     controller: scrollController,
    //     child: Column(
    //       children: [
    //         Container(
    //           decoration: BoxDecoration(
    //               border: Border.all(color: Colors.grey),
    //               borderRadius: BorderRadius.all(Radius.circular(5))),
    //           margin: EdgeInsets.all(device_width / 50),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               ListTile(
    //                 leading: Icon(
    //                   Icons.library_books_outlined,
    //                   color: Colors.green[100],
    //                 ),
    //                 title: Text("나의 글"),
    //               ),
    //               ListTile(
    //                 leading: Icon(
    //                   Icons.mode_comment_rounded,
    //                   color: Colors.green[100],
    //                 ),
    //                 title: Text("나의 댓글"),
    //               ),
    //               ListTile(
    //                 leading: Icon(
    //                   Icons.book_rounded,
    //                   color: Colors.yellow[600],
    //                 ),
    //                 title: Text("나의 스크랩"),
    //               ),
    //               ListTile(
    //                 leading: Icon(
    //                   Icons.favorite,
    //                   color: Colors.redAccent[100],
    //                 ),
    //                 title: Text("인기글"),
    //               ),
    //               ListTile(
    //                 leading: Container(
    //                     child: Stack(children: [
    //                   Container(
    //                       child: Transform(
    //                           alignment: Alignment.center,
    //                           transform: Matrix4.rotationY(math.pi),
    //                           child: Icon(
    //                             Icons.mode_comment,
    //                             color: Colors.red[100],
    //                           ))),
    //                   Container(
    //                       margin: EdgeInsets.all(3),
    //                       child: Icon(
    //                         Icons.mode_comment,
    //                         color: Colors.blue[100],
    //                       )),
    //                   Container(
    //                       margin: EdgeInsets.all(6),
    //                       child: Transform(
    //                           alignment: Alignment.center,
    //                           transform: Matrix4.rotationY(math.pi),
    //                           child: Icon(Icons.mode_comment,
    //                               color: Colors.red[100]))),
    //                   Container(
    //                       margin: EdgeInsets.all(9),
    //                       child: Icon(Icons.mode_comment,
    //                           color: Colors.blue[100])),
    //                 ])),
    //                 title: Text(
    //                   "콜로세움",
    //                 ),
    //               ),
    //               Container(
    //                 decoration: BoxDecoration(
    //                     border: Border(
    //                         top: BorderSide(
    //                   color: Colors.grey,
    //                   width: 1,
    //                 ))),
    //                 child: ListTile(
    //                   leading: Container(
    //                       child: Stack(
    //                     children: [
    //                       Container(
    //                         margin: EdgeInsets.only(top: 5),
    //                         child: Icon(
    //                           Icons.shopping_cart,
    //                           color: Colors.red[200],
    //                         ),
    //                       ),
    //                       Container(
    //                         margin: EdgeInsets.only(left: 5),
    //                         child: Transform.rotate(
    //                           angle: math.pi / 4,
    //                           child: Icon(
    //                             Icons.card_giftcard,
    //                             color: Colors.red[200],
    //                             size: 15,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   )),
    //                   title: Text("공동 구매"),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         GestureDetector(
    //           onTap: () {},
    //           child: Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(color: Colors.grey),
    //                   borderRadius: BorderRadius.all(Radius.circular(5))),
    //               margin: EdgeInsets.all(device_width / 50),
    //               child: BoardListRiverpod()
    //               // BoardNameProvider().futureConsumerWidget
    //               ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
