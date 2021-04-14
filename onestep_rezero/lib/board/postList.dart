import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'declareData/postData.dart';

import 'StateManage/Provider/postListProvider.dart';

final postListProvider =
    ChangeNotifierProvider<PostListProvider>((ref) => PostListProvider());
final FETCH_ROW = 15;

class CategoryException implements Exception {
  String cause;
  CategoryException(this.cause) {
    print(cause);
  }
}

class PostListRiverpod extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final postlistProvider = watch(postListProvider).boards;
    return PostListWidget(postList: postlistProvider);
  }
}

class PostListWidget extends StatelessWidget {
  final List postList;
  const PostListWidget({Key key, this.postList}) : super(key: key);

  @override
  Widget build(BuildContext context) {}
}

// class PostList extends ConsumerWidget {
//   final boardCategory;
//   PostList({this.boardCategory});
//   ScrollController _scrollController =
//       new ScrollController(keepScrollOffset: true);
//   var _lastRow = 0;
//   void initialization() {}

//   @override
//   Widget build(BuildContext context, watch) {
//     print("boardCategory " + boardCategory.toString());
//     //Provider
//     final postList = watch(postListProvider);
//     postList.fetchNextProducts(boardCategory);
//     //set Infinite Scroll
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         postList.fetchNextProducts(boardCategory);
//       }
//     });
//     // postList.getBoard(boardCategory);
//     Widget scaffoldBody;
//     if (postList != null) {
//       if (postList.boards.isNotEmpty) {
//         scaffoldBody = Container(
//             child: ListView.builder(
//                 controller: _scrollController,
//                 //PageStorageKey is Keepping ListView scroll position when switching pageview
//                 key: PageStorageKey<String>("value"),
//                 //Bottom Padding
//                 padding: const EdgeInsets.only(
//                     bottom: kFloatingActionButtonMargin + 60),
//                 itemCount: postList.boards.length,
//                 itemBuilder: (context, index) {
//                   final currentRow = (index + 1) ~/ FETCH_ROW;
//                   if (_lastRow != currentRow) {
//                     _lastRow = currentRow;
//                   }
//                   return _buildListCard(context, index, postList.boards[index]);
//                 }));
//       } else
//         scaffoldBody = Center(child: Text("새 게시글로 시작해보세요!"));
//     } else {
//       scaffoldBody = Center(child: Text(PostListProvider().errorMessage));
//     }
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(50.0),
//         child: AppBar(
//           backgroundColor: Colors.white,
//         ),
//       ),
//       body: scaffoldBody,
//     );
//   }

//   Widget _buildListCard(BuildContext context, int index, var boardData) {
//     return Card(
//       child: Padding(
//           padding: const EdgeInsets.all(1.0),
//           //Click Animation
//           child: InkWell(
//               // Set Click Color
//               splashColor: Colors.grey,
//               //Click Event
//               onTap: () {
//                 Navigator.of(context).pushNamed('/BoardContent',
//                     arguments: {"BOARD_DATA": boardData});
//               },
//               child: Column(
//                 children: <Widget>[
//                   firstColumnLine(boardData),
//                   secondColumnLine(boardData),
//                   thirdColumnLine(boardData)

//                   // Container:() => show_icon_favorite(a);

//                   // Expanded(child: Text('dd')),
//                   // Expanded(
//                   //   child: Text('data'),
//                   // )
//                 ],
//               ))),
//     );
//   }

//   firstColumnLine(var boardData) {
//     return Container(
//         child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         //Title Container
//         titleContainerMethod(title: boardData.title ?? ""),
//         // _commentCountMethod(index)
//       ],
//     ));
//   }

//   secondColumnLine(var boardData) {
//     String _checkCate = boardData.contentCategory.split('.')[1];
//     String category;
//     if (_checkCate == ContentCategory.QUESTION.toString().split('.')[1]) {
//       category = ContentCategory.QUESTION.category;
//     } else if (_checkCate ==
//         ContentCategory.SMALLTALK.toString().split('.')[1]) {
//       category = ContentCategory.SMALLTALK.category;
//     }
//     // else if (kReleaseMode) {
//     //   throw new CategoryException(
//     //       "Does not match category. Please Update Enum in parentSate.dart Or If statement in boardListView.dart secondColumnLine");
//     // }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.only(left: 5.0),
//         ),
//         Container(
//             decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.all(Radius.circular(3.0))),
//             child: Text(
//               category ?? "",
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//             )),
//         Container(
//           height: 20,
//           alignment: Alignment.centerLeft,
//           child: Container(
//               margin: const EdgeInsets.only(left: 5),
//               width: 300,
//               child: Text(boardData.textContent ?? "",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: Colors.black, fontSize: 13))),
//         ),
//       ],
//     );
//   }

//   thirdColumnLine(var boardData) {
//     return Container(
//         child: Row(children: <Widget>[
//       Expanded(
//           child: Row(
//         children: <Widget>[
//           IconTheme(
//               child: Icon(Icons.favorite, size: 14),
//               data: new IconThemeData(color: Colors.red)),
//           // Icon(Icons.favorite),
//           Container(
//             padding: EdgeInsets.only(left: 3),
//             child: Text(
//               boardData.favoriteCount.toString(),
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           Text(
//             ' | ',
//             style: TextStyle(
//                 color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           Container(
//             child: _setDateTimeText(boardData.createDate, boardData),
//           ),
//           Spacer(),
//           Container(
//               child: Icon(
//             Icons.remove_red_eye,
//             color: Colors.grey,
//             size: 14,
//           )),
//           Container(
//             padding: EdgeInsets.only(left: 3),
//             margin: EdgeInsets.only(right: 3),
//             child: Text(boardData.watchCount.toString()),
//           )
//         ],
//         // Icon(Icons.favorite), child: Text('Date')
//       )),
//     ]));
//   }

//   _setDateTimeText(DateTime dateTime, var boardData) {
//     String resultText;
//     DateTime today = DateTime.now();
//     today =
//         DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//     DateTime setUTC9 = dateTime;
//     var _dateDifference = DateTime(setUTC9.year, setUTC9.month, setUTC9.day)
//         .difference(today)
//         .inDays;
//     if (_dateDifference == 0 || _dateDifference == -1) {
//       var _date = setUTC9.toString().split(' ')[1].split('.')[0];
//       if (_dateDifference == 0) {
//         resultText = "오늘 " + _date;
//       } else {
//         resultText = "어제 " + _date;
//       }
//     } else {
//       var _date = dateTime.toString().split('');
//       int _dateLength = dateTime.toString().split('').length;
//       _date.removeRange(_dateLength - 10, _dateLength);
//       resultText = _date.join();
//     }

//     return Text(resultText);
//   }

//   @override
//   Widget titleContainerMethod({@required String title}) {
//     return Container(
//         margin: const EdgeInsets.only(left: 5),
//         width: 300,
//         child: Text(
//           title,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
//         ));
//   }
// }

// // class PostList extends StatefulWidget {
// //   final boardCategory;
// //   PostList({
// //     Key key,
// //     this.boardCategory,
// //   }) : super(key: key);
// //   @override
// //   _PostListState createState() => _PostListState();
// // }

// // class _PostListState extends _PostListParentState<PostList> {
// //   @override
// //   setBoardCategory() => boardCategory = widget.boardCategory;

// //   // @override
// //   // setProvider() => provider =postListProvider;
// // }

// // class _BoardListState extends _BoardListParentState<BoardList> {
// //   @override
// //   setProvider() => boardProvider = widget.boardProvider;

// //   @override
// //   setBoardCategory() => boardCategory = widget.boardCategory;
// // }

// abstract class _PostListParentState<T extends StatefulWidget> extends State<T> {
//   // setProvider();
//   setBoardCategory();
//   Function fabCallback;
//   String boardCategory;
//   ScrollController _scrollController;
//   bool isScrollDirectionUp;
//   var _lastRow = 0;
//   final FETCH_ROW = 8;
//   var stream;
//   @override
//   void initState() {
//     super.initState();
//     //Floating Action Button hide and show
//     //Set Provider child class
//     // setProvider();
//     //Set board Category in child class
//     setBoardCategory();
//     // Consumer(
//     //   builder: (context, watch, child) {
//     //     final test = watch(postListProvider);
//     //     test.fetchNextProducts(boardCategory);
//     //     isScrollDirectionUp = true;
//     //     _scrollController = new ScrollController(keepScrollOffset: true);
//     //     _scrollController.addListener(() {
//     //       print("set new Stream");
//     //       if (_scrollController.position.pixels ==
//     //           _scrollController.position.maxScrollExtent) {
//     //         test.fetchNextProducts(boardCategory);
//     //       }

//     //       if (_scrollController.position.userScrollDirection ==
//     //           ScrollDirection.forward) {
//     //         if (isScrollDirectionUp == true) {
//     //           print(isScrollDirectionUp.toString() + "forward");
//     //           // isScrollDirectionUp = false;
//     //           fabCallback(!isScrollDirectionUp);
//     //         }
//     //       } else {
//     //         if (_scrollController.position.userScrollDirection ==
//     //             ScrollDirection.reverse) {
//     //           if (isScrollDirectionUp == false) {
//     //             print(isScrollDirectionUp.toString() + "reverse");
//     //             // isScrollDirectionUp = true;
//     //             fabCallback(!isScrollDirectionUp);
//     //           }
//     //         }
//     //       }
//     //     });

//     //   },
//     // );

//     // postListProvider.fetchNextProducts(boardCategory);
//     // isScrollDirectionUp = true;
//     // _scrollController = new ScrollController(keepScrollOffset: true);
//     // _scrollController.addListener(() {
//     //   print("set new Stream");
//     //   if (_scrollController.position.pixels ==
//     //       _scrollController.position.maxScrollExtent) {
//     //     postListProvider.fetchNextProducts(boardCategory);
//     //   }

//     //   if (_scrollController.position.userScrollDirection ==
//     //       ScrollDirection.forward) {
//     //     if (isScrollDirectionUp == true) {
//     //       print(isScrollDirectionUp.toString() + "forward");
//     //       // isScrollDirectionUp = false;
//     //       fabCallback(!isScrollDirectionUp);
//     //     }
//     //   } else {
//     //     if (_scrollController.position.userScrollDirection ==
//     //         ScrollDirection.reverse) {
//     //       if (isScrollDirectionUp == false) {
//     //         print(isScrollDirectionUp.toString() + "reverse");
//     //         // isScrollDirectionUp = true;
//     //         fabCallback(!isScrollDirectionUp);
//     //       }
//     //     }
//     //   }
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
//   //  @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     body: BoardList(
//   //       callback: listViewFABCallback,
//   //       boardProvider: widget.boardProvider,
//   //     ),
//   //     appBar: PreferredSize(
//   //       preferredSize: Size.fromHeight(50.0),
//   //       child: AppBar(
//   //         backgroundColor: Colors.white,
//   //       ),
//   //     ),
//   //     floatingActionButton: _hideFAB
//   //         ? Container()
//   //         : FloatingActionButton(
//   //             backgroundColor: Colors.black,
//   //             onPressed: () {
//   //               print(_boardCategory.categoryEN);
//   //               Navigator.of(context).pushNamed('/CreateBoard',
//   //                   arguments: {"CURRENTBOARD": BoardCategory.Free});
//   //             },
//   //             child: Icon(Icons.add)),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // Widget scaffoldBody;
//     // if (postListProvider != null) {
//     //   if (postListProvider.boards.isNotEmpty) {
//     //     scaffoldBody = Container(
//     //         child: ListView.builder(
//     //             controller: _scrollController,
//     //             //PageStorageKey is Keepping ListView scroll position when switching pageview
//     //             key: PageStorageKey<String>("value"),
//     //             //Bottom Padding
//     //             padding: const EdgeInsets.only(
//     //                 bottom: kFloatingActionButtonMargin + 60),
//     //             itemCount: postListProvider.boards.length,
//     //             itemBuilder: (context, index) {
//     //               final currentRow = (index + 1) ~/ FETCH_ROW;
//     //               if (_lastRow != currentRow) {
//     //                 _lastRow = currentRow;
//     //               }
//     //               return _buildListCard(
//     //                   context, index, postListProvider.boards[index]);
//     //             }));
//     //   } else
//     //     scaffoldBody = Center(child: Text("새 게시글로 시작해보세요!"));
//     // } else {
//     //   scaffoldBody = Center(child: Text(PostListProvider().errorMessage));
//     // }
//     // ----
//     // return Scaffold(
//     //     appBar: PreferredSize(
//     //       preferredSize: Size.fromHeight(50.0),
//     //       child: AppBar(
//     //         backgroundColor: Colors.white,
//     //       ),
//     //     ),
//     //     // body: scaffoldBody,
//     //     body: Consumer(builder: (context, watch, child) {
//     //       final postProvider = watch(postListProvider);
//     //       if (postProvider != null) {
//     //         if (postProvider.boards.isNotEmpty) {
//     //           return Container(
//     //               child: ListView.builder(
//     //                   controller: _scrollController,
//     //                   //PageStorageKey is Keepping ListView scroll position when switching pageview
//     //                   key: PageStorageKey<String>("value"),
//     //                   //Bottom Padding
//     //                   padding: const EdgeInsets.only(
//     //                       bottom: kFloatingActionButtonMargin + 60),
//     //                   itemCount: postProvider.boards.length,
//     //                   itemBuilder: (context, index) {
//     //                     final currentRow = (index + 1) ~/ FETCH_ROW;
//     //                     if (_lastRow != currentRow) {
//     //                       _lastRow = currentRow;
//     //                     }
//     //                     return _buildListCard(
//     //                         context, index, postProvider.boards[index]);
//     //                   }));
//     //         } else {
//     //           return Center(child: Text("새 게시글로 시작해보세요!"));
//     //         }
//     //       } else {
//     //         return Center(child: Text(PostListProvider().errorMessage));
//     //       }
//     //     }));

//     return Scaffold(
//       body: Consumer(
//         builder: (context, watch, child) {
//           final postProvider = watch(postListProvider);

//           // if (postProvider != null) {
//           //   if (postProvider.boards.isEmpty) {
//           //     print("postProvider.boards.length " +
//           //         postProvider.boards.length.toString());
//           //     return Container();
//           // return Container(
//           //     child: ListView.builder(
//           //         controller: _scrollController,
//           //         //PageStorageKey is Keepping ListView scroll position when switching pageview
//           //         key: PageStorageKey<String>("value"),
//           //         //Bottom Padding
//           //         padding: const EdgeInsets.only(
//           //             bottom: kFloatingActionButtonMargin + 60),
//           //         itemCount: postProvider.boards.length,
//           //         itemBuilder: (context, index) {
//           //           final currentRow = (index + 1) ~/ FETCH_ROW;
//           //           if (_lastRow != currentRow) {
//           //             _lastRow = currentRow;
//           //           }
//           //           print("postProvider.boards.length" +
//           //               postProvider.boards.length.toString());
//           //           return _buildListCard(
//           //               context, index, postProvider.boards[index]);
//           //         }));
//           //   } else {
//           //     return Center(child: Text("새 게시글로 시작해보세요!"));
//           //   }
//           // } else {
//           //   return Center(child: Text(PostListProvider1().errorMessage));
//           // }
//         },
//       ),
//     );
//   }

//   Widget _buildListCard(BuildContext context, int index, var boardData) {
//     return Card(
//       child: Padding(
//           padding: const EdgeInsets.all(1.0),
//           //Click Animation
//           child: InkWell(
//               // Set Click Color
//               splashColor: Colors.grey,
//               //Click Event
//               onTap: () {
//                 Navigator.of(context).pushNamed('/BoardContent',
//                     arguments: {"BOARD_DATA": boardData});
//               },
//               child: Column(
//                 children: <Widget>[
//                   firstColumnLine(boardData),
//                   // secondColumnLine(boardData),
//                   thirdColumnLine(boardData)

//                   // Container:() => show_icon_favorite(a);

//                   // Expanded(child: Text('dd')),
//                   // Expanded(
//                   //   child: Text('data'),
//                   // )
//                 ],
//               ))),
//     );
//   }

//   firstColumnLine(var boardData) {
//     return Container(
//         child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         //Title Container
//         titleContainerMethod(title: boardData.title ?? ""),
//         // _commentCountMethod(index)
//       ],
//     ));
//   }

//   // secondColumnLine(var boardData) {
//   //   String _checkCate = boardData.contentCategory.split('.')[1];
//   //   String category;
//   //   if (_checkCate == ContentCategory.QUESTION.toString().split('.')[1]) {
//   //     category = ContentCategory.QUESTION.category;
//   //   } else if (_checkCate ==
//   //       ContentCategory.SMALLTALK.toString().split('.')[1]) {
//   //     category = ContentCategory.SMALLTALK.category;
//   //   } else if (kReleaseMode) {
//   //     throw new CategoryException(
//   //         "Does not match category. Please Update Enum in parentSate.dart Or If statement in boardListView.dart secondColumnLine");
//   //   }
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.start,
//   //     children: [
//   //       Container(
//   //         padding: EdgeInsets.only(left: 5.0),
//   //       ),
//   //       Container(
//   //           decoration: BoxDecoration(
//   //               color: Colors.grey[300],
//   //               borderRadius: BorderRadius.all(Radius.circular(3.0))),
//   //           child: Text(
//   //             category ?? "",
//   //             style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//   //           )),
//   //       Container(
//   //         height: 20,
//   //         alignment: Alignment.centerLeft,
//   //         child: Container(
//   //             margin: const EdgeInsets.only(left: 5),
//   //             width: 300,
//   //             child: Text(boardData.textContent ?? "",
//   //                 maxLines: 1,
//   //                 overflow: TextOverflow.ellipsis,
//   //                 style: TextStyle(color: Colors.black, fontSize: 13))),
//   //       ),
//   //     ],
//   //   );
//   // }

//   thirdColumnLine(var boardData) {
//     return Container(
//         child: Row(children: <Widget>[
//       Expanded(
//           child: Row(
//         children: <Widget>[
//           IconTheme(
//               child: Icon(Icons.favorite, size: 14),
//               data: new IconThemeData(color: Colors.red)),
//           // Icon(Icons.favorite),
//           Container(
//             padding: EdgeInsets.only(left: 3),
//             child: Text(
//               boardData.favoriteCount.toString(),
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           Text(
//             ' | ',
//             style: TextStyle(
//                 color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           Container(
//             child: _setDateTimeText(boardData.createDate, boardData),
//           ),
//           Spacer(),
//           Container(
//               child: Icon(
//             Icons.remove_red_eye,
//             color: Colors.grey,
//             size: 14,
//           )),
//           Container(
//             padding: EdgeInsets.only(left: 3),
//             margin: EdgeInsets.only(right: 3),
//             child: Text(boardData.watchCount.toString()),
//           )
//         ],
//         // Icon(Icons.favorite), child: Text('Date')
//       )),
//     ]));
//   }

//   _setDateTimeText(DateTime dateTime, var boardData) {
//     String resultText;
//     DateTime today = DateTime.now();
//     today =
//         DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//     DateTime setUTC9 = dateTime;
//     var _dateDifference = DateTime(setUTC9.year, setUTC9.month, setUTC9.day)
//         .difference(today)
//         .inDays;
//     if (_dateDifference == 0 || _dateDifference == -1) {
//       var _date = setUTC9.toString().split(' ')[1].split('.')[0];
//       if (_dateDifference == 0) {
//         resultText = "오늘 " + _date;
//       } else {
//         resultText = "어제 " + _date;
//       }
//     } else {
//       var _date = dateTime.toString().split('');
//       int _dateLength = dateTime.toString().split('').length;
//       _date.removeRange(_dateLength - 10, _dateLength);
//       resultText = _date.join();
//     }

//     return Text(resultText);
//   }

//   @override
//   Widget titleContainerMethod({@required String title}) {
//     return Container(
//         margin: const EdgeInsets.only(left: 5),
//         width: 300,
//         child: Text(
//           title,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
//         ));
//   }

//   // Widget _commentCountMethod(int index) {
//   //   // int _commentCount = boardDataList[index].commentCount;
//   //   Widget _commentCountText;
//   //   BoxDecoration _commentBoxDecoration;
//   //   //Under 30
//   //   if (_commentCount < 30) {
//   //     _commentBoxDecoration =
//   //         new BoxDecoration(shape: BoxShape.circle, color: Colors.yellow);
//   //     _commentCountText = new Text('$_commentCount',
//   //         maxLines: 1,
//   //         style: TextStyle(
//   //             color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold));
//   //     //Up 30 Under 50
//   //   } else if (_commentCount >= 30 && _commentCount < 50) {
//   //     _commentBoxDecoration =
//   //         new BoxDecoration(shape: BoxShape.circle, color: Colors.orange);
//   //     _commentCountText = new Text('$_commentCount',
//   //         maxLines: 1,
//   //         style: TextStyle(
//   //             color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
//   //     //Over 50
//   //   } else {
//   //     _commentBoxDecoration =
//   //         new BoxDecoration(shape: BoxShape.circle, color: Colors.red);
//   //     if (_commentCount <= 100) {
//   //       _commentCountText = new Text('$_commentCount',
//   //           maxLines: 1,
//   //           style: TextStyle(
//   //               color: Colors.white,
//   //               fontSize: 13,
//   //               fontWeight: FontWeight.bold));
//   //     } else {
//   //       _commentCountText = new Text('100+',
//   //           maxLines: 1,
//   //           style: TextStyle(
//   //               color: Colors.white,
//   //               fontSize: 13,
//   //               fontWeight: FontWeight.bold));
//   //     }
//   //   }

//   //   return Container(
//   //       //CommentCount Container
//   //       height: 30,
//   //       width: 30,
//   //       decoration: _commentBoxDecoration,
//   //       child: Center(child: _commentCountText));
//   // }
// }
