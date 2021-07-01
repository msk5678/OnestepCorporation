import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:onestep_rezero/utils/floatingSnackBar.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialog.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

class ProductBump extends StatefulWidget {
  final Product product;
  ProductBump({Key key, this.product}) : super(key: key);

  @override
  _ProductBumpState createState() => _ProductBumpState();
}

class _ProductBumpState extends State<ProductBump> {
  TextEditingController _priceEditingController;
  StreamController<bool> _pricePrefixStreamController;
  StreamController<bool> _priceSuffixStreamController;

  @override
  void initState() {
    _priceEditingController =
        new TextEditingController(text: widget.product.price);
    _pricePrefixStreamController = StreamController();
    _priceSuffixStreamController = StreamController();

    super.initState();
  }

  @override
  void dispose() {
    _pricePrefixStreamController.close();
    _priceSuffixStreamController.close();
    super.dispose();
  }

  _saveDataInFirestore() async {
    FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .doc(widget.product.firestoreid)
        .update(
      {
        "price": _priceEditingController.text,
        "bumpTime": DateTime.now().microsecondsSinceEpoch,
      },
    ).whenComplete(
      () {
        context.read(productMainService).fetchProducts();
        FloatingSnackBar.show(context, "상품을 끌어올렸어요");

        FocusScope.of(context).unfocus(); // keyboard unfocus
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 3);
      },
    ).onError((error, stackTrace) {
      FloatingSnackBar.show(context, "상품을 끌어올리기에 실패했어요");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("끌어올리기", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.imagesUrl[0],
                      width: 80,
                      height: 80,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error), // 로딩 오류 시 이미지
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.product.price,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _priceEditingController,
              onChanged: (value) {
                if (value == widget.product.price) {
                  _pricePrefixStreamController.sink.add(false);
                } else {
                  _pricePrefixStreamController.sink.add(true);
                }
              },
              style: Theme.of(context).textTheme.headline5,
              keyboardType: TextInputType.number,
              maxLength: 11,
              inputFormatters: [
                ThousandsFormatter(),
              ],
              decoration: InputDecoration(
                counterText: "",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                prefixIcon: SizedBox(
                  child: Center(
                    widthFactor: 0.0,
                    child: Text('₩', style: TextStyle(fontSize: 15)),
                  ),
                ),
                suffixIcon: SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      _pricePrefixStreamController.sink.add(false);
                      _priceSuffixStreamController.sink.add(false);
                      _priceEditingController.text =
                          widget.product.price.toString();
                      _priceEditingController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _priceEditingController.text.length));
                    },
                    child: StreamBuilder(
                        stream: _priceSuffixStreamController.stream,
                        initialData: false,
                        builder: (BuildContext context, snapshot) {
                          return Visibility(
                            visible: snapshot.data,
                            child: Center(
                              widthFactor: 0.0,
                              child: Text('취소',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.redAccent)),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: StreamBuilder(
                stream: _pricePrefixStreamController.stream,
                initialData: false,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.data) {
                    _priceSuffixStreamController.sink.add(true);
                    return Text(
                      "가격을 ₩${_priceEditingController.text}으로 변경하고 끌어올립니다",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    _priceSuffixStreamController.sink.add(false);
                    return Text(
                      "가격을 변경하지 않고 끌어올립니다",
                      style: TextStyle(fontSize: 20),
                    );
                  }
                },
              ),
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  OnestepCustomDialog.show(
                    context,
                    title: '상품을 끌어올리시겠습니까?',
                    confirmButtonText: '확인',
                    cancleButtonText: '취소',
                    confirmButtonOnPress: _saveDataInFirestore,
                  );
                },
                child: Text('끌어올리기'),
                style: ElevatedButton.styleFrom(
                  primary: OnestepColors().mainColor,
                  onPrimary: Colors.white,
                  textStyle: TextStyle(fontSize: 17),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
