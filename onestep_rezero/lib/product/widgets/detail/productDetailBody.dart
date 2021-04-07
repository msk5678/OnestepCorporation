import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onestep_rezero/animation/favoriteAnimation.dart';
import 'package:onestep_rezero/favorite/utils/favoriteFirebaseApi.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/widgets/public/productItem.dart';
import 'package:onestep_rezero/product/widgets/public/productKakaoShareManager.dart';
import 'package:onestep_rezero/timeUtil.dart';

class ProductDetailBody extends StatefulWidget {
  final Product product;
  const ProductDetailBody({Key key, @required this.product}) : super(key: key);

  @override
  _ProductDetailBodyState createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody> {
  bool _isRunning;
  final StreamController<bool> _streamController = StreamController<bool>();

  TextEditingController _favoriteTextController;
  TextEditingController _priceEditingController;

  @override
  void initState() {
    _favoriteTextController = new TextEditingController(
        text: widget.product.favoriteuserlist == null
            ? "0"
            : widget.product.favoriteuserlist.length.toString());
    _priceEditingController =
        new TextEditingController(text: widget.product.price);
    _isRunning = false;
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  // sunghun kakao test
  // void _testModalBottomSheet(context, Product product) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height * .30,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             // mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
  //                 child: Row(
  //                   // mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     IconButton(
  //                       icon: Icon(
  //                         Icons.clear,
  //                         size: 30,
  //                       ),
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.fromLTRB(125, 0, 0, 0),
  //                       child: Center(
  //                           child: Container(
  //                               child: Text(
  //                         "공유하기",
  //                         style: TextStyle(fontSize: 15),
  //                       ))),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Divider(
  //                 thickness: 2,
  //                 color: Colors.grey,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  //                     child: Column(
  //                       children: [
  //                         RawMaterialButton(
  //                           onPressed: () {
  //                             print("kakao 1");
  //                             // kakato test
  //                             // 일단 주석처리 detail 잡아야함
  //                             KakaoShareManager()
  //                                 .isKakaotalkInstalled()
  //                                 .then((installed) {
  //                               if (installed) {
  //                                 print("kakao success");
  //                                 KakaoShareManager()
  //                                     .shareMyCode(widget.product);
  //                               } else {
  //                                 print("kakao error");
  //                                 // show alert
  //                               }
  //                             });
  //                           },
  //                           constraints:
  //                               BoxConstraints(minHeight: 80, minWidth: 80),
  //                           fillColor: Colors.white,
  //                           child: IconButton(
  //                             icon: Image.asset(
  //                                 'assets/images/free-icon-kakao-talk-2111466.png'),
  //                             onPressed: () {
  //                               print("kakao 2");
  //                               KakaoShareManager()
  //                                   .isKakaotalkInstalled()
  //                                   .then((installed) {
  //                                 if (installed) {
  //                                   print("kakao success");
  //                                   KakaoShareManager()
  //                                       .shareMyCode(widget.product);
  //                                 } else {
  //                                   print("kakao error");
  //                                   // show alert
  //                                 }
  //                               });
  //                             },
  //                           ),
  //                           shape: CircleBorder(),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
  //                           child:
  //                               Center(child: Container(child: Text("카카오톡"))),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  //                     child: Column(
  //                       children: [
  //                         RawMaterialButton(
  //                           onPressed: () {
  //                             print("URL");
  //                             // URL
  //                             // KakaoShareManager().getDynamicLink("abcd",snapshot,_imageItem[0]);
  //                           },
  //                           constraints:
  //                               BoxConstraints(minHeight: 80, minWidth: 80),
  //                           fillColor: Colors.white,
  //                           child: IconButton(
  //                             icon: Image.asset(
  //                                 'assets/images/iconfinder_link_hyperlink_5402394.png'),
  //                             onPressed: () {
  //                               // KakaoShareManager().getDynamicLink("abcd",snapshot,_imageItem[0]);
  //                             },
  //                           ),
  //                           shape: CircleBorder(),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
  //                           child: Center(child: Container(child: Text("URL"))),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    Widget getUserProducts() {
      var _size = MediaQuery.of(context).size;
      final double _itemHeight = (_size.height - kToolbarHeight - 24) / 3.0;
      final double _itemWidth = _size.width / 2;

      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('uid', isEqualTo: widget.product.uid)
            .where('bumptime', isNotEqualTo: widget.product.bumptime)
            .where('deleted', isEqualTo: false)
            .where('hide', isEqualTo: false)
            .orderBy('bumptime', descending: true)
            .limit(4)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('상품을 불러오지 못했습니다.');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              if (snapshot.data.docs.isEmpty) {
                return Container();
              }
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '판매자의 다른 상품',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         Consumer<UserProductProvider>(
                          //       builder: (context, userProductProvider, _) =>
                          //           UserProductWidget(
                          //         userProductProvider: userProductProvider,
                          //         uid: _product.uid!,
                          //       ),
                          //     ),
                          //   ),
                          // );
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              '더보기',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF666666),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: 20,
                              color: Color(0xFF999999),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.size,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: _itemWidth > _itemHeight
                          ? (_itemHeight / _itemWidth)
                          : (_itemWidth / _itemHeight),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return ProductItem(
                          product: Product.fromJson(
                              snapshot.data.docs[index].data(),
                              snapshot.data.docs[index].id)
                          // Product(
                          //   firestoreid: snapshot.data!.docs[index].id,
                          //   uid: snapshot.data!.docs[index].data()!['uid'],
                          //   title: snapshot.data!.docs[index].data()!['title'],
                          //   category:
                          //       snapshot.data!.docs[index].data()!['category'],
                          //   price: snapshot.data!.docs[index].data()!['price'],
                          //   images: snapshot.data!.docs[index].data()!['images'],
                          //   bumptime: snapshot.data!.docs[index]
                          //       .data()!['bumptime']
                          //       .toDate(),
                          //   favoriteuserlist: snapshot.data!.docs[index]
                          //       .data()!['favoriteuserlist'],
                          // ),
                          );
                    },
                  ),
                ],
              );
          }
        },
      );
    }

    Widget renderBody() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              child: Swiper(
                onTap: (index) {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ImageFullViewerWidget(
                  //         galleryItems: _imageItem,
                  //         index: index,
                  //       ),
                  //     ));
                },
                loop: widget.product.images.length == 1 ? false : true,
                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    activeColor: Colors.pink,
                    color: Colors.grey,
                  ),
                ),
                itemCount: widget.product.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return CachedNetworkImage(
                    imageUrl: widget.product.images[index],
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error), // 로딩 오류 시 이미지
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _priceEditingController,
                    enableInteractiveSelection: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.product.title}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.local_offer,
                        color: Colors.grey,
                        size: 17,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                      ),
                      Text("${widget.product.category}"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                      ),
                      Text(
                          "${TimeUtil.timeAgo(date: widget.product.bumptime)}"),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                      ),
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                      ),
                      Text(
                          "${widget.product.views == null ? 0 : widget.product.views.length}"),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                      ),
                      Container(
                        width: 30,
                        child: TextField(
                          controller: _favoriteTextController,
                          enableInteractiveSelection: false,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(minHeight: 100),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${widget.product.explain}",
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(
                    height: 80,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ProfileWidget(
                        //             uid: _product.uid!,
                        //           )),
                        // );
                      },
                      child: Row(
                        children: <Widget>[
                          // Container(
                          //   height: 50,
                          //   width: 50,
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //         image: AssetImage('images/profile.png'),
                          //         fit: BoxFit.cover),
                          //     shape: BoxShape.circle,
                          //   ),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          // getUserName(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  getUserProducts(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget setFavorite() {
      bool chk = widget.product.favoriteuserlist == null ||
          widget.product
                  .favoriteuserlist[googleSignIn.currentUser.id.toString()] ==
              null;

      return StreamBuilder<bool>(
        stream: _streamController.stream,
        initialData: chk,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return GestureDetector(
            onTap: () {
              if (_isRunning == false) {
                _isRunning = true;
                if (snapshot.data) {
                  FavoriteFirebaseApi.insertFavorite(
                      widget.product.firestoreid);
                  _streamController.sink.add(false);
                  FavoriteAnimation().showFavoriteDialog(context);
                  _favoriteTextController.text =
                      (int.parse(_favoriteTextController.text) + 1).toString();
                } else {
                  FavoriteFirebaseApi.deleteFavorite(
                      widget.product.firestoreid);
                  _streamController.sink.add(true);
                  _favoriteTextController.text =
                      (int.parse(_favoriteTextController.text) - 1).toString();
                }
              }
              _isRunning = false;
            },
            child: Icon(
              snapshot.data ? Icons.favorite_border : Icons.favorite,
              color: Colors.pink,
            ),
          );
        },
      );

      // return StreamBuilder<QuerySnapshot>(
      //     stream: FirebaseFirestore.instance
      //         .collection("users")
      //         .doc(FirebaseApi.getId())
      //         .collection("favorites")
      //         .where("productid", isEqualTo: this.widget.docId)
      //         .snapshots(),
      //     builder:
      //         (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.waiting:
      //           return Container();
      //         default:
      //           bool chk = snapshot.data!.docs.length == 0 ? false : true;
      //           return GestureDetector(
      //             onTap: () {
      //               int favorites =
      //                   int.tryParse(_favoriteTextController!.text)!;

      //               if (!chk) {
      //                 FavoriteApi.insertFavorite(this.widget.docId);
      //                 FavoriteAnimation().showFavoriteDialog(context);
      //                 favorites++;
      //               } else {
      //                 FavoriteApi.deleteFavorite(
      //                     snapshot.data!.docs[0].id, this.widget.docId);
      //                 favorites--;
      //               }
      //               _favoriteTextController!.text = (favorites).toString();
      //             },
      //             child: Icon(
      //               !chk ? Icons.favorite_border : Icons.favorite,
      //               color: Colors.pink,
      //             ),
      //           );
      //       }
      //     });
    }

    Widget bottomChatWidget() {
      return Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.pink,
              textStyle: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // NotificationManager.navigateToChattingRoom(
              //   context,
              //   FirebaseApi.getId(),
              //   this._product.uid!,
              //   this._product.firestoreid,
              // );
            },
            child: Text('채팅'),
          ),
        ),
      );
    }

    Widget bottomNavigator() {
      return SizedBox(
        height: 70,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black87,
                width: 0.1,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.black87,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: setFavorite(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  "${widget.product.price}원",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: Container()),
              if (widget.product.uid != googleSignIn.currentUser.id.toString())
                bottomChatWidget(),
            ],
          ),
        ),
      );
    }

    // sunghun kakao test
    // Widget testShareButton(Product product) {
    //   return new IconButton(
    //     icon: new Icon(Icons.share),
    //     onPressed: () => {
    //       print("share"),
    //       _testModalBottomSheet(context, product),
    //     },
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '상세보기',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          // testShareButton(widget.product),
          // shareButton(snapshot),
          // popupMenuButton(),
        ],
      ),
      body: renderBody(),
      bottomNavigationBar: bottomNavigator(),
    );
  }
}
