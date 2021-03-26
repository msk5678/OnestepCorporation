import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestep_rezero/search/widgets/product/searchProductBody.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProduct extends StatefulWidget {
  SearchProduct({Key key}) : super(key: key);

  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController _textController;
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _streamController = StreamController<bool>();
  String _searchText;
  bool _isSearchMode;

  @override
  void initState() {
    _textController = TextEditingController(text: "");
    _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length));
    _scrollController.addListener(scrollListener);
    _searchText = "";
    _isSearchMode = true;

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _streamController.close();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read(searchProductProvider).searchNextProducts(_searchText);
    }

    // if (_scrollController.offset >= 600) {
    //   if (!_isVisibility) {
    //     _isVisibility = true;
    //     _streamController.sink.add(true);
    //   }
    // } else if (_scrollController.offset < 600) {
    //   if (_isVisibility) {
    //     _isVisibility = false;
    //     _streamController.sink.add(false);
    //   }
    // }
  }

  Widget appBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Container(
                height: 50,
                child: TextField(
                  onTap: () {
                    print("textOnTap");
                    // setState(() {
                    //   _isSearchMode = true;
                    // });
                  },
                  // autofocus: _isSearchMode == true ? true : false,
                  controller: _textController,
                  onSubmitted: (text) {
                    // 2글자 제한
                    if (text.trim().length >= 2) {
                      _searchText = text;
                      context
                          .read(searchProductProvider)
                          .searchProducts(_searchText);

                      // search = Search(title: text, time: DateTime.now());
                      // p
                      //     .customSelect(
                      //         "SELECT * FROM Searchs WHERE title LIKE '$text'")
                      //     .getSingle()
                      //     .then((value) => {
                      //           if (value != null)
                      //             {
                      //               p.updateSearch(Search.fromJson(value.data)
                      //                   .copyWith(
                      //                       time: DateTime.now())), // 시간 update
                      //             }
                      //           else
                      //             {
                      //               p.insertSearch(search),
                      //             }
                      //         });

                      // setState(() {
                      //   _isSearchMode = false;
                      //   // _isAutoFocus = false;
                      // });
                    } else {
                      print("두 글자 이상 입력해주세요. 팝업");
                    }
                  },

                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Icon(Icons.search),
                    ),
                    suffixIcon: _textController.text != ""
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _textController.clear();
                            },
                          )
                        : null,
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "찾고 싶은 상품을 검색해보세요.",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return StreamBuilder<bool>(
      stream: _streamController.stream,
      initialData: _isSearchMode,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Visibility(
          visible: snapshot.data,
          child: Container(
            height: 40.0,
            width: 40.0,
            child: FittedBox(
              child: FloatingActionButton(
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
      appBar: appBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: SearchProductBody(),
      ),
    );
  }
}
