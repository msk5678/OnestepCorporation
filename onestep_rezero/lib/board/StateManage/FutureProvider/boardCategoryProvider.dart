import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final futureBoardProvider = FutureProvider<Map<String, String>>((ref) async {
  Map<String, String> boardList = {};
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("Board").get();
  querySnapshot.docs.forEach((element) {
    // print(element.id);
    boardList.addAll({element.id: element.data()["boardName"]});
  });
  return boardList;
});

class BoardCategoryProvider {
  BoardCategoryProvider();

  Widget get futureConsumerWidget => Consumer(
        builder: (context, watch, child) {
          final future = watch(futureBoardProvider);
          return future.when(
              data: (value) {
                List<Widget> categoryListWidget = [];
                value.forEach((id, boardName) {
                  categoryListWidget.add(ListTile(
                    leading: IconButton(
                      icon: Icon(
                        Icons.star_border_rounded,
                        color: Colors.yellow[600],
                      ),
                      onPressed: () {
                        print("Something to do");
                      },
                    ),
                    title: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/PostList',
                              arguments: {"BOARD_NAME": id});
                        },
                        child: Container(child: Text(boardName))),
                  ));
                });

                return Column(children: categoryListWidget);
              },
              loading: () => CupertinoActivityIndicator(),
              error: (e, stack) => Center(child: Text("Error $e")));
        },
      );
  get futureBoardCategoryList => futureBoardProvider;
}
