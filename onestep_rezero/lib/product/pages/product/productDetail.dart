import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/widgets/detail/productDetailBody.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetail extends StatefulWidget {
  final String docId;
  ProductDetail({Key key, @required this.docId}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Product _product;

  @override
  void dispose() {
    super.dispose();
  }

  void incProductViews() {
    // 조회수 증가
    if (_product.uid != currentUserModel.uid) {
      if (_product.views == null ||
          _product.views[currentUserModel.uid] != true) {
        FirebaseFirestore.instance
            .collection("university")
            .doc(currentUserModel.university)
            .collection("product")
            .doc(widget.docId)
            .update(
          {
            "views." + currentUserModel.uid: true,
          },
        );
      }
    }
  }

  Widget exceptionWidget(String text) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 22.sp),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("university")
          .doc(currentUserModel.university)
          .collection("product")
          .doc(widget.docId)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return exceptionWidget("상품을 불러오는데 실패했어요.");
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.data.data()['deleted'] ||
                snapshot.data.data()['hide']) {
              return exceptionWidget("삭제된 상품이에요.");
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
