import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:onestep_rezero/animation/favoriteAnimation.dart';
import 'package:onestep_rezero/favorite/utils/favoriteFirebaseApi.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/pages/productDetail.dart';
import 'package:onestep_rezero/timeUtil.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  const ProductItem({Key key, @required this.product}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _fChk = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget setFavorite() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("university")
          .doc(currentUserModel.university)
          .collection('product')
          .doc(widget.product.firestoreid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      _fChk ? Icons.favorite_border : Icons.favorite,
                      color: _fChk ? Colors.white : Colors.pink,
                    ),
                  ],
                ),
              ),
            );
          default:
            Product p =
                Product.fromJson(snapshot.data.data(), snapshot.data.id);

            bool chk = p.favoriteUserList == null ||
                p.favoriteUserList[googleSignIn.currentUser.id] == null;

            _fChk = chk;
            return Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (chk) {
                          FavoriteFirebaseApi.insertFavorite(
                              widget.product.firestoreid);
                          FavoriteAnimation().showFavoriteDialog(context);
                        } else {
                          FavoriteFirebaseApi.deleteFavorite(
                              widget.product.firestoreid);
                        }
                      },
                      child: Icon(
                        chk ? Icons.favorite_border : Icons.favorite,
                        color: _fChk ? Colors.white : Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  Widget getImage() {
    Size size = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: widget.product.imagesUrl[0],
      width: size.width,
      height: size.height,
      errorWidget: (context, url, error) => Icon(Icons.error), // 로딩 오류 시 이미지
      fit: BoxFit.cover,
    );
  }

  Widget productState() {
    if (widget.product.trading || widget.product.completed) {
      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        height: 30,
        child: Container(
          alignment: Alignment.center,
          color: Colors.black.withOpacity(0.3),
          child: Text(widget.product.trading ? "예약중" : "판매완료",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center),
        ),
      );
    } else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ClothDetail(docId: widget.product.firestoreid),
          ),
        );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    getImage(),
                    productState(),
                    setFavorite(),
                  ].where((item) => item != null).toList(),
                ),
              ),
            ),
            SizedBox(height: 4),
            SizedBox(
              child: Align(
                child: Text(
                  "${widget.product.title}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 4),
            SizedBox(
              child: Align(
                child: Row(
                  children: <Widget>[
                    Text(
                      "${widget.product.price}원",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: <Widget>[
                // Flexible(
                //   child: SizedBox(
                //     height: 14,
                //     child: TextField(
                //       controller: _favoriteTextController,
                //       decoration: InputDecoration(
                //         prefixIcon: Icon(Icons.favorite_border_rounded,
                //             size: 12, color: Colors.grey),
                //         prefixIconConstraints:
                //             BoxConstraints(minWidth: 12, minHeight: 12),
                //         border: InputBorder.none,
                //         isCollapsed: true,
                //       ),
                //       maxLines: 1,
                //       textAlignVertical: TextAlignVertical.bottom,
                //       enableInteractiveSelection: false,
                //       readOnly: true,
                //       textAlign: TextAlign.left,
                //       style: TextStyle(
                //         fontSize: 12,
                //         fontWeight: FontWeight.w400,
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ),
                // ),
                Spacer(),
                Text(
                  TimeUtil.timeAgo(date: widget.product.bumpTime),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
