import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/providers/myProduct/mySaleProductProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final mySaleProductProvider =
    ChangeNotifierProvider<MySaleProductProvider>((ref) {
  return MySaleProductProvider();
});

class MySaleProductBody extends ConsumerWidget {
  const MySaleProductBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final productlist = watch(mySaleProductProvider).products;

    return ProductGridView(itemList: productlist);
  }
}
