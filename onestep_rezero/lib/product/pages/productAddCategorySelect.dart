import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/categoryItem.dart';

class ProductAddCategorySelect extends StatefulWidget {
  ProductAddCategorySelect({Key key}) : super(key: key);

  @override
  _ProductAddCategorySelectState createState() =>
      _ProductAddCategorySelectState();
}

class _ProductAddCategorySelectState extends State<ProductAddCategorySelect> {
  @override
  Widget build(BuildContext context) {
    List<CategoryItem> categoryList = CategoryItem.items;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("카테고리 선택"),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).pop(categoryList[index].name);
            },
            leading: Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Image(
                    image: categoryList[index].image, width: 38, height: 38)),
            title: Text(categoryList[index].name),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          );
        },
      ),
    );
  }
}
