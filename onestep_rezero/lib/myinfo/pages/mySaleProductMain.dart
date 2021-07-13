import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestep_rezero/myinfo/widgets/mySaleProduct/mySaleProductBody.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySaleProductMain extends StatefulWidget {
  MySaleProductMain({Key key}) : super(key: key);

  @override
  _MySaleProductMainState createState() => _MySaleProductMainState();
}

class _MySaleProductMainState extends State<MySaleProductMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController _streamController = BehaviorSubject();
  bool _isVisibility = false;

  @override
  void initState() {
    context.read(mySaleProductProvider).product.clear();
    context.read(mySaleProductProvider).fetchProducts();
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void scrollListener() {
    if ((_scrollController.position.maxScrollExtent * 0.7) <
        _scrollController.position.pixels) {
      context.read(mySaleProductProvider).fetchNextProducts();
    }

    if (_scrollController.offset >= 600) {
      if (!_isVisibility) {
        _isVisibility = true;
        _streamController.sink.add(true);
      }
    } else if (_scrollController.offset < 600) {
      if (_isVisibility) {
        _isVisibility = false;
        _streamController.sink.add(false);
      }
    }
  }

  Widget floatingButton() {
    return StreamBuilder<bool>(
      stream: _streamController.stream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Visibility(
          visible: snapshot.data,
          child: Container(
            height: 40.0.h,
            width: 40.0.w,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "mySaleProductMainFloatActionButton",
                onPressed: () {
                  _scrollController.position
                      .moveTo(0.5, duration: Duration(milliseconds: 200));
                },
                child:
                    Icon(Icons.keyboard_arrow_up_rounded, color: Colors.black),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100.0))),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("@@@@@@@@@@@@@@@@@@ name : ${ModalRoute.of(context).settings.name}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          '내 판매상품',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MySaleProductBody(),
              ],
            )),
      ),
    );
    // floatingActionButton: floatingButton(),
  }
}
