import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/categoryItem.dart';

class CategoryDetail extends StatefulWidget {
  final String category;
  CategoryDetail({Key key, this.category}) : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  Widget renderHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 5),
        SizedBox(
          height: 50.0,
          child: ListView.builder(
            padding: EdgeInsets.all(5.0),
            physics: ClampingScrollPhysics(),
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: CategoryItem.test[widget.category]["list"].length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color:
                    //  _headerindex == index ?
                    // Colors.black,
                    Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        CategoryItem.test[widget.category]["list"][index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              // _headerindex == index
                              // ?
                              // Colors.white
                              Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // setState(() {
                    //   _headerindex = index;
                    //   widget.productProvider.fetchProducts(
                    //       _category.getCategoryItems()[_headerindex]);
                    // });
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 5),
      ],
    );
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
              this.renderHeader(),
              // this.renderBody(),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
