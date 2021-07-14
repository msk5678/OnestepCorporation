import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/widgets/public/productGridView.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:rxdart/rxdart.dart';

class UserProfileMain extends StatefulWidget {
  final DocumentSnapshot userData;
  UserProfileMain({Key key, @required this.userData}) : super(key: key);

  @override
  _UserProfileMainState createState() => _UserProfileMainState();
}

class _UserProfileMainState extends State<UserProfileMain> {
  bool _isVisibility = false;
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollToTopstreamController = BehaviorSubject();

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollToTopstreamController.close();
    super.dispose();
  }

  void scrollListener() {
    if ((_scrollController.position.maxScrollExtent * 0.7) <
        _scrollController.position.pixels) {
      // context.read(productMainService).fetchNextProducts();
    }

    if (_scrollController.offset >= 600) {
      if (!_isVisibility) {
        _isVisibility = true;
        _scrollToTopstreamController.sink.add(true);
      }
    } else if (_scrollController.offset < 600) {
      if (_isVisibility) {
        _isVisibility = false;
        _scrollToTopstreamController.sink.add(false);
      }
    }
  }

  PreferredSizeWidget _appbarWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        // backgroundColor: Colors.white.withAlpha(alpha),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "프로필",
          style: TextStyle(color: Colors.black),
          // style: TextStyle(color: Colors.black.withAlpha(alpha)),
        ),
      ),
    );
  }

  Widget _userInformation() {
    return Padding(
      padding:
          EdgeInsets.only(top: 15.h, bottom: 25.h, left: 15.w, right: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: widget.userData['imageUrl'],
            imageBuilder: (context, imageProvider) => Container(
              width: 70.0.w,
              height: 70.0.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(width: 10.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userData['nickName'],
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5.0.h),
              Text(
                "등급, 가입일, 학교인증여부 등",
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _saleProduct() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("university")
            .doc(currentUserModel.university)
            .collection("product")
            .where("uid", isEqualTo: widget.userData['uid'])
            .where("deleted", isEqualTo: false)
            .where("hold", isEqualTo: false)
            .orderBy("bumpTime", descending: true)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("사용자 정보를 불러오는데 실패하였습니다."));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasData) {
                List _product = snapshot.data.docs.map((snap) {
                  return Product.fromJson(snap.data(), snap.id);
                }).toList();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text("상품"),
                    //     GestureDetector(
                    //       onTap: () {
                    //         print("더보기 탭");
                    //       },
                    //       child: Text("더보기"),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Text("${snapshot.data.docs.length}개",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    ProductGridView(itemList: _product),
                  ],
                );
              } else {
                return Container();
              }
          }
        });
  }

  Future<void> _refreshPage() async {
    // context.read(productMainService).fetchProducts();
  }

  Widget _bodyWidget() {
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        controller: _scrollController,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _userInformation(),
            _saleProduct(),
          ],
        ),
      ),
    );
  }

  Widget scrollToTopFloatingActionButton() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: StreamBuilder<bool>(
            stream: _scrollToTopstreamController.stream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Visibility(
                visible: snapshot.data,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 40.0.h,
                  width: 40.0.w,
                  child: FittedBox(
                    child: FloatingActionButton(
                      elevation: 0,
                      heroTag: null,
                      onPressed: () {
                        _scrollController.position
                            .moveTo(0.5, duration: Duration(milliseconds: 200));
                      },
                      child: Icon(Icons.keyboard_arrow_up_rounded,
                          color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      floatingActionButton: scrollToTopFloatingActionButton(),
    );
  }
}
