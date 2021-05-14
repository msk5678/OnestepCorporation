import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onestep_rezero/animation/favoriteAnimation.dart';
import 'package:onestep_rezero/favorite/utils/favoriteFirebaseApi.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/notification/realtime/realtimeNavigationManager.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/pages/productBump.dart';
import 'package:onestep_rezero/product/pages/productEdit.dart';
import 'package:onestep_rezero/product/widgets/detail/imagesFullViewer.dart';
import 'package:onestep_rezero/product/widgets/public/productItem.dart';
import 'package:onestep_rezero/timeUtil.dart';

class ProductDetailBody extends StatefulWidget {
  final Product product;
  const ProductDetailBody({Key key, @required this.product}) : super(key: key);

  @override
  _ProductDetailBodyState createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody>
    with SingleTickerProviderStateMixin {
  Widget getUserProfile() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("user")
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
                  imageUrl: snapshot.data['imageUrl'],
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
          .collection("university")
          .doc(currentUserModel.university)
          .collection('product')
          .where('uid', isEqualTo: widget.product.uid)
          .where('bumpTime',
              isNotEqualTo: widget.product.bumpTime.microsecondsSinceEpoch)
          .where('deleted', isEqualTo: false)
          .where('hide', isEqualTo: false)
          .orderBy('bumpTime', descending: true)
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
                  Text("${TimeUtil.timeAgo(date: widget.product.bumpTime)}"),
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
    bool chk = widget.product.favoriteUserList == null ||
        widget.product
                .favoriteUserList[googleSignIn.currentUser.id.toString()] ==
            null;

    return StreamBuilder<bool>(
      stream: _favoriteStreamController.stream,
      initialData: chk,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return GestureDetector(
          onTap: () {
            if (_isRunning == false) {
              _isRunning = true;
              if (snapshot.data) {
                FavoriteFirebaseApi.insertFavorite(widget.product.firestoreid);
                _favoriteStreamController.sink.add(false);
                FavoriteAnimation().showFavoriteDialog(context);
                _favoriteTextController.text =
                    (int.parse(_favoriteTextController.text) + 1).toString();
              } else {
                FavoriteFirebaseApi.deleteFavorite(widget.product.firestoreid);
                _favoriteStreamController.sink.add(true);
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
          onPressed: () {
            RealTimeChatNavigationManager.navigateToRealTimeChattingRoom(
                context,
                googleSignIn.currentUser.id.toString(),
                widget.product.uid,
                widget.product.firestoreid);
          },
          child: Text('채팅'),
        ),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case '새로고침':
        break;
      case '신고하기':
        break;
      case '수정하기':
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => ProductEdit(product: widget.product),
          ),
        )
            .then((value) {
          if (value == "OK") {
            setState(() {});
          }
        });
        break;
      case '끌올하기':
        if (DateTime.now().difference(widget.product.bumpTime).inHours >= 1) {
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
            .collection("product")
            .doc(googleSignIn.currentUser.id)
            .update({'hide': true});
        break;
      case '삭제':
        // 확인 취소 다이얼로그 띄우기
        FirebaseFirestore.instance
            .collection("product")
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
          menuItem.addAll({'새로고침', '신고하기'});
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
  // -----------------------------------------------

  double locationAlpha;
  Animation _colorTween;

  bool _isRunning;
  // bool _appbarColor = false;

  final ScrollController _customScrollViewScrollController = ScrollController();
  final StreamController<int> _customScrollViewStreamController =
      StreamController<int>();
  AnimationController _animationController;

  final StreamController<bool> _favoriteStreamController =
      StreamController<bool>();

  TextEditingController _favoriteTextController;
  TextEditingController _priceEditingController;

  @override
  void initState() {
    locationAlpha = 0;
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);

    _customScrollViewScrollController.addListener(scrollListener);
    _favoriteTextController = new TextEditingController(
        text: widget.product.favoriteUserList == null
            ? "0"
            : widget.product.favoriteUserList.length.toString());
    _priceEditingController =
        new TextEditingController(text: widget.product.price);
    _isRunning = false;
    super.initState();
  }

  void scrollListener() {
    if (_customScrollViewScrollController.offset > 255) {
      locationAlpha = 255;
      _customScrollViewStreamController.sink.add(255);
    } else {
      locationAlpha = _customScrollViewScrollController.offset;
      _customScrollViewStreamController.sink
          .add(_customScrollViewScrollController.offset.toInt());
    }

    _animationController.value = locationAlpha / 255;
  }

  @override
  void dispose() {
    _customScrollViewStreamController.close();
    _customScrollViewScrollController.dispose();
    _favoriteStreamController.close();
    super.dispose();
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Icon(icon, color: _colorTween.value));
  }

  PreferredSizeWidget _appbarWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: StreamBuilder(
        stream: _customScrollViewStreamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          int alpha = snapshot.data;
          print(alpha);
          return AppBar(
            title: Text(
              "${widget.product.title}",
              style: TextStyle(color: Colors.black.withAlpha(alpha)),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: _makeIcon(Icons.arrow_back),
            ),
            backgroundColor: Colors.white.withAlpha(alpha),
            elevation: 0,
            actions: [
              IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
              IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
            ],
          );
        },
      ),
    );
  }

  Widget _makeSliderImage() {
    Size _size = MediaQuery.of(context).size;

    return Container(
      height: _size.width * 0.8,
      child: Stack(
        children: [
          Hero(
            tag: widget.product.firestoreid,
            child: Swiper(
              onTap: (index) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagesFullViewer(
                        imagesUrl: widget.product.imagesUrl, index: index),
                  ),
                );
              },
              loop: widget.product.imagesUrl.length == 1 ? false : true,
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                  activeColor: Colors.pink,
                  color: Colors.grey,
                ),
              ),
              itemCount: widget.product.imagesUrl.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imagesUrl[index],
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error), // 로딩 오류 시 이미지
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentDetail() {
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
                  Text("${TimeUtil.timeAgo(date: widget.product.bumpTime)}"),
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
              // SizedBox(height: 10),
              // Divider(),
              // SizedBox(
              //   height: 80,
              //   child: GestureDetector(
              //     onTap: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(
              //       //       builder: (context) => ProfileWidget(
              //       //             uid: _product.uid!,
              //       //           )),
              //       // );
              //     },
              //     child: getUserProfile(),
              //   ),
              // ),
              // SizedBox(height: 20),
              // getUserProducts(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sellerProfile() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("user")
          .doc(widget.product.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: snapshot.data['imageUrl'],
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
                  SizedBox(width: 10),
                  Text(
                    snapshot.data['nickName'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
        }
      },
    );
  }

  Widget _sellerInfoAndOtherProduct() {
    return Column(children: <Widget>[
      _sellerProfile(),
      _sellerOtherProduct(),
    ]);
  }

  Widget _sellerOtherProduct() {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 3.0;
    final double _itemWidth = _size.width / 2;

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("university")
          .doc(currentUserModel.university)
          .collection('product')
          .where('uid', isEqualTo: widget.product.uid)
          .where('bumpTime',
              isNotEqualTo: widget.product.bumpTime.microsecondsSinceEpoch)
          .where('deleted', isEqualTo: false)
          .where('hide', isEqualTo: false)
          .orderBy('bumpTime', descending: true)
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
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "판매자의 다른 상품",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "모두보기",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.size,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: _itemWidth > _itemHeight
                        ? (_itemHeight / _itemWidth)
                        : (_itemWidth / _itemHeight),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 7,
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

  Widget _line() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
        controller: _customScrollViewScrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _makeSliderImage(),
                _line(),
                _contentDetail(),
                _line(),
                _sellerInfoAndOtherProduct(),
              ],
            ),
          ),
        ]);
  }

  Widget _bottomBarWidget() {
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _appbarWidget(),
          body: _bodyWidget(),
          bottomNavigationBar: _bottomBarWidget(),
        );
      },
    );

    // return LayoutBuilder(
    //   builder: (context, constraint) {
    //     Size _size = MediaQuery.of(context).size;

    //     return Scaffold(
    //       body: SafeArea(
    //         bottom: false,
    //         child: CustomScrollView(
    //           controller: _customScrollViewScrollController,
    //           slivers: [
    //             StreamBuilder(
    //                 initialData: false,
    //                 stream: _customScrollViewStreamController.stream,
    //                 builder: (context, snapshot) {
    //                   return SliverAppBar(
    //                     iconTheme: IconThemeData(
    //                       color: snapshot.data
    //                           ? Colors.black
    //                           : Colors.white, //change your color here
    //                     ),
    //                     title: Text(
    //                       widget.product.title,
    //                       style: TextStyle(
    //                           color: snapshot.data
    //                               ? Colors.black
    //                               : Colors.transparent),
    //                     ),
    //                     backgroundColor: Colors.white,
    //                     primary: true,
    //                     pinned: true,
    //                     expandedHeight: _size.width,
    //                     actions: [
    //                       //     // shareButton(snapshot),
    //                       popupMenuButton(snapshot.data),
    //                     ],
    //                     flexibleSpace: Stack(
    //                       children: [
    //                         FlexibleSpaceBar(
    //                           background: SizedBox(
    //                             height: _size.width,
    //                             width: _size.width,
    //                             child: Swiper(
    //                               onTap: (index) {
    //                                 Navigator.push(
    //                                   context,
    //                                   MaterialPageRoute(
    //                                     builder: (context) => ImagesFullViewer(
    //                                         imagesUrl: widget.product.imagesUrl,
    //                                         index: index),
    //                                   ),
    //                                 );
    //                               },
    //                               loop: widget.product.imagesUrl.length == 1
    //                                   ? false
    //                                   : true,
    //                               pagination: SwiperPagination(
    //                                 alignment: Alignment.bottomCenter,
    //                                 builder: DotSwiperPaginationBuilder(
    //                                   activeColor: Colors.pink,
    //                                   color: Colors.grey,
    //                                 ),
    //                               ),
    //                               itemCount: widget.product.imagesUrl.length,
    //                               itemBuilder:
    //                                   (BuildContext context, int index) {
    //                                 return Container(
    //                                   child: Hero(
    //                                     tag: widget.product.firestoreid,
    //                                     child: CachedNetworkImage(
    //                                       imageUrl:
    //                                           widget.product.imagesUrl[index],
    //                                       width:
    //                                           MediaQuery.of(context).size.width,
    //                                       height: MediaQuery.of(context)
    //                                           .size
    //                                           .height,
    //                                       errorWidget: (context, url, error) =>
    //                                           Icon(Icons.error), // 로딩 오류 시 이미지
    //                                       fit: BoxFit.cover,
    //                                     ),
    //                                   ),
    //                                 );
    //                               },
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 70,
    //                           child: FlexibleSpaceBar(
    //                             collapseMode: CollapseMode.none,
    //                             background: Container(
    //                               decoration: BoxDecoration(
    //                                 gradient: LinearGradient(
    //                                   begin: Alignment.topCenter,
    //                                   end: Alignment.bottomCenter,
    //                                   colors: [
    //                                     Colors.black38,
    //                                     Colors.transparent
    //                                   ],
    //                                   stops: [0.0, 0.15],
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   );
    //                 }),
    //             SliverToBoxAdapter(
    //               child: renderBody(),
    //             ),
    //           ],
    //         ),
    //       ),
    //       // bottomNavigationBar: bottomNavigator(),
    //     );
    //   },
    // );
  }
}
