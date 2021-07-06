import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/favorite/widgets/favoriteMainBody.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteMain extends StatefulWidget {
  FavoriteMain({Key key}) : super(key: key);

  @override
  _FavoriteMainState createState() => _FavoriteMainState();
}

class _FavoriteMainState extends State<FavoriteMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _streamController = StreamController<bool>();
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
    _streamController.close();
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
                heroTag: "favoriteMainFloatActionButton",
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
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
        child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // FavoriteMainHeader(),
                FavoriteMainBody(),
              ],
            )),
      ),
      floatingActionButton: floatingButton(),
    );
  }
}
