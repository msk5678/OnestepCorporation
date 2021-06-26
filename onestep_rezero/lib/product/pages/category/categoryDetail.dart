import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/widgets/categoryDetail/categoryDetailBody.dart';
import 'package:onestep_rezero/product/widgets/categoryDetail/categoryDetailHeader.dart';

class CategoryDetail extends StatefulWidget {
  final int total;
  final String category;
  final Map<String, dynamic> detailCategory;

  CategoryDetail(
      {Key key,
      @required this.category,
      @required this.detailCategory,
      @required this.total})
      : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(scrollListener);

    context.read(categoryProvider).product.clear();
    context
        .read(categoryProvider)
        .fetchProducts(category: widget.category, detailCategory: null);
    super.initState();
  }

  void scrollListener() {
    if ((_scrollController.position.maxScrollExtent * 0.7) <
        _scrollController.position.pixels) {
      context.read(categoryProvider).fetchNextProducts();
    }
  }

  Future<void> _refreshPage() async {
    context.read(categoryProvider).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.category,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CategoryDetailHeader(
                    category: widget.category,
                    total: widget.total,
                    detailcategory: widget.detailCategory),
                CategoryDetailBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
