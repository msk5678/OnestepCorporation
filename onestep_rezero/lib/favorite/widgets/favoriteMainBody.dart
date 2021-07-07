import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/favorite/providers/favoriteMainProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final favoriteMainProvider =
    ChangeNotifierProvider<FavoriteMainProvider>((ref) {
  return FavoriteMainProvider();
});

class FavoriteMainBody extends ConsumerWidget {
  const FavoriteMainBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    bool isFetching = watch(favoriteMainProvider).isFetching;
    if (isFetching) {
      return Center(child: CircularProgressIndicator());
    }

    final productlist = watch(favoriteMainProvider).products;

    if (productlist.length == 0) {
      return Center(child: Text("찜한 상품이 없습니다"));
    } else {
      return ProductGridView(itemList: productlist);
    }
  }
}
