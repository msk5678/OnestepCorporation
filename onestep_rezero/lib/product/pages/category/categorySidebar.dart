import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

import 'package:onestep_rezero/product/pages/category/categoryDetail.dart';

class CategorySidebar extends StatefulWidget {
  CategorySidebar({Key key}) : super(key: key);

  @override
  _CategorySidebarState createState() => _CategorySidebarState();
}

class _CategorySidebarState extends State<CategorySidebar> {
  Widget categoryList() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("category")
          .doc(currentUserModel.university)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            Map<String, dynamic> map = snapshot.data.data();

            var sortedKeys = map.keys.toList(growable: false)
              ..sort((k2, k1) => map[k1]['total'].compareTo(map[k2]['total']));

            LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
                key: (k) => k, value: (k) => map[k]);

            return Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: sortedMap.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (3.5 / 1),
                      // mainAxisSpacing: 20,
                      // crossAxisSpacing: 7,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Map map = sortedMap[sortedMap.keys.elementAt(index)];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CategoryDetail(
                                total: map['total'],
                                category: sortedMap.keys.elementAt(index),
                                detailCategory: map['detail'],
                              ),
                            ),
                          );
                        },
                        leading: Image.asset(
                            sortedMap[sortedMap.keys.elementAt(index)]['image'],
                            width: 30,
                            height: 30),
                        title: Transform.translate(
                          offset: Offset(-16, 0),
                          child: Text(
                            sortedMap.keys.elementAt(index),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      );
                    }));
        }
      },
    );
  }

  Widget body() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          categoryList(),
          Container(
            height: 40,
            color: OnestepColors().mainColor,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '카테고리',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: body(),
    );
  }
}
