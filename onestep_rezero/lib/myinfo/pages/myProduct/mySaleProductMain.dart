import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestep_rezero/myinfo/widgets/myProduct/mySaleProductBody.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySaleProductMain extends StatefulWidget {
  MySaleProductMain({Key key}) : super(key: key);

  @override
  _MySaleProductMainState createState() => _MySaleProductMainState();
}

class _MySaleProductMainState extends State<MySaleProductMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollToTopstreamController = BehaviorSubject();

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
    _scrollToTopstreamController.close();
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
        _scrollToTopstreamController.sink.add(true);
      }
    } else if (_scrollController.offset < 600) {
      if (_isVisibility) {
        _isVisibility = false;
        _scrollToTopstreamController.sink.add(false);
      }
    }
  }

  Widget scrollToTopFloatingActionButton() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: StreamBuilder<bool>(
            stream: _scrollToTopstreamController.stream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Visibility(
                visible: snapshot.data,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 40.0.h,
                  width: 40.0.w,
                  child: FittedBox(
                    child: FloatingActionButton(
                      elevation: 0,
                      heroTag: null,
                      onPressed: () {
                        _scrollController.position
                            .moveTo(0.5, duration: Duration(milliseconds: 200));
                      },
                      child: Icon(Icons.keyboard_arrow_up_rounded,
                          color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MySaleProductBody(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _bodyWidget(),
      floatingActionButton: scrollToTopFloatingActionButton(),
    );
  }
}
