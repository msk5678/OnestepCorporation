import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/providers/myProduct/myCompletedProductProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final myCompletedProductProvider =
    ChangeNotifierProvider<MyCompletedProductProvider>((ref) {
  return MyCompletedProductProvider();
});

class MyCompletedProductBody extends ConsumerWidget {
  const MyCompletedProductBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final productlist = watch(myCompletedProductProvider).products;

    return ProductGridView(itemList: productlist);
  }
}
