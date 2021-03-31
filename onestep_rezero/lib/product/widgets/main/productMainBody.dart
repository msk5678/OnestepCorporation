import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/providers/productMainProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final productMainService = StateNotifierProvider<ProductMainProvider>((ref) {
  return ProductMainProvider();
});

class ProductMainBody extends ConsumerWidget {
  const ProductMainBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final productList = watch(productMainService.state);
    return ProductGridView(itemList: productList);
  }
}
