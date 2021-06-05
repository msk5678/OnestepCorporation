import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onestep_rezero/search/widgets/product/searchProductBody.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchAllMain extends StatefulWidget {
  final int searchKey;
  SearchAllMain({Key key, @required this.searchKey}) : super(key: key);

  @override
  _SearchAllMainState createState() => _SearchAllMainState();
}

class _SearchAllMainState extends State<SearchAllMain> {
  TextEditingController _textController;
  final ScrollController _productScrollController = ScrollController();
  final ScrollController _boardScrollController = ScrollController();

  final StreamController<bool> _streamController = StreamController<bool>();
  String _searchText;
  bool _isSearchMode;

  @override
  void initState() {
    context.read(searchProductProvider).clearList();

    // if (context.read(searchProductProvider.state).isNotEmpty)
    //   context
    //       .read(searchProductProvider.state)
    //       .clear(); // board provider list 초기화 필요

    _textController = TextEditingController(text: "");

    _productScrollController.addListener(productScrollListener);
    _boardScrollController.addListener(boardScrollListener);

    _searchText = "";
    _isSearchMode = false;

    super.initState();
  }

  @override
  void dispose() {
    _productScrollController.dispose();
    _boardScrollController.dispose();
    _streamController.close();

    super.dispose();
  }

  void productScrollListener() {
    if ((_productScrollController.position.maxScrollExtent * 0.7) <
        _productScrollController.position.pixels) {
      context.read(searchProductProvider).searchNextProducts(_searchText);
    }
  }

  void boardScrollListener() {
    if ((_boardScrollController.position.maxScrollExtent * 0.7) <
        _boardScrollController.position.pixels) {
      // context.read(searchProductProvider).searchNextProducts(_searchText);
      //board provider 글 더불러오기
    }
  }

  _setLatestSearch(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> search = (prefs.getStringList('latestSearch') ?? []);

    search.removeWhere((element) => element == text);
    search.insert(0, text);

    await prefs.setStringList('latestSearch', search);
  }

  _searchContent(String text) {
    if (text.trim().length >= 2) {
      _searchText = text;

      _setLatestSearch(_searchText); // 검색어 내부 DB 저장

      switch (this.widget.searchKey) {
        case 0:
        // 게시판 검색
        case 1:
          context.read(searchProductProvider).searchProducts(_searchText);
          break;

        case 2:
        // 게시판 검색
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('두 글자 이상 입력해주세요.'),
      ));
    }
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
                    setState(() {
                      _isSearchMode = true;
                    });
                  },
                  // autofocus: _isSearchMode == true ? true : false,
                  controller: _textController,
                  onSubmitted: (text) {
                    _searchContent(text);
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
      bottom: _isSearchMode ? appBarBottom() : null,
    );
  }

  Widget appBarBottom() {
    return widget.searchKey == 0
        ? TabBar(
            tabs: [
              Tab(
                child: Text(
                  "장터",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "게시판",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )
        : null;
  }

  Widget allBody() {
    return TabBarView(
      children: [
        SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _productScrollController,
          child: SearchProductBody(),
        ),
        SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _boardScrollController,
          child: Container(
            child: Center(
              child: Text(
                "게시판 검색",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget singleBody() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: widget.searchKey == 1
          ? _productScrollController
          : _boardScrollController,
      child: widget.searchKey == 1
          ? SearchProductBody()
          : Container(
              child: Center(
                child: Text(
                  "게시판 검색",
                ),
              ),
            ),
    );
  }

  Widget floatingButton() {
    return StreamBuilder<bool>(
      stream: _streamController.stream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Visibility(
          visible: snapshot.data,
          child: Container(
            height: 40.0,
            width: 40.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "searchFloatActionButton",
                onPressed: () {
                  if (this.widget.searchKey == 0) {
                    if (DefaultTabController.of(context).index == 0)
                      _productScrollController.position
                          .moveTo(0.5, duration: Duration(milliseconds: 200));
                    else if (DefaultTabController.of(context).index == 1)
                      _boardScrollController.position
                          .moveTo(0.5, duration: Duration(milliseconds: 200));
                  } else {
                    if (this.widget.searchKey == 1)
                      _productScrollController.position
                          .moveTo(0.5, duration: Duration(milliseconds: 200));
                    else if (this.widget.searchKey == 2)
                      _boardScrollController.position
                          .moveTo(0.5, duration: Duration(milliseconds: 200));
                  }
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

  Widget aaBody() {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> search =
                (snapshot.data.getStringList('latestSearch') ?? []);
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  itemCount: search.length,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("${search[index]}",
                                style: TextStyle(),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        onTap: () {
                          _searchContent(search[index]);
                          setState(() {
                            _isSearchMode = false;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget aa() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("최근 검색어"),
              ),
              GestureDetector(
                onTap: () {
                  // Provider.of<AppDatabase>(context, listen: false)
                  //     .searchsDao
                  //     .deleteAllSearch();
                  // setState(() {
                  //   _textController.clear();
                  // });
                },
                child: Container(
                  child: Text("모두 삭제"),
                ),
              ),
            ],
          ),
        ),
        aaBody(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool chk = widget.searchKey == 0;

    return DefaultTabController(
      length: chk ? 2 : 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: _isSearchMode
            ? chk
                ? allBody()
                : singleBody()
            : aa(),
        floatingActionButton: floatingButton(),
      ),
    );
  }
}
