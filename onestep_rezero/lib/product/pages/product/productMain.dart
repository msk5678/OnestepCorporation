import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/favorite/pages/favoriteMain.dart';
import 'package:onestep_rezero/home/pages/homeNotificationPage.dart';
import 'package:onestep_rezero/home/widgets/test.dart';
import 'package:onestep_rezero/login/pages/loginJoinPage.dart';
import 'package:onestep_rezero/login/pages/termsPage.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/pages/category/categorySidebar.dart';
import 'package:onestep_rezero/product/pages/product/productAdd.dart';

import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:onestep_rezero/product/widgets/main/productMainHeader.dart';
import 'package:onestep_rezero/report/reportPageTest.dart';
import 'package:onestep_rezero/search/pages/searchMain.dart';

import '../../../spinkitTest.dart';

class ProductMain extends StatefulWidget {
  @override
  _ProductMainState createState() => _ProductMainState();
}

// test
GoogleSignInAccount user = googleSignIn.currentUser;

class _ProductMainState extends State<ProductMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollToTopstreamController =
      StreamController<bool>();
  final StreamController<bool> _productAddstreamController =
      StreamController<bool>();
  bool _isVisibility = false;

  // test 용
  GoogleSignInAccount user = googleSignIn.currentUser;

  // push, marketing 알림 dialog test
  void _testShowDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("OneStep 회원가입을 진심으로 환영합니다!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("마케팅 및 이벤트성 알림을 받으시겠습니까?"),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height / 30, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          child: Text("취소"),
                          onPressed: () {
                            // FirebaseFirestore.instance
                            //     .collection('user')
                            //     .doc(googleSignIn.currentUser.id)
                            //     .collection('notification')
                            //     .doc('setting')
                            //     .set({"marketing": 0, "push": 1});
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          child: Text("확인"),
                          onPressed: () {
                            // FirebaseFirestore.instance
                            //     .collection('user')
                            //     .doc(googleSignIn.currentUser.id)
                            //     .collection('notification')
                            //     .doc('setting')
                            //     .set({"marketing": 1, "push": 1});
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(googleSignIn.currentUser.id)
        .get()
        .then((value) => {
              if (value.data()['push'] == 0)
                {
                  _testShowDialog(context),
                }
            });
    _scrollController.addListener(scrollListener);
    context.read(productMainService).fetchProducts();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollToTopstreamController.close();
    _productAddstreamController.close();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _productAddstreamController.sink.add(true);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _productAddstreamController.sink.add(false);
    }

    if ((_scrollController.position.maxScrollExtent * 0.7) <
        _scrollController.position.pixels) {
      context.read(productMainService).fetchNextProducts();
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

  PreferredSizeWidget appBar() {
    return AppBar(
      // title: Text(
      //   '장터',
      //   style: TextStyle(color: Colors.black),
      // ),
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) =>
                  CategorySidebar(),
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) =>
                  SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
          );
        },
        icon: Icon(Icons.menu_rounded, color: Colors.black),
      ),
      actions: <Widget>[
        // new IconButton(
        //   icon: new Icon(
        //     Icons.refresh,
        //     color: Colors.black,
        //   ),
        //   onPressed: () => {
        //     // setState(() {
        //     _scrollController.position
        //         .moveTo(0.5, duration: Duration(milliseconds: 500)),
        //     context.read(productMainService).fetchProducts(),
        //     // })
        //   },
        // ),
        new IconButton(
          icon: new Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SearchMain(searchKey: 1)),
            ),
          },
        ),
        new IconButton(
          icon: new Icon(
            Icons.favorite,
            color: Colors.pink,
          ),
          onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FavoriteMain(),
              ),
            ),
          },
        ),
        new IconButton(
          icon: new Icon(
            Icons.notifications_none_rounded,
            color: Colors.black,
          ),
          onPressed: () => {
            // 알림

            // sunghun

            // 회원가입 넘어가는 부분
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => LoginJoinPage(user))),

            // 알림으로 넘어가는 부분
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeNotificationPage(),
            )),

            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => Test(),
            // )),

            // 신고 page test
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => ReportPageTest())),

            // 약관 page
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => TermsPage(user))),

            // spinkit test
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => SpinkitTest())),

            // // 푸시알림 test
            // _testShowDialog(context),

            // Navigator.of(context).push(
            //   PageRouteBuilder(
            //     opaque: false, // set to false
            //     pageBuilder: (_, __, ___) => SpinkitTest(),
            //   ),
            // ),

            // showDialog(
            //   context: context,
            //   builder: (_) => Material(
            //     type: MaterialType.transparency,
            //     child: Center(
            //       child: Container(
            //         child: SpinKitWave(
            //           color: OnestepColors().mainColor,
            //           type: SpinKitWaveType.start,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          },
        ),
      ],
    );
  }

  Future<void> _refreshPage() async {
    context.read(productMainService).fetchProducts();
  }

  Widget productAddFloatingActionButton() {
    return StreamBuilder<bool>(
      stream: _productAddstreamController.stream,
      initialData: true,
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
            height: 40,
            child: FloatingActionButton.extended(
              heroTag: null,
              elevation: 0,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProductAdd()));
              },
              backgroundColor: Colors.white,
              // icon: Icon(
              //   Icons.save,
              //   color: Colors.black,
              // ),
              label: Text(
                "물품 등록",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget scrollToTopFloatingActionButton() {
    return StreamBuilder<bool>(
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
            height: 40.0,
            width: 40.0,
            child: FittedBox(
              child: FloatingActionButton(
                elevation: 0,
                heroTag: null,
                onPressed: () {
                  _scrollController.position
                      .moveTo(0.5, duration: Duration(milliseconds: 200));
                },
                child:
                    Icon(Icons.keyboard_arrow_up_rounded, color: Colors.black),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 180,
                  color: OnestepColors().mainColor,
                  child: Center(
                    child: Text("광고"),
                  ),
                ),
                SizedBox(height: 10),
                // ProductMainHeader(),
                // SizedBox(
                //     height: 10,
                //     child: Container(color: Color.fromRGBO(240, 240, 240, 1))),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Text("추천 상품",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600))),
                ),
                ProductMainBody(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0.1, 1.0),
            child: productAddFloatingActionButton(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: scrollToTopFloatingActionButton(),
          ),
        ],
      ),
    );
  }
}
