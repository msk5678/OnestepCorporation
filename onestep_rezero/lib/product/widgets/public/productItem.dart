import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:onestep_rezero/animation/favoriteAnimation.dart';
import 'package:onestep_rezero/favorite/utils/favoriteFirebaseApi.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/pages/productDetail.dart';
import 'package:onestep_rezero/product/widgets/detail/TestproductDetailBody.dart';
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

  @override
  Widget build(BuildContext context) {
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
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        _fChk ? Icons.favorite_border : Icons.favorite,
                        color: Colors.pink,
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
                bottom: 0,
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
                          color: Colors.pink,
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

    Widget getImage(BuildContext context) {
      return CachedNetworkImage(
        imageUrl: widget.product.imagesUrl[0],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        errorWidget: (context, url, error) => Icon(Icons.error), // 로딩 오류 시 이미지
        fit: BoxFit.cover,
      );
    }

    double coverSize = 110;

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
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                    getImage(context),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: coverSize / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color.fromARGB(100, 0, 0, 0)
                            ],
                          ),
                        ),
                      ),
                    ),
                    setFavorite(),
                  ].where((item) => item != null).toList(),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            SizedBox(
              height: 15,
              child: Align(
                child: Row(
                  children: <Widget>[
                    Text(
                      "${widget.product.price}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      "원",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(
              height: 14,
              child: Align(
                child: Text(
                  "${widget.product.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                  ),
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
