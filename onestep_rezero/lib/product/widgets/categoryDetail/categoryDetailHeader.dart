import 'dart:async';
import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/widgets/categoryDetail/categoryDetailBody.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDetailHeader extends StatefulWidget {
  final int total;
  final String category;
  final Map<String, dynamic> detailcategory;
  const CategoryDetailHeader(
      {Key key,
      @required this.detailcategory,
      @required this.total,
      @required this.category})
      : super(key: key);

  @override
  _CategoryDetailHeaderState createState() => _CategoryDetailHeaderState();
}

class _CategoryDetailHeaderState extends State<CategoryDetailHeader> {
  StreamController _streamController = BehaviorSubject();

  @override
  void initState() {
    _streamController.sink.add(0);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Widget renderHeader() {
    Map<String, dynamic> _detailCategory = widget.detailcategory;
    int total = widget.total;

    if (_detailCategory.isEmpty) return Container();
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        List<String> sortedKeys = _detailCategory.keys.toList(growable: true)
          ..sort(
              (k1, k2) => _detailCategory[k2].compareTo(_detailCategory[k1]));

        sortedKeys.insert(0, "전체");
        _detailCategory.addAll({"전체": total});

        LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => _detailCategory[k]);

        return Column(
          children: <Widget>[
            SizedBox(height: 5.sp),
            SizedBox(
              height: 50.0.sp,
              child: ListView.builder(
                padding: EdgeInsets.all(5.0),
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: sortedMap.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      child: Card(
                        color: snapshot.data == index
                            ? Colors.black
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10.w,
                            right: 10.w,
                            top: 5.h,
                            bottom: 5.h,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              sortedMap.keys.elementAt(index),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: snapshot.data == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        _streamController.sink.add(index);
                        context.read(categoryProvider).fetchProducts(
                            category: widget.category,
                            detailCategory: index == 0
                                ? null
                                : sortedMap.keys.elementAt(index));
                      });
                },
              ),
            ),
            SizedBox(height: 5.h),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderHeader();
  }
}
