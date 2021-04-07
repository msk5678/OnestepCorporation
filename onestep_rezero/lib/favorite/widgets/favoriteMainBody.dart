import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/favorite/providers/favoriteMainProvider.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';

final favoriteMainProvider = StateNotifierProvider<FavoriteMainProvider>((ref) {
  return FavoriteMainProvider();
});

class FavoriteMainBody extends ConsumerWidget {
  const FavoriteMainBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final productlist = watch(favoriteMainProvider.state);

    return ProductGridView(itemList: productlist);
  }
}
