import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/loggedInWidget.dart';

import 'package:onestep_rezero/product/models/categorySelectItem.dart';
import 'package:onestep_rezero/product/pages/product/productAddDetailCategorySelect.dart';

class ProductAddCategorySelect extends StatefulWidget {
  ProductAddCategorySelect({Key key}) : super(key: key);

  @override
  _ProductAddCategorySelectState createState() =>
      _ProductAddCategorySelectState();
}

Widget mainCategory() {
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

          return ListView.builder(
            itemCount: sortedMap.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  Map map = sortedMap[sortedMap.keys.elementAt(index)];

                  String _category = sortedMap.keys.elementAt(index);
                  Map _detailCategory = map['detail'];

                  _detailCategory.isEmpty
                      ? Navigator.of(context).pop(CategorySelectItem(
                          category: _category, detailCategory: null))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductAddDetailCategorySelect(
                                    category: _detailCategory),
                          )).then((value) {
                          if (value != null)
                            Navigator.of(context).pop(CategorySelectItem(
                                category: _category, detailCategory: value));
                        });
                },
                leading: Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Image.asset(
                        sortedMap[sortedMap.keys.elementAt(index)]['image'],
                        width: 30,
                        height: 30)),
                title: Text(sortedMap.keys.elementAt(index)),
                trailing:
                    // map['detail']
                    // ? null
                    // :
                    Icon(Icons.arrow_forward_ios_rounded),
              );
            },
          );
      }
    },
  );
}

class _ProductAddCategorySelectState extends State<ProductAddCategorySelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "카테고리 선택",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: mainCategory(),
    );
  }
}
