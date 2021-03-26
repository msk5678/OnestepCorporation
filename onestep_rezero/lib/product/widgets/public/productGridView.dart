import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/widgets/public/productItem.dart';

class ProductGridView extends StatelessWidget {
  final List itemList;
  const ProductGridView({Key key, this.itemList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.28;
    final double _itemWidth = _size.width / 2;

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: _itemWidth > _itemHeight
              ? (_itemHeight / _itemWidth)
              : (_itemWidth / _itemHeight),
          crossAxisCount: 3,
          mainAxisSpacing: 15,
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
