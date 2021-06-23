import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/StateManage/Provider/boardListProvider.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';

final boardListProvider =
    ChangeNotifierProvider<BoardListProvider>((ref) => BoardListProvider());

class BoardListRiverpod extends ConsumerWidget {
  final animationStopCallback;
  BoardListRiverpod({this.animationStopCallback});
  @override
  Widget build(BuildContext context, watch) {
    final boardlistProvider = watch(boardListProvider).boards;
    return BoardListView(
      boardList: boardlistProvider,
      manageAnimationTimer: animationStopCallback,
    );
  }
}

class BoardListView extends ConsumerWidget {
  final List<BoardData> boardList;
  final Function manageAnimationTimer;
  BoardListView({this.boardList, this.manageAnimationTimer});

  @override
  Widget build(BuildContext context, watch) {
    List<Widget> categoryListWidget = [];

    boardList.forEach((value) {
      BoardCategory boardCategory = value.boardCategory;
      categoryListWidget.add(ListTile(
        leading: IconButton(
          icon: Icon(
            boardCategory.categoryData.icon,
            size: 25,
            // color: Colors.indigo[300],
            color: Colors.black,
          ),
          onPressed: () {
            print("Something to do");
          },
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.star_border_rounded,
            // color: Colors.yellow[600],
          ),
          onPressed: () {
            print("Something to do");
          },
        ),
        subtitle: GestureDetector(
            onTap: () async {
              manageAnimationTimer(false);
              await Navigator.pushNamed(context, '/PostList',
                      arguments: {"CURRENTBOARDDATA": value})
                  .then((value) => manageAnimationTimer(true));
            },
            child: Container(
                child: Text(
              value.boardExplain ?? "ERROR",
            ))),
        title: GestureDetector(
            onTap: () async {
              manageAnimationTimer(false);
              await Navigator.pushNamed(context, '/PostList',
                      arguments: {"CURRENTBOARDDATA": value})
                  .then((value) => manageAnimationTimer(true));
            },
            child: Container(
                child: Text(
              value.boardName ?? "ERROR",
            ))),
      ));
    });

    return Column(children: categoryListWidget
        // ..add(Center(
        //   child: IconButton(
        //     icon: Icon(Icons.add),
        //     onPressed: () async {
        //       manageAnimationTimer(false);
        //       await Navigator.of(context)
        //           .pushNamed("/BoardCreate")
        //           .then((value) {
        //         bool result = value ?? false;
        //         if (result) context.read(boardListProvider).fetchBoards();
        //         manageAnimationTimer(true);
        //       });
        //     },
        //   ),
        // )
        // )
        );
  }
}
