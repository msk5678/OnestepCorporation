import 'package:flutter/material.dart';

import 'package:onestep_rezero/product/widgets/categoryDetail/header.dart';

class CategoryDetail extends StatefulWidget {
  final String category;

  CategoryDetail({Key key, @required this.category}) : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.category,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body:
          // RefreshIndicator(
          // onRefresh: _refreshPage,
          // child:
          SingleChildScrollView(
        // controller: _scrollController,

        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // this.renderHeader(),
              CategoryDetailHeader(category: widget.category),
              // this.renderBody(),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
