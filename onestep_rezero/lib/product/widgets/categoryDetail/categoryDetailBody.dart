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
    final productList = watch(categoryProvider).products;
    return ProductGridView(itemList: productList);
  }
}
