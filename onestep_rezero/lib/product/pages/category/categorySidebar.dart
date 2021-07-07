import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/admob/googleAdmob.dart';

import 'package:onestep_rezero/signIn/loggedInWidget.dart';

import 'package:onestep_rezero/product/pages/category/categoryDetail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sortedMap.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (3.3 / 1),
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
                            width: 30.w,
                            height: 30.h),
                        title: Transform.translate(
                          offset: Offset(-10.w, 0),
                          child: Text(
                            sortedMap.keys.elementAt(index),
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                      );
                    }));
        }
      },
    );
  }

  Widget body() {
    Size _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          categoryList(),
          Positioned(
            child: GoogleAdmob().getChatMainBottomBanner(_size.width),
            bottom: 0,
          ),
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
