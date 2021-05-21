import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/animation/favoriteAnimation.dart';
import 'package:onestep_rezero/favorite/utils/favoriteFirebaseApi.dart';
import 'package:onestep_rezero/main.dart';
// import 'package:onestep_rezero/notification/realtime/realtimeNavigationManager.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/widgets/public/productItem.dart';

class TestProductDetailBody extends StatefulWidget {
  final Product product;
  TestProductDetailBody({Key key, this.product}) : super(key: key);

  @override
  _TestProductDetailBodyState createState() => _TestProductDetailBodyState();
}

class _TestProductDetailBodyState extends State<TestProductDetailBody>
    with SingleTickerProviderStateMixin {
  Size size;
  int _current;
  double locationAlpha;
  Animation _colorTween;
  ScrollController _scollController = ScrollController();
  AnimationController _animationController;
  final StreamController<bool> _streamController = StreamController<bool>();
  TextEditingController _favoriteTextController;

  bool _isRunning;

  Future _userProfileFuture;
  Future _userProductListFuture;

  final AsyncMemoizer _userProfileMemoizer = AsyncMemoizer();
  final AsyncMemoizer _userProductListMemoizer = AsyncMemoizer();

  _userProfilefetchData() {
    return this._userProfileMemoizer.runOnce(() async {
      await Future.delayed(Duration(milliseconds: 1500));
      return FirebaseFirestore.instance
          .collection("user")
          .doc(widget.product.uid)
          .get();
    });
  }

  _userProductListfetchData() {
    return this._userProductListMemoizer.runOnce(() async {
      await Future.delayed(Duration(milliseconds: 1500));
      return FirebaseFirestore.instance
          .collection("university")
          .doc(currentUserModel.university)
          .collection('product')
          .where('uid', isEqualTo: widget.product.uid)
          .where('bumpTime', isNotEqualTo: widget.product.bumpTime)
          .where('deleted', isEqualTo: false)
          .where('hide', isEqualTo: false)
          .orderBy('bumpTime', descending: true)
          .limit(4)
          .get();
    });
  }

  @override
  void initState() {
    _userProfileFuture = _userProfilefetchData();
    _userProductListFuture = _userProductListfetchData();
    _current = 0;
    locationAlpha = 0;

    _favoriteTextController = new TextEditingController(
        text: widget.product.favoriteUserList.length.toString());

    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);

    _scollController.addListener(() {
      print(_scollController.offset);
      setState(() {
        if (_scollController.offset > 100) {
          locationAlpha = 255;
        } else {
          locationAlpha = _scollController.offset;
        }

        _animationController.value = locationAlpha / 255;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Icon(icon, color: _colorTween.value));
  }

  Widget _appbarWidget() {
    return AppBar(
      title: Text(
        "${widget.product.title}",
        style: TextStyle(color: Colors.black.withAlpha(locationAlpha.toInt())),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: _makeIcon(Icons.arrow_back),
      ),
      backgroundColor: Colors.white.withAlpha(locationAlpha.toInt()),
      elevation: 0,
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Container(
      height: size.width * 0.8,
      child: Stack(
        children: [
          Hero(
            tag: widget.product.firestoreid,
            child: CarouselSlider(
              options: CarouselOptions(
                  height: size.width * 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: widget.product.imagesUrl.map((image) {
                return Container(
                  width: size.width,
                  height: size.width,
                  color: Colors.red,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error), // 로딩 오류 시 이미지
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.product.imagesUrl.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _sellerSimpleInfo() {
    return FutureBuilder(
      future: _userProfileFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("유저정보를 불러오지 못했습니다.");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text("");
          default:
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
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
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "닉네임",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold, fontSize: 16),
                  //     ),
                  //     Text("제주시 도담동"),
                  //   ],
                  // ),
                  // Expanded(
                  //   child: ManorTemperature(manorTemp: 37.3),
                  // )
                ],
              ),
            );
        }
      },
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.product.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "디지털/가전 ∙ 22시간 전",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "선물받은 새상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.",
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            "채팅 3 ∙ 관심 17 ∙ 조회 295",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "판매자의 판매 상품",
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
    );
  }

  Widget _otherCellProducts() {
    var _size = MediaQuery.of(context).size;
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 3.0;
    final double _itemWidth = _size.width / 2;

    return FutureBuilder(
      future: _userProductListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return SliverToBoxAdapter(child: Text('상품을 불러오지 못했습니다.'));
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SliverToBoxAdapter(child: Container());
          default:
            if (snapshot.data.docs.isEmpty) {
              return SliverToBoxAdapter(child: Container());
            } else {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: _itemWidth > _itemHeight
                          ? (_itemHeight / _itemWidth)
                          : (_itemWidth / _itemHeight),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ProductItem(
                          product: Product.fromJson(
                              snapshot.data.docs[index].data(),
                              snapshot.data.docs[index].id));
                    },
                    childCount: snapshot.data.size,
                  ),
                ),
              );

              // return GridView.builder(
              //   shrinkWrap: true,
              //   itemCount: snapshot.data.size,
              //   physics: NeverScrollableScrollPhysics(),
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     childAspectRatio: _itemWidth > _itemHeight
              //         ? (_itemHeight / _itemWidth)
              //         : (_itemWidth / _itemHeight),
              //     crossAxisCount: 2,
              //     mainAxisSpacing: 10,
              //     crossAxisSpacing: 10,
              //   ),
              //   itemBuilder: (context, index) {
              //     return ProductItem(
              //         product: Product.fromJson(
              //             snapshot.data.docs[index].data(),
              //             snapshot.data.docs[index].id));
              //   },
              // );
            }
        }
      },
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _scollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _makeSliderImage(),
              _sellerSimpleInfo(),
              _line(),
              _contentDetail(),
              _line(),
              _otherCellContents(),
            ],
          ),
        ),
        _otherCellProducts(),
      ],
    );
  }

  Widget setFavorite() {
    bool chk = widget.product.favoriteUserList == null ||
        widget.product.favoriteUserList[googleSignIn.currentUser.id] == null;

    return StreamBuilder<bool>(
      stream: _streamController.stream,
      initialData: chk,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return GestureDetector(
          onTap: () {
            if (_isRunning == false) {
              _isRunning = true;
              if (snapshot.data) {
                FavoriteFirebaseApi.insertFavorite(widget.product.firestoreid);
                _streamController.sink.add(false);
                FavoriteAnimation().showFavoriteDialog(context);
                _favoriteTextController.text =
                    (int.parse(_favoriteTextController.text) + 1).toString();
              } else {
                FavoriteFirebaseApi.deleteFavorite(widget.product.firestoreid);
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

  Widget _bottomChatWidget() {
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
            // RealTimeChatNavigationManager.navigateToRealTimeChattingRoom(
            //     context,
            //     googleSignIn.currentUser.id.toString(),
            //     widget.product.uid,
            //     widget.product.firestoreid);
          },
          child: Text('채팅'),
        ),
      ),
    );
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
              _bottomChatWidget(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
