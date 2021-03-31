import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';
import 'package:onestep_rezero/search/providers/searchProductProvider.dart';

final searchProductProvider =
    StateNotifierProvider<SearchProductProvider>((ref) {
  return SearchProductProvider();
});

class SearchProductBody extends ConsumerWidget {
  const SearchProductBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final searchProductlist = watch(searchProductProvider.state);

    return ProductGridView(itemList: searchProductlist);
  }
}
