import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/StateManage/Provider/boardListProvider.dart';

// final futureBoardProvider = FutureProvider<Map<String, String>>((ref) async {
//   Map<String, String> boardList = {};
//   QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection("Board").get();
//   querySnapshot.docs.forEach((element) {
//     boardList.addAll({element.id: element.data()["boardName"]});
//   });
//   return boardList;
// });

final boardListProvider =
    ChangeNotifierProvider<BoardListProvider>((ref) => BoardListProvider());

class BoardListRiverpod extends ConsumerWidget {
  BoardListRiverpod();
  @override
  Widget build(BuildContext context, watch) {
    final boardlistProvider = watch(boardListProvider).boards;
    return BoardListView(
      boardList: boardlistProvider,
    );
  }
}

class BoardListView extends ConsumerWidget {
  final List boardList;
  BoardListView({this.boardList});

  // Widget get futureConsumerWidget => Consumer(
  //       builder: (context, watch, child) {
  //         final future = watch(futureBoardProvider);
  //         return future.when(
  //             data: (value) {
  //               List<Widget> categoryListWidget = [];
  //               value.forEach((id, boardName) {
  //                 categoryListWidget.add(ListTile(
  //                   leading: IconButton(
  //                     icon: Icon(
  //                       Icons.star_border_rounded,
  //                       color: Colors.yellow[600],
  //                     ),
  //                     onPressed: () {
  //                       print("Something to do");
  //                     },
  //                   ),
  //                   title: GestureDetector(
  //                       onTap: () {
  //                         Navigator.pushNamed(context, '/PostList', arguments: {
  //                           "BOARDNAME": boardName,
  //                           "BOARDID": id
  //                         });
  //                       },
  //                       child: Container(child: Text(boardName ?? "ERROR"))),
  //                 ));
  //               });

  //               return Column(
  //                   children: categoryListWidget
  //                     ..add(Center(
  //                       child: IconButton(
  //                         icon: Icon(Icons.add),
  //                         onPressed: () async {
  //                           await Navigator.of(context)
  //                               .pushNamed("/BoardCreate")
  //                               .then((value) {
  //                             context.read(futureBoardProvider).fetchPro;
  //                           });
  //                         },
  //                       ),
  //                     )));
  //             },
  //             loading: () => CupertinoActivityIndicator(),
  //             error: (e, stack) => Center(child: Text("Error $e")));
  //       },
  //     );
  // get futureBoardNameList => futureBoardProvider;

  @override
  Widget build(BuildContext context, watch) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
