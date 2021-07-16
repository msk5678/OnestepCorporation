import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/favorite/animation/favoriteAnimation.dart';
import 'package:onestep_rezero/favorite/utils/favoriteFirebaseApi.dart';
import 'package:onestep_rezero/favorite/widgets/favoriteMainBody.dart';
import 'package:onestep_rezero/myinfo/widgets/myProduct/myCompletedProductBody.dart';
import 'package:onestep_rezero/myinfo/widgets/myProduct/myHoldProductBody.dart';
import 'package:onestep_rezero/myinfo/widgets/myProduct/mySaleProductBody.dart';
import 'package:onestep_rezero/myinfo/widgets/myProduct/myTradingProductBody.dart';
import 'package:onestep_rezero/product/pages/userProfile.dart';
import 'package:onestep_rezero/product/widgets/public/productKakaoShareManager.dart';
import 'package:onestep_rezero/report/pages/Deal/productReport/reportProductPage.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/chat/navigator/chatNavigationManager.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/pages/product/productBump.dart';
import 'package:onestep_rezero/product/pages/product/productDetail.dart';
import 'package:onestep_rezero/product/pages/product/productEdit.dart';
import 'package:onestep_rezero/product/widgets/detail/imagesFullViewer.dart';
import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:onestep_rezero/product/widgets/public/productItem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/utils/floatingSnackBar.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialog.dart';
import 'package:onestep_rezero/utils/timeUtil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailBody extends StatefulWidget {
  final Product product;
  const ProductDetailBody({Key key, @required this.product}) : super(key: key);

  @override
  _ProductDetailBodyState createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody>
    with SingleTickerProviderStateMixin {
  // Appbar
  double _locationAlpha;
  Animation _colorTween;
  AnimationController _animationController;

  // BottomModal
  int modalState;

  // Favorite
  bool _isRunning;

  final ScrollController _customScrollViewScrollController = ScrollController();
  final ScrollController _bottomListviewScrollController = ScrollController();

  final StreamController _imageStreamController = BehaviorSubject();
  final StreamController _bottomListviewStreamController = BehaviorSubject();
  final StreamController<int> _customScrollViewStreamController =
      StreamController<int>();
  final StreamController<bool> _favoriteStreamController =
      StreamController<bool>();

  TextEditingController _favoriteTextController;
  TextEditingController _priceEditingController;

  @override
  void initState() {
    _imageStreamInit();
    _appbarAnimationInit();
    _componentInit();

    _customScrollViewScrollController.addListener(scrollListener);
    _bottomListviewScrollController.addListener(bottomListviewScrollListener);

    _isRunning = false;
    super.initState();
  }

  void _componentInit() {
    _favoriteTextController = new TextEditingController(
        text: widget.product.favoriteUserList == null
            ? "0"
            : widget.product.favoriteUserList.length.toString());
    _priceEditingController =
        new TextEditingController(text: widget.product.price + "원");
  }

  void _appbarAnimationInit() {
    _locationAlpha = 0;
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
  }

  void _imageStreamInit() {
    if (widget.product.trading) {
      _imageStreamController.sink.add(1);
    } else if (widget.product.hold) {
      _imageStreamController.sink.add(2);
    } else if (widget.product.completed) {
      _imageStreamController.sink.add(3);
    } else {
      _imageStreamController.sink.add(0);
    }
  }

  void scrollListener() {
    if (_customScrollViewScrollController.offset > 255) {
      _locationAlpha = 255;
      _customScrollViewStreamController.sink.add(255);
    } else {
      _locationAlpha = _customScrollViewScrollController.offset;
      _customScrollViewStreamController.sink
          .add(_customScrollViewScrollController.offset.toInt());
    }

    _animationController.value = _locationAlpha / 255;
  }

  void bottomListviewScrollListener() {
    if (_bottomListviewScrollController.offset >=
        _bottomListviewScrollController.position.maxScrollExtent - 50) {
      _bottomListviewStreamController.sink.add(false);
    } else {
      _bottomListviewStreamController.sink.add(true);
    }
  }

  @override
  void dispose() {
    _customScrollViewStreamController.close();
    _customScrollViewScrollController.dispose();
    _imageStreamController.close();
    _favoriteStreamController.close();
    _bottomListviewStreamController.close();
    super.dispose();
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Icon(icon, color: _colorTween.value));
  }

  void handleClick(String value) {
    switch (value) {
      case '새로고침':
        break;
      case '신고하기':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReportProductPage(
                widget.product.firestoreid, widget.product.uid)));
        break;
      case '수정하기':
        break;
      case '끌올하기':
        break;
      case '숨김':
        // 확인 취소 다이얼로그 띄우기
        FirebaseFirestore.instance
            .collection("product")
            .doc(currentUserModel.uid)
            .update({'hold': true});
        break;
      case '삭제':
        // 확인 취소 다이얼로그 띄우기
        FirebaseFirestore.instance
            .collection("university")
            .doc(currentUserModel.university)
            .collection("product")
            .doc(widget.product.firestoreid)
            .update({'deleted': true});
        break;
    }
  }

  Widget popupMenuButton() {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => PopupMenuButton<String>(
        icon: Icon(Icons.adaptive.more, color: _colorTween.value),
        color: Colors.white,
        onSelected: handleClick,
        itemBuilder: (BuildContext context) {
          var menuItem = <String>['새로고침', '신고하기'];

          return menuItem.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    );
  }

  PreferredSizeWidget _appbarWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: StreamBuilder(
        stream: _customScrollViewStreamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          int alpha = snapshot.data;
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
              IconButton(
                  onPressed: () {
                    _shareModalBottomSheet(context, widget.product);
                  },
                  icon: _makeIcon(Icons.share)),
              if (currentUserModel.uid != widget.product.uid) popupMenuButton(),
            ],
          );
        },
      ),
    );
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
                  padding: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height / 25, 0, 0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
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
                              icon: Image.asset('images/kakao_icon_2.png'),
                              onPressed: () {
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
                            padding: EdgeInsets.fromLTRB(0,
                                MediaQuery.of(context).size.height / 50, 0, 0),
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
                              icon: Image.asset('images/url_icon.png'),
                              onPressed: () {
                                KakaoShareManager()
                                    .getDynamicLink(widget.product);
                              },
                            ),
                            shape: CircleBorder(),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0,
                                MediaQuery.of(context).size.height / 50, 0, 0),
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

  Widget _productState() {
    return StreamBuilder(
      stream: _imageStreamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        modalState = snapshot.data;
        if (snapshot.data >= 1) {
          return IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                        snapshot.data == 1
                            ? Icons.watch_later_outlined
                            : snapshot.data == 2
                                ? Icons.pending_outlined
                                : Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 50.sp),
                    SizedBox(height: 10.h),
                    Text(
                      snapshot.data == 1
                          ? "예약중"
                          : snapshot.data == 2
                              ? "판매보류"
                              : "판매완료",
                      style: TextStyle(color: Colors.white, fontSize: 28.sp),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _makeSliderImage() {
    Size _size = MediaQuery.of(context).size;
    double _height = _size.width * 1.1;
    return Container(
      height: _height,
      child: Stack(
        children: [
          Swiper(
            onTap: (index) async {
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
                activeColor: OnestepColors().mainColor,
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
          _productState(),
        ],
      ),
    );
  }

  Widget uploadTime() {
    if (widget.product.bumpTime == widget.product.updateTime &&
        widget.product.updateTime == widget.product.uploadTime) {
      // 업로드만 했을 경우
      return Text("${TimeUtil.timeAgo(date: widget.product.bumpTime)}");
    } else if (widget.product.bumpTime.microsecondsSinceEpoch >
        widget.product.updateTime.microsecondsSinceEpoch) {
      //  끌올했을 경우
      return Row(children: <Widget>[
        Text("끌올 ${TimeUtil.timeAgo(date: widget.product.bumpTime)}"),
      ]);
    } else {
      // 수정했을 경우
      return Row(children: <Widget>[
        Text("${TimeUtil.timeAgo(date: widget.product.uploadTime)} (수정됨)"),
      ]);
    }
  }

  Widget _contentDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.product.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              TextField(
                controller: _priceEditingController,
                enableInteractiveSelection: false,
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),

              SizedBox(height: 10.h),
              Row(
                children: <Widget>[
                  Image.asset('assets/icons/category/viewAll.png',
                      width: 17.w, height: 17.h),
                  Padding(
                    padding: EdgeInsets.only(right: 2.0.w),
                  ),
                  Text(widget.product.detailCategory == ""
                      ? "${widget.product.category}"
                      : "${widget.product.category} > ${widget.product.detailCategory}"),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: Colors.grey,
                    size: 15.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 2.0.w),
                  ),
                  uploadTime(),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0.w),
                  ),
                  Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                    size: 15.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 2.0.w),
                  ),
                  Text(
                      "${widget.product.views == null ? 0 : widget.product.views.length}"),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0.w),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.grey,
                    size: 15.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 2.0.w),
                  ),
                  Container(
                    width: 30.w,
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
              SizedBox(height: 10.h),
              Container(
                constraints: BoxConstraints(
                  minHeight: 100.h,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${widget.product.explain}",
                    style: TextStyle(height: 1.5.h),
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
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UserProfileMain(userData: snapshot.data)));
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: snapshot.data['imageUrl'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50.0.w,
                        height: 50.0.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      snapshot.data['nickName'],
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
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
    final double _itemHeight = (_size.height - kToolbarHeight - 24) / 2.7;
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
          .where('hold', isEqualTo: false)
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
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => MyProductMain(),
                              //   ),
                              // );
                            },
                            child: Text(
                              "모두보기",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: GridView.builder(
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
                ),
              ],
            );
        }
      },
    );
  }

  Widget _line() {
    return Container(
      height: 1.h,
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

  void stateChange(String type) {
    bool trading = 'trading' == type;
    bool hold = 'hold' == type;
    bool completed = 'completed' == type;

    int value = 0;
    if (trading)
      value = 1;
    else if (hold)
      value = 2;
    else if (completed) value = 3;

    FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .doc(widget.product.firestoreid)
        .update({
      "trading": trading,
      "hold": hold,
      "completed": completed
    }).whenComplete(() {
      _imageStreamController.sink.add(value);

      print(ModalRoute.of(context).settings.name);
      switch (ModalRoute.of(context).settings.name) {
        case "/":
          context.read(productMainService).updateState(
              widget.product.firestoreid, trading, hold, completed);
          break;
        case "MyProduct":
          switch (value) {
            case 0:
              context.read(myTradingProductProvider).fetchProducts();
              context.read(myCompletedProductProvider).fetchProducts();
              context.read(myHoldProductProvider).fetchProducts();
              break;
            case 1:
              context.read(mySaleProductProvider).fetchProducts();
              context.read(myCompletedProductProvider).fetchProducts();
              context.read(myHoldProductProvider).fetchProducts();
              break;
            case 2:
              context.read(mySaleProductProvider).fetchProducts();
              context.read(myTradingProductProvider).fetchProducts();
              context.read(myHoldProductProvider).fetchProducts();
              break;
            case 3:
              context.read(mySaleProductProvider).fetchProducts();
              context.read(myTradingProductProvider).fetchProducts();
              context.read(myCompletedProductProvider).fetchProducts();
              break;
          }
          break;
        case "Favorite":
          context.read(favoriteMainProvider).updateState(
              widget.product.firestoreid, trading, hold, completed);
          break;

        default:
          break;
      }

      Navigator.pop(context);
    }).onError((error, stackTrace) => null);
  }

  Future<dynamic> _productStateChangeModal() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (modalState != 0)
              ListTile(
                title: Center(
                  child: Text('판매중'),
                ),
                onTap: () {
                  stateChange('sale');
                },
              ),
            if (modalState != 1)
              ListTile(
                title: Center(
                  child: Text('예약됨'),
                ),
                onTap: () {
                  stateChange('trading');
                },
              ),
            if (modalState != 2)
              ListTile(
                title: Center(
                  child: Text('판매보류'),
                ),
                onTap: () {
                  stateChange('hold');
                },
              ),
            if (modalState != 3)
              ListTile(
                title: Center(
                  child: Text('판매완료'),
                ),
                onTap: () {
                  stateChange('completed');
                },
              ),
            Divider(color: Colors.black.withOpacity(0.3)),
            ListTile(
              title: Center(
                child: Text('취소'),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget setFavorite() {
    bool chk = widget.product.favoriteUserList == null ||
        widget.product.favoriteUserList[currentUserModel.uid] == null;

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
                FavoriteAnimation.showFavoriteDialog(context);
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

  Widget _bottomChatWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 10.0.w),
      child: SizedBox(
        width: 150.w,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: OnestepColors().mainColor,
            textStyle: TextStyle(color: Colors.white),
            elevation: 0,
          ),
          onPressed: () {
            // print("장터채팅누름");
            // print(currentUserModel.uid);
            // print(widget.product.uid);
            // print(widget.product.firestoreid);
            // print(widget.product);
            ChatNavigationManager.navigateProductToProductChat(
                context,
                currentUserModel.uid,
                widget.product.uid,
                widget.product.firestoreid,
                widget.product);
          },
          child: Text(
            '채팅',
            style: TextStyle(),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarWidget() {
    if (widget.product.uid == currentUserModel.uid) {
      return SizedBox(
        height: 55.h,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top:
                  BorderSide(color: Colors.grey.withOpacity(0.3), width: 0.5.w),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  controller: _bottomListviewScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          if (DateTime.now()
                                  .difference(widget.product.bumpTime)
                                  .inHours >=
                              1) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProductBump(product: widget.product),
                            ));
                          } else {
                            FloatingSnackBar.show(
                                context, "상품을 등록하고 1시간 뒤에 끌올할 수 있어요.");
                          }
                        },
                        child: Row(
                          children: [Icon(Icons.upload_outlined), Text("끌올하기")],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(children: [
                          Icon(Icons.chat_outlined),
                          Text("채팅목록")
                        ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(children: [
                          Icon(Icons.favorite_border_outlined),
                          Text("찜한사람")
                        ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          _productStateChangeModal();
                        },
                        child: Row(children: [
                          Icon(Icons.check_circle_outline_rounded),
                          Text("상태변경")
                        ]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductEdit(product: widget.product),
                            ),
                          )
                              .then((value) {
                            if (value == "OK") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetail(
                                          docId: widget.product.firestoreid)));
                            }
                          });
                        },
                        child: Row(children: [
                          Icon(Icons.edit_outlined),
                          Text("상품수정")
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        OnestepCustomDialog.show(context,
                            title: '상품을 삭제하시겠습니까?',
                            description: '삭제한 상품은 복구할 수 없습니다.',
                            cancleButtonText: '취소',
                            confirmButtonText: '삭제', confirmButtonOnPress: () {
                          FirebaseFirestore.instance
                              .collection("university")
                              .doc(currentUserModel.university)
                              .collection("product")
                              .doc(widget.product.firestoreid)
                              .update({'deleted': true});

                          Navigator.pop(context);
                        }, cancleButtonOnPress: () {
                          Navigator.pop(context);
                        });
                      },
                      child: Row(
                          children: [Icon(Icons.delete_outline), Text("상품삭제")]),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                initialData: true,
                stream: _bottomListviewStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data) {
                    return Padding(
                      padding: EdgeInsets.all(0),
                      child: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.grey,
                      ),
                    );
                  } else
                    return Container();
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 70.h,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black87,
                width: 0.1.w,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 60.w,
                height: 60.h,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.black87,
                        width: 0.1.w,
                      ),
                    ),
                  ),
                  child: setFavorite(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0.w),
              ),
              SizedBox(
                width: 100.w,
                child: Text(
                  "${widget.product.price}원",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: Container()),
              _bottomChatWidget(),
            ],
          ),
        ),
      );
    }
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
  }
}
