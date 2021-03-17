import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/widgets/main/body.dart';
import 'package:onestep_rezero/product/widgets/main/floatingButton.dart';
import 'package:onestep_rezero/product/widgets/main/header.dart';

class ProductMain extends StatefulWidget {
  @override
  _ProductMainState createState() => _ProductMainState();
}

class _ProductMainState extends State<ProductMain> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    context.read(productMainService).fetchProducts();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read(productMainService).fetchNextProducts();
    }

    print(_scrollController.offset);
    if (_scrollController.offset >= 600) {
      print("이상");
      context.read(floatingStateProvider).state = true;
    } else {
      print("이하");
      context.read(floatingStateProvider).state = false;
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
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => Consumer<SearchProvider>(
            //       builder: (context, searchProvider, _) =>
            //           SearchProductBoardWidget(
            //         searchProvider: searchProvider,
            //         type: 'product',
            //       ),
            //     ),
            //   ),
            // ),
          },
        ),
        new IconButton(
          icon: new Icon(
            Icons.favorite,
            color: Colors.pink,
          ),
          onPressed: () => {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => Consumer<FavoriteProvider>(
            //       builder: (context, favoriteProvider, _) => FavoriteWidget(
            //         favoriteProvider: favoriteProvider,
            //       ),
            //     ),
            //   ),
            // ),
          },
        ),
      ],
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      context.read(productMainService).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // category
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
                // productitem

                ProductMainBody(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingButton(),
    );
  }
}
