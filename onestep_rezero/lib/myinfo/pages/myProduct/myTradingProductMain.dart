import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestep_rezero/myinfo/widgets/myProduct/mySaleProductBody.dart';
import 'package:onestep_rezero/myinfo/widgets/myProduct/myTradingProductBody.dart';
import 'package:onestep_rezero/utils/onestepCustom/CustomFloatingActionButton.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyTradingProductMain extends StatefulWidget {
  MyTradingProductMain({Key key}) : super(key: key);

  @override
  _MyTradingProductMainState createState() => _MyTradingProductMainState();
}

class _MyTradingProductMainState extends State<MyTradingProductMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollToTopstreamController = BehaviorSubject();

  bool _isVisibility = false;

  @override
  void initState() {
    context.read(myTradingProductProvider).product.clear();
    context.read(myTradingProductProvider).fetchProducts();
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
      context.read(myTradingProductProvider).fetchNextProducts();
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

  Widget _bodyWidget() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyTradingProductBody(),
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
      floatingActionButton: CustomFloatingActionButton.scrollToTopButton(
          scrollController: _scrollController,
          streamController: _scrollToTopstreamController),
    );
  }
}
