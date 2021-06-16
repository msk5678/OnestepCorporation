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
    return ListView.builder(
      itemCount: widget.category.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).pop(widget.category.keys.elementAt(index));
          },
          title: Text(widget.category.keys.elementAt(index)),
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
