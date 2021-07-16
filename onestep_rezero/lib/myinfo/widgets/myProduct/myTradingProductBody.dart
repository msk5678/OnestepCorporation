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
    bool isFetching = watch(myTradingProductProvider).isFetching;
    if (isFetching) return CircularProgressIndicator();

    final productList = watch(myTradingProductProvider).products;
    if (productList.length == 0) {
      return Text("예약중인 상품이 없습니다");
    } else {
      return ProductGridView(itemList: productList);
    }
  }
}
