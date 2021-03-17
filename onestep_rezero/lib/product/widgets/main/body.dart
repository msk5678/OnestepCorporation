import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/provider/productMainProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final productMainService = StateNotifierProvider<ProductMainService>((ref) {
  return ProductMainService();
});

class ProductMainBody extends ConsumerWidget {
  const ProductMainBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final productlist = watch(productMainService.state);

    return ProductGridView(itemList: productlist);
  }
}
