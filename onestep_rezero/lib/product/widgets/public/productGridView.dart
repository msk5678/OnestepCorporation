import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/widgets/public/productItem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductGridView extends ConsumerWidget {
  final List itemList;
  const ProductGridView({Key key, @required this.itemList}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var _size = MediaQuery.of(context).size;

    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.7;
    final double _itemWidth = _size.width / 2;

    // return Padding(
    //   padding: EdgeInsets.only(top: 10),
    //   child: GridView(
    //     shrinkWrap: true,
    //     physics: NeverScrollableScrollPhysics(),
    //     padding: EdgeInsets.symmetric(horizontal: 15),
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       childAspectRatio: _itemWidth > _itemHeight
    //           ? (_itemHeight / _itemWidth)
    //           : (_itemWidth / _itemHeight),
    //       crossAxisCount: 3,
    //       mainAxisSpacing: 15,
    //       crossAxisSpacing: 7,
    //     ),
    //     children: [
    //       ...itemList
    //           .map(
    //             (product) => ProductItem(product: product),
    //           )
    //           .toList(),
    //     ],
    //   ),
    // );

    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.6.h,
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 7,
        ),
        children: [
          ...itemList
              .map(
                (product) => ProductItem(product: product),
              )
              .toList(),
        ],
      ),
    );
  }
}
