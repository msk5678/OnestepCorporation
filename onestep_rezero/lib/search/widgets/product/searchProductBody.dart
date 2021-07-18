import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';
import 'package:onestep_rezero/search/providers/searchProductProvider.dart';

final searchProductProvider =
    ChangeNotifierProvider<SearchProductProvider>((ref) {
  return SearchProductProvider();
});

class SearchProductBody extends ConsumerWidget {
  const SearchProductBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    bool isFetching = watch(searchProductProvider).isFetching;
    if (isFetching) {
      return Center(child: CircularProgressIndicator());
    }

    final searchProductlist = watch(searchProductProvider).products;

    if (searchProductlist.length == 0) {
      return Center(child: Text("등록된 상품이 없습니다"));
    } else {
      return ProductGridView(itemList: searchProductlist);
    }
  }
}
