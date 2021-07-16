import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestep_rezero/myinfo/widgets/myProduct/myCompletedProductBody.dart';

import 'package:onestep_rezero/utils/onestepCustom/CustomFloatingActionButton.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCompletedProductMain extends StatefulWidget {
  MyCompletedProductMain({Key key}) : super(key: key);

  @override
  _MyCompletedProductMainState createState() => _MyCompletedProductMainState();
}

class _MyCompletedProductMainState extends State<MyCompletedProductMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollToTopstreamController = BehaviorSubject();

  bool _isVisibility = false;

  @override
  void initState() {
    context.read(myCompletedProductProvider).product.clear();
    context.read(myCompletedProductProvider).fetchProducts();
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
      context.read(myCompletedProductProvider).fetchNextProducts();
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
            MyCompletedProductBody(),
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
            streamController: _scrollToTopstreamController));
  }
}
