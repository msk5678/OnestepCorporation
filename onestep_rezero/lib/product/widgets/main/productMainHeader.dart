import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onestep_rezero/product/pages/category/categoryDetail.dart';
import 'package:onestep_rezero/product/pages/category/categorySidebar.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class ProductMainHeader extends StatefulWidget {
  const ProductMainHeader({Key key}) : super(key: key);

  @override
  _ProductMainHeaderState createState() => _ProductMainHeaderState();
}

class _ProductMainHeaderState extends State<ProductMainHeader> {
  Future<DocumentSnapshot> myFuture;

  @override
  void initState() {
    super.initState();
    myFuture = FirebaseFirestore.instance
        .collection("category")
        .doc(currentUserModel.university)
        .get();
  }

  Widget header() {
    return FutureBuilder(
      future: myFuture,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            Map<String, dynamic> map = snapshot.data.data();

            List<String> sortedKeys = map.keys.toList(growable: true)
              ..sort((k2, k1) => map[k1]['total'].compareTo(map[k2]['total']));

            sortedKeys.removeRange(4, sortedKeys.length);

            LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
                key: (k) => k, value: (k) => map[k]);

            return Container(
              height: 80,
              child: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...sortedMap
                        .map(
                          (key, value) => MapEntry(
                            key,
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CategoryDetail(
                                      total: value['total'],
                                      category: key,
                                      detailCategory: value['detail'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Image.asset(value['image'],
                                        width: 45, height: 45),
                                  ),
                                  Text(key, style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategorySidebar()));
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Image.asset('icons/category/viewAll.png',
                                width: 45, height: 45),
                          ),
                          Text("전체보기", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

            return Container(
              height: 80,
              child: Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    Map map = sortedMap[sortedMap.keys.elementAt(index)];

                    return InkWell(
                      onTap: () {
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
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Image.asset(map['image'],
                                width: 45, height: 45),
                          ),
                          Text(sortedMap.keys.elementAt(index),
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return header();
  }
}
