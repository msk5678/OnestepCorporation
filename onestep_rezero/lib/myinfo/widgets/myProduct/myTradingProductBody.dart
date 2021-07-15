import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/providers/myProduct/myTradingProductProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final myTradingProductProvider =
    ChangeNotifierProvider<MyTradingProductProvider>((ref) {
  return MyTradingProductProvider();
});

class MyTradingProductBody extends ConsumerWidget {
  const MyTradingProductBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final productlist = watch(myTradingProductProvider).products;

    return ProductGridView(itemList: productlist);
  }
}
