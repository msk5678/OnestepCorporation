import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/favorite/widgets/favoriteMainBody.dart';

import 'package:onestep_rezero/utils/onestepCustom/CustomFloatingActionButton.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteMain extends StatefulWidget {
  FavoriteMain({Key key}) : super(key: key);

  @override
  _FavoriteMainState createState() => _FavoriteMainState();
}

class _FavoriteMainState extends State<FavoriteMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollToTopstreamController = BehaviorSubject();
  bool _isVisibility = false;

  @override
  void initState() {
    context.read(favoriteMainProvider).product.clear();
    context.read(favoriteMainProvider).fetchProducts();
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollToTopstreamController.close();
    super.dispose();
  }

  void scrollListener() {
    if ((_scrollController.position.maxScrollExtent * 0.7) <
        _scrollController.position.pixels) {
      context.read(favoriteMainProvider).fetchNextProducts();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '찜한 아이템',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          // new IconButton(
          //   icon: new Icon(
          //     Icons.refresh,
          //     color: Colors.black,
          //   ),
          //   onPressed: () => {
          // setState(() {
          //   widget.favoriteProvider.fetchProducts();
          // })
          //   },
          // ),
          // new IconButton(
          //   icon: new Icon(
          //     Icons.delete,
          //     color: Colors.black,
          //   ),
          //   onPressed: () => {
          //     print("delete all product"),
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // FavoriteMainHeader(),
            FavoriteMainBody(),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton.scrollToTopButton(
          scrollController: _scrollController,
          streamController: _scrollToTopstreamController),
    );
  }
}
