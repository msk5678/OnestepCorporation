import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onestep_rezero/product/widgets/main/body.dart';
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
      // widget.allProductProvider.fetchNextProducts();
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
        new IconButton(
          icon: new Icon(
            Icons.refresh,
            color: Colors.black,
          ),
          onPressed: () => {
            // setState(() {
            //   widget.allProductProvider.fetchProducts();
            // })
          },
        ),
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
      // widget.allProductProvider.fetchProducts();
    });
  }

  Widget renderBody() {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.28;
    final double _itemWidth = _size.width / 2;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: _itemWidth > _itemHeight
              ? (_itemHeight / _itemWidth)
              : (_itemWidth / _itemHeight),
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 7,
        ),
        children: [
          // ...widget.allProductProvider.products
          //     .map(
          //       (product) => ClothItem(
          //         product: product,
          //       ),
          //     )
          //     .toList(),
        ],
      ),
    );
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
                // renderBody(),
                ProductMainBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
