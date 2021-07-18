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
    bool isFetching = watch(myCompletedProductProvider).isFetching;
    if (isFetching) return CircularProgressIndicator();

    final productList = watch(myCompletedProductProvider).products;
    if (productList.length == 0) {
      return Text("판매완료한 상품이 없습니다");
    } else {
      return ProductGridView(itemList: productList);
    }
  }
}
