import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/favorite/pages/favoriteMain.dart';

import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:onestep_rezero/product/widgets/main/productMainHeader.dart';
import 'package:onestep_rezero/home/pages/homeNotificationPage.dart';
import 'package:onestep_rezero/loggedInWidget.dart';
import 'package:onestep_rezero/product/pages/category/categorySidebar.dart';

import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:onestep_rezero/report/reportPageTest.dart';
import 'package:onestep_rezero/search/pages/searchMain.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../onestepCustomDialog.dart';
import '../../../spinkitTest.dart';

class ProductMain extends StatefulWidget {
  @override
  _ProductMainState createState() => _ProductMainState();
}

// push, marketing 알림 dialog test
void _testShowDialog(BuildContext context) {
  return OnestepCustomDialog.show(
    context,
    title: 'OneStep 회원가입을 진심으로 환영합니다!',
    description: '마케팅 및 이벤트성 알림을 받으시겠습니까?',
    confirmButtonText: '확인',
    cancleButtonText: '취소',
    confirmButtonOnPress: () {
      // FirebaseFirestore.instance
      //     .collection('user')
      //     .doc(googleSignIn.currentUser.id)
      //     .set({"pushCheck": 2});

      // FirebaseFirestore.instance
      //     .collection('user')
      //     .doc(googleSignIn.currentUser.id)
      //     .collection('notification')
      //     .doc('setting')
      //     .set({"marketing": 1, "push": 1});
      Navigator.of(context).pop();
    },
    cancleButtonOnPress: () {
      // FirebaseFirestore.instance
      //     .collection('user')
      //     .doc(googleSignIn.currentUser.id)
      //     .set({"pushCheck": 1});
      Navigator.of(context).pop();
    },
  );
}

class _ProductMainState extends State<ProductMain> {
  final ScrollController _scrollController = ScrollController();
  final StreamController<bool> _scrollToTopstreamController =
      StreamController<bool>();

  bool _isVisibility = false;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(currentUserModel.uid)
        .get()
        .then((value) => {
              if (value.data()['pushCheck'] == 0)
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
    super.dispose();
  }

  void scrollListener() {
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

  resetKMUCategory() {
    FirebaseFirestore.instance.collection("category").doc("kmu").set({
      "여성의류": {
        "image": 'assets/icons/category/dress.png',
        "detail": {
          "정장": 0,
          "원피스": 0,
          "자켓/코트": 0,
          "점퍼/패딩/야상": 0,
          "니트/스웨터/가디건": 0,
          "블라우스": 0,
          "셔츠/남방": 0,
          "조끼/베스트": 0,
          "티셔츠/캐쥬얼": 0,
          "맨투맨": 0,
          "레깅스": 0,
          "스커트/치마": 0,
          "바지/청바지/팬츠": 0,
          "트레이닝": 0,
          "빅사이즈": 0,
          "언더웨어/잠옷": 0,
          "이벤트/테마": 0
        },
        "total": 0,
      },
      "남성의류": {
        "image": 'assets/icons/category/man.png',
        "detail": {
          "정장": 0,
          "자켓/코트": 0,
          "점퍼/패딩/야상": 0,
          "니트/스웨터/가디건": 0,
          "셔츠/남방": 0,
          "조끼/베스트": 0,
          "티셔츠/캐쥬얼": 0,
          "맨투맨": 0,
          "바지/청바지/팬츠": 0,
          "트레이닝": 0,
          "빅사이즈": 0,
          "언더웨어/잠옷": 0,
          "이벤트/테마": 0
        },
        "total": 0,
      },
      "뷰티/미용": {
        "image": 'assets/icons/category/beauty.png',
        "detail": {
          "스킨케어": 0,
          "메이크업": 0,
          "향수": 0,
          "네일아트/케어": 0,
          "팩/필링/클렌징": 0,
          "헤어/바디": 0,
          "남성 화장품": 0,
          "가발": 0,
          "미용기기": 0,
          "기타 용품": 0,
        },
        "total": 0,
      },
      "패션잡화": {
        "image": 'assets/icons/category/watch.png',
        "detail": {
          "여성가방": 0,
          "남성가방": 0,
          "스니커즈": 0,
          "악세서리/주얼리": 0,
          "안경/선글라스": 0,
          "시계": 0,
          "운동화": 0,
          "여성신발": 0,
          "남성신발": 0,
          "지갑/벨트": 0,
          "모자": 0,
          "기타": 0,
        },
        "total": 0,
      },
      "디지털기기": {
        "image": 'assets/icons/category/monitor.png',
        "detail": {
          "카메라/캠코더": 0,
          "노트북": 0,
          "데스크탑/부품": 0,
          "키보드/마우스/스피커": 0,
          "모니터": 0,
          "복합기/프린터": 0,
          "허브/공유기": 0,
          "기타 디지털기기": 0,
        },
        "total": 0,
      },
      "가전": {
        "image": 'assets/icons/category/monitor.png',
        "detail": {
          "TV": 0,
          "냉장고": 0,
          "세탁기/건조기": 0,
          "복사기/팩스": 0,
          "주방가전": 0,
          "영상/음향가전": 0,
          "공기청정기/가습기/제습기": 0,
          "에어컨/선풍기": 0,
          "히터/난방/온풍기": 0,
          "전기/온수매트": 0,
          "기타 가전제품": 0,
        },
        "total": 0,
      },
      "가구/인테리어": {
        "image": 'assets/icons/category/interior.png',
        "detail": {
          "책상": 0,
          "의자": 0,
          "침대/매트리스": 0,
          "침구": 0,
          "수납/선반": 0,
          "조명/무드등": 0,
          "인테리어 소품": 0,
          "시계/액자": 0,
          "디퓨저/캔들": 0,
          "기타": 0,
        },
        "total": 0,
      },
      "스포츠": {
        "image": 'assets/icons/category/sport.png',
        "detail": {
          "골프": 0,
          "자전거": 0,
          "전동/인라인/스케이트": 0,
          "축구": 0,
          "야구": 0,
          "농구": 0,
          "수상스포츠": 0,
          "헬스/요가/필라테스": 0,
          "검도/권투/격투": 0,
          "기타 스포츠": 0,
        },
        "total": 0,
      },
      "레저/캠핑/여행": {
        "image": 'assets/icons/category/sport.png',
        "detail": {
          "텐트/침낭": 0,
          "취사용품": 0,
          "낚시용품": 0,
          "등산용품": 0,
          "기타용품": 0,
        },
        "total": 0,
      },
      "반려동물": {
        "image": 'assets/icons/category/pet.png',
        "detail": {
          "강아지용품": 0,
          "고양이용품": 0,
          "관상어용품": 0,
          "기타 반려동물 용품": 0,
        },
        "total": 0,
      },
      "도서": {
        "image": 'assets/icons/category/record.png',
        "detail": {
          "대학교재": 0,
          "학습/참고서": 0,
          "컴퓨터/인터넷": 0,
          "국어/외국어": 0,
          "수험서/자격증": 0,
          "소설": 0,
          "만화": 0,
          "여행/취미/레저": 0,
          "잡지": 0,
          "기타 도서": 0,
        },
        "total": 0,
      },
      "음반/굿즈": {
        "image": 'assets/icons/category/record.png',
        "detail": {
          "CD": 0,
          "DVD": 0,
          "LP/기타음반": 0,
          "스타굿즈": 0,
          "기타": 0,
        },
        "total": 0,
      },
      "티켓/쿠폰": {
        "image": 'assets/icons/category/ticket.png',
        "detail": {
          "기프티콘/쿠폰": 0,
          "상품권": 0,
          "티켓/항공권": 0,
        },
        "total": 0,
      },
      "게임": {
        "image": 'assets/icons/category/game.png',
        "detail": {
          "PC게임": 0,
          "플레이스테이션": 0,
          "XBOX": 0,
          "PSP": 0,
          "닌텐도": 0,
          "Wii": 0,
          "기타 게임": 0,
        },
        "total": 0,
      },
      "취미": {
        "image": 'assets/icons/category/game.png',
        "detail": {
          "예술/악기": 0,
          "수공예품": 0,
          "골동품/수집품": 0,
          "키덜트": 0,
          "기타 취미용품": 0,
        },
        "total": 0,
      },
      "원룸/숙소": {
        "image": 'assets/icons/category/game.png',
        "detail": {},
        "total": 0,
      },
      "무료나눔": {
        "image": 'assets/icons/category/gift.png',
        "detail": {},
        "total": 0,
      },
      "기타": {
        "image": 'assets/icons/category/tag.png',
        "detail": {},
        "total": 0,
      },
    });
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(
        '장터',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      // leading: IconButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       PageRouteBuilder(
      //         pageBuilder: (
      //           BuildContext context,
      //           Animation<double> animation,
      //           Animation<double> secondaryAnimation,
      //         ) =>
      //             CategorySidebar(),
      //         transitionsBuilder: (
      //           BuildContext context,
      //           Animation<double> animation,
      //           Animation<double> secondaryAnimation,
      //           Widget child,
      //         ) =>
      //             SlideTransition(
      //           position: Tween<Offset>(
      //             begin: const Offset(-1, 0),
      //             end: Offset.zero,
      //           ).animate(animation),
      //           child: child,
      //         ),
      //       ),
      //     );
      //   },
      //   icon: Icon(Icons.menu_rounded, color: Colors.black),
      // ),
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
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => HomeNotificationPage(),
                  // )),

                  // 신고 page test
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => ReportPageTest())),

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SpinkitTest())),

                  // 약관 page
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => TermsPage(user))),
                  // resetKMUCategory(),
                }),
      ],
    );
  }

  Future<void> _refreshPage() async {
    context.read(productMainService).fetchProducts();
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
                  width: MediaQuery.of(context).size.width,
                  height: 180.h,
                  child: Image.asset(
                    "assets/banner.png",
                    fit: BoxFit.cover,
                  ),
                ),
                ProductMainHeader(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Text("방금 올라온 상품",
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w600))),
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
            alignment: Alignment.bottomRight,
            child: scrollToTopFloatingActionButton(),
          ),
        ],
      ),
    );
  }
}
