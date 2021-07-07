import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:onestep_rezero/product/pages/category/categoryDetail.dart';
import 'package:onestep_rezero/product/pages/category/categorySidebar.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              height: 80.h,
              margin: EdgeInsets.only(top: 15.h, bottom: 5.h),
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
                                      width: 35.w, height: 35.h),
                                ),
                                Text(key, style: TextStyle(fontSize: 12.sp)),
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
                          child: Image.asset(
                              'assets/icons/category/viewAll.png',
                              width: 35.w,
                              height: 35.h),
                        ),
                        Text("전체보기", style: TextStyle(fontSize: 12.sp)),
                      ],
                    ),
                  ),
                ],
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
