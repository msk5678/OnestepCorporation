import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onestep_rezero/animation/favoriteAnimation.dart';
import 'package:onestep_rezero/chat/controller/realtimeNavigationManager.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';
import 'package:onestep_rezero/favorite/utils/favoriteFirebaseApi.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/pages/productBump.dart';
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
  bool _appbarColor = false;
  final ScrollController _customScrollViewScrollController = ScrollController();
  final StreamController<bool> _customScrollViewStreamController =
      StreamController<bool>();
  final StreamController<bool> _streamController = StreamController<bool>();

  TextEditingController _favoriteTextController;
  TextEditingController _priceEditingController;

  @override
  void initState() {
    _customScrollViewScrollController.addListener(scrollListener);
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
    _customScrollViewStreamController.close();
    _customScrollViewScrollController.dispose();
    _streamController.close();
    super.dispose();
  }

  // share
  void _shareModalBottomSheet(context, Product product) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .30,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.clear,
                      //     size: 20,
                      //   ),
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      Container(
                          child: Text(
                        "공유하기",
                        style: TextStyle(fontSize: 15),
                      )),
                    ],
                  ),
                ),
                // Divider(
                //   thickness: 1,
                //   color: Colors.grey,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              // print("kakao 1");
                              KakaoShareManager()
                                  .isKakaotalkInstalled()
                                  .then((installed) {
                                if (installed) {
                                  print("kakao success");
                                  KakaoShareManager()
                                      .shareMyCode(widget.product);
                                } else {
                                  print("kakao error");
                                  // show alert
                                }
                              });
                            },
                            constraints:
                                BoxConstraints(minHeight: 80, minWidth: 80),
                            fillColor: Colors.white,
                            child: IconButton(
                              icon: Image.asset('images/onestep icon.png'),
                              onPressed: () {
                                // print("kakao 2");
                                KakaoShareManager()
                                    .isKakaotalkInstalled()
                                    .then((installed) {
                                  if (installed) {
                                    print("kakao success");
                                    KakaoShareManager()
                                        .shareMyCode(widget.product);
                                  } else {
                                    print("kakao error");
                                    // show alert
                                  }
                                });
                              },
                            ),
                            shape: CircleBorder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child:
                                Center(child: Container(child: Text("카카오톡"))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              print("URL");
                              // URL
                              KakaoShareManager()
                                  .getDynamicLink(widget.product);
                            },
                            constraints:
                                BoxConstraints(minHeight: 80, minWidth: 80),
                            fillColor: Colors.white,
                            child: IconButton(
                              icon: Image.asset('images/onestep icon.png'),
                              onPressed: () {
                                KakaoShareManager()
                                    .getDynamicLink(widget.product);
                              },
                            ),
                            shape: CircleBorder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Center(child: Container(child: Text("URL"))),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void scrollListener() {
    if (_customScrollViewScrollController.position.pixels <
        MediaQuery.of(context).size.width - 60) {
      if (_appbarColor) {
        _appbarColor = false;
        _customScrollViewStreamController.sink.add(false);
      }
    } else {
      if (!_appbarColor) {
        _appbarColor = true;
        _customScrollViewStreamController.sink.add(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getUserProfile() {
      return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.product.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text("");
            default:
              return Row(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: snapshot.data['photoUrl'],
                    imageBuilder: (context, imageProvider) => Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    snapshot.data['nickName'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              );
          }
        },
      );
    }

    Widget getUserProducts() {
      var _size = MediaQuery.of(context).size;
      final double _itemHeight = (_size.height - kToolbarHeight - 24) / 3.0;
      final double _itemWidth = _size.width / 2;

      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('uid', isEqualTo: widget.product.uid)
            .where('bumptime',
                isNotEqualTo: widget.product.bumptime.microsecondsSinceEpoch)
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
                          // 해당 사용자 판매상품 넘어가기
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
                              snapshot.data.docs[index].id));
                    },
                  ),
                ],
              );
          }
        },
      );
    }

    Widget renderBody() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                    Text("${TimeUtil.timeAgo(date: widget.product.bumptime)}"),
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
                    child: getUserProfile(),
                  ),
                ),
                SizedBox(height: 20),
                getUserProducts(),
              ],
            ),
          ),
        ],
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
            onPressed: () {},
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
    Widget testShareButton(Product product) {
      return new IconButton(
        icon: new Icon(Icons.share),
        onPressed: () => {
          _shareModalBottomSheet(context, product),
        },
      );
    }

    void handleClick(String value) {
      switch (value) {
        case '새로고침':
          break;
        case '신고하기':
          break;
        case '수정하기':
          // Navigator.of(context)
          //     .push(
          //   MaterialPageRoute(
          //     builder: (context) => ClothModifyWidget(product: this._product),
          //   ),
          // )
          //     .then((value) {
          //   if (value == "OK") {
          //     setState(() {});
          //   }
          // });
          break;
        case '공유하기':
          print("여기?");
          break;
        case '끌올하기':
          if (DateTime.now().difference(widget.product.bumptime).inHours >= 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductBump(product: widget.product),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              content: Text("물품을 등록하고 1시간 뒤에 끌올할 수 있어요."),
            ));
          }

          break;
        case '숨김':
          // 확인 취소 다이얼로그 띄우기
          FirebaseFirestore.instance
              .collection("products")
              .doc(googleSignIn.currentUser.id)
              .update({'hide': true});
          break;
        case '삭제':
          // 확인 취소 다이얼로그 띄우기
          FirebaseFirestore.instance
              .collection("products")
              .doc(googleSignIn.currentUser.id)
              .update({'deleted': true});
          break;
      }
    }

    Widget popupMenuButton(bool color) {
      return PopupMenuButton<String>(
        color: color ? Colors.black : Colors.white,
        onSelected: handleClick,
        itemBuilder: (BuildContext context) {
          var menuItem = <String>[];

          if (googleSignIn.currentUser.id == widget.product.uid)
            menuItem.addAll({'끌올하기', '수정하기', '숨김', '삭제'});
          else {
            menuItem.addAll({'새로고침', '신고하기', '공유하기'});
          }

          return menuItem.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        Size _size = MediaQuery.of(context).size;
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _customScrollViewScrollController,
              slivers: [
                StreamBuilder(
                    initialData: false,
                    stream: _customScrollViewStreamController.stream,
                    builder: (context, snapshot) {
                      return SliverAppBar(
                        iconTheme: IconThemeData(
                          color: snapshot.data
                              ? Colors.black
                              : Colors.white, //change your color here
                        ),
                        title: Text(
                          widget.product.title,
                          style: TextStyle(
                              color: snapshot.data
                                  ? Colors.black
                                  : Colors.transparent),
                        ),
                        backgroundColor: Colors.white,
                        primary: true,
                        pinned: true,
                        expandedHeight: _size.width,
                        actions: [
                          // share button
                          testShareButton(widget.product),
                          popupMenuButton(snapshot.data),
                        ],
                        flexibleSpace: Stack(
                          children: [
                            FlexibleSpaceBar(
                              background: SizedBox(
                                height: _size.width,
                                width: _size.width,
                                child: Swiper(
                                  onTap: (index) {
                                    // image full viewer
                                  },
                                  loop: widget.product.images.length == 1
                                      ? false
                                      : true,
                                  pagination: SwiperPagination(
                                    alignment: Alignment.bottomCenter,
                                    builder: DotSwiperPaginationBuilder(
                                      activeColor: Colors.pink,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  itemCount: widget.product.images.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CachedNetworkImage(
                                      imageUrl: widget.product.images[index],
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error), // 로딩 오류 시 이미지
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              child: FlexibleSpaceBar(
                                collapseMode: CollapseMode.none,
                                background: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black38,
                                        Colors.transparent
                                      ],
                                      stops: [0.0, 0.15],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                SliverToBoxAdapter(
                  child: renderBody(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: bottomNavigator(),
        );
      },
    );
  }
}
