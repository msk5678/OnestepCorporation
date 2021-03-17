import 'package:flutter/material.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.28;
    final double _itemWidth = _size.width / 2;

    return GridView(
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
        // ...widget.allProductProvider.products
        //     .map(
        //       (product) => ClothItem(
        //         product: product,
        //       ),
        //     )
        //     .toList(),
      ],
    );
  }
}
