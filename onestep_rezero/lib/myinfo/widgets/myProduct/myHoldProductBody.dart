import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onestep_rezero/myinfo/providers/myProduct/myHoldProductProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final myHoldProductProvider =
    ChangeNotifierProvider<MyHoldProductProvider>((ref) {
  return MyHoldProductProvider();
});

class MyHoldProductBody extends ConsumerWidget {
  const MyHoldProductBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final productlist = watch(myHoldProductProvider).products;

    return ProductGridView(itemList: productlist);
  }
}
