import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

class CategoryDetail extends StatefulWidget {
  final String category;

  CategoryDetail({Key key, @required this.category}) : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  int _headerindex;
  @override
  void initState() {
    _headerindex = 0;

    super.initState();
  }

  Widget renderHeader() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("category")
            .doc(widget.category)
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              Map<String, dynamic> _detailCategory = snapshot.data['detail'];

              _detailCategory.addAll({"전체": snapshot.data['total']});

              var mapEntries = _detailCategory.entries.toList()
                ..sort((a, b) => a.value.compareTo(b.value));

              LinkedHashMap sortedMap = (_detailCategory
                ..clear()
                ..addAll({"전체": snapshot.data['total']})
                ..addEntries(mapEntries)) as LinkedHashMap;

              // List<String> sortedKeys = _detailCategory.keys
              //     .toList(growable: false)
              //       ..sort((k1, k2) =>
              //           _detailCategory[k2].compareTo(_detailCategory[k1]));

              // sortedKeys.insert(0, "전체");

              // LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(
              //     sortedKeys,
              //     key: (k) => k,
              //     value: (k) => _detailCategory[k]);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 5),
                  SizedBox(
                    height: 50.0,
                    child: ListView.builder(
                      padding: EdgeInsets.all(5.0),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: sortedMap.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: _headerindex == index
                              ? Colors.black
                              : Colors.white,
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
                                  sortedMap.keys.elementAt(index),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _headerindex == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _headerindex = index;
                                //   widget.productProvider.fetchProducts(
                                //       _category.getCategoryItems()[_headerindex]);
                              });
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
        });
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
