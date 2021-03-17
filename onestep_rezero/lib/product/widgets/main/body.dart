import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';


class ProductMainBody extends ConsumerWidget {
  const ProductMainBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // watch(productMainProvider);
    return ProductGridView();
  }
}
