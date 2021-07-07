import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/providers/categoryProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final categoryProvider = ChangeNotifierProvider<CategoryProvider>((ref) {
  return CategoryProvider();
});

class CategoryDetailBody extends ConsumerWidget {
  const CategoryDetailBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    bool isFetching = watch(categoryProvider).isFetching;
    if (isFetching) return CircularProgressIndicator();

    final productList = watch(categoryProvider).products;
    if (productList.length == 0) {
      return Text("등록된 상품이 없습니다");
    } else {
      return ProductGridView(itemList: productList);
    }
  }
}
