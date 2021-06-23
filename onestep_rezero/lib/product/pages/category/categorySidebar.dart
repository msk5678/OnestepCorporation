import 'package:flutter/material.dart';

class CategorySidebar extends StatefulWidget {
  CategorySidebar({Key key}) : super(key: key);

  @override
  _CategorySidebarState createState() => _CategorySidebarState();
}

class _CategorySidebarState extends State<CategorySidebar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '카테고리 선택',
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
    );
  }
}
