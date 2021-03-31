import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/widgets/detail/productDetailBody.dart';

class ClothDetail extends StatefulWidget {
  final String docId;
  ClothDetail({Key key, @required this.docId}) : super(key: key);

  @override
  _ClothDetailState createState() => _ClothDetailState();
}

class _ClothDetailState extends State<ClothDetail> {
  Product _product;

  @override
  void dispose() {
    // TODO: implement dispose
    print("");
    // Navigator.pop(context);
    super.dispose();
  }

  void incProductViews() {
    // 조회수 증가

    if (_product.views == null ||
        _product.views["EQ0UIt2ujMd642TxMzrZ0zJZTzB3"] != true) {
      FirebaseFirestore.instance
          .collection("products")
          .doc(widget.docId)
          .update(
        {
          "views.EQ0UIt2ujMd642TxMzrZ0zJZTzB3": true,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("products")
          .doc(widget.docId)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.data.data()['deleted'] ||
                snapshot.data.data()['hide']) {
              return Container(
                child: Center(
                  child: Text("없는 상품이에요."),
                ),
              );
            } else {
              _product =
                  Product.fromJson(snapshot.data.data(), snapshot.data.id);
              incProductViews();

              return ProductDetailBody(product: _product);
            }
        }
      },
    );
  }
}
