import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/favorite/pages/favoriteMain.dart';
import 'package:onestep_rezero/product/pages/productAdd.dart';

import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:onestep_rezero/product/widgets/main/productMainHeader.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';

class ProductMain extends StatefulWidget {
  @override
  _ProductMainState createState() => _ProductMainState();
}

class _ProductMainState extends State<ProductMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollToTopstreamController =
      StreamController<bool>();
  final StreamController<bool> _productAddstreamController =
      StreamController<bool>();
  bool _isVisibility = false;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    context.read(productMainService).fetchProducts();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollToTopstreamController.close();
    _productAddstreamController.close();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _productAddstreamController.sink.add(true);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _productAddstreamController.sink.add(false);
    }

    if ((_scrollController.position.maxScrollExtent * 0.7) <
        _scrollController.position.pixels) {
      context.read(productMainService).fetchNextProducts();
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

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(
        '장터',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: <Widget>[
        // new IconButton(
        //   icon: new Icon(
        //     Icons.refresh,
        //     color: Colors.black,
        //   ),
        //   onPressed: () => {
        //     // setState(() {
        //     _scrollController.position
        //         .moveTo(0.5, duration: Duration(milliseconds: 500)),
        //     context.read(productMainService).fetchProducts(),
        //     // })
        //   },
        // ),
        new IconButton(
          icon: new Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SearchAllMain(searchKey: 1)),
            ),
          },
        ),
        new IconButton(
          icon: new Icon(
            Icons.favorite,
            color: Colors.pink,
          ),
          onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FavoriteMain(),
              ),
            ),
          },
        ),
      ],
    );
  }

  Future<void> _refreshPage() async {
    context.read(productMainService).fetchProducts();
  }

  Widget productAddFLoatingActionButton() {
    return StreamBuilder<bool>(
        stream: _productAddstreamController.stream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Visibility(
            visible: snapshot.data,
            child: Container(
              height: 40,
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProductAdd()));
                },
                backgroundColor: Colors.white,
                // icon: Icon(
                //   Icons.save,
                //   color: Colors.black,
                // ),
                label: Text(
                  "물품 등록",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget scrollToTopFloatingActionButton() {
    return StreamBuilder<bool>(
      stream: _scrollToTopstreamController.stream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Visibility(
          visible: snapshot.data,
          child: Container(
            height: 40.0,
            width: 40.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: null,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ProductMainHeader(),
                SizedBox(
                    height: 10,
                    child: Container(color: Color.fromRGBO(240, 240, 240, 1))),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Text("오늘의 상품",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600))),
                ),
                ProductMainBody(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: productAddFLoatingActionButton(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: scrollToTopFloatingActionButton(),
          ),
        ],
      ),
    );
  }
}
