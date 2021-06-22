import 'dart:collection';

import 'package:flutter/material.dart';

class ProductAddDetailCategorySelect extends StatefulWidget {
  final Map<String, dynamic> category;
  ProductAddDetailCategorySelect({Key key, this.category}) : super(key: key);

  @override
  _ProductAddDetailCategorySelect createState() =>
      _ProductAddDetailCategorySelect();
}

class _ProductAddDetailCategorySelect
    extends State<ProductAddDetailCategorySelect> {
  Widget detailCategory() {
    Map<String, dynamic> categoryMap = widget.category;

    var sortedKeys = categoryMap.keys.toList(growable: false)
      ..sort((k1, k2) => categoryMap[k2].compareTo(categoryMap[k1]));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => categoryMap[k]);

    return ListView.builder(
      itemCount: sortedMap.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).pop(sortedMap.keys.elementAt(index));
          },
          title: Text(sortedMap.keys.elementAt(index)),
        );
      },
    );
  }

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
          "상세 카테고리 선택",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: detailCategory(),
    );
  }
}
