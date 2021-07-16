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
    bool isFetching = watch(mySaleProductProvider).isFetching;
    if (isFetching) return CircularProgressIndicator();

    final productList = watch(mySaleProductProvider).products;
    if (productList.length == 0) {
      return Text("판매중인 상품이 없습니다");
    } else {
      return ProductGridView(itemList: productList);
    }
  }
}
