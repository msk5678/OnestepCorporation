import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/myinfo/pages/myProduct/mySaleProductMain.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProductMain extends StatefulWidget {
  MyProductMain({Key key}) : super(key: key);

  @override
  _MyProductMainState createState() => _MyProductMainState();
}

class _MyProductMainState extends State<MyProductMain>
    with SingleTickerProviderStateMixin {
  // final ScrollController _scrollController = ScrollController();
  // final StreamController _streamController = BehaviorSubject();
  // bool _isVisibility = false;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_tabListener);
    // context.read(mySaleProductProvider).product.clear();
    // context.read(mySaleProductProvider).fetchProducts();
    // _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    // _streamController.close();
    super.dispose();
  }

  void _tabListener() {
    setState(() {});
  }

  void scrollListener() {
    // if ((_scrollController.position.maxScrollExtent * 0.7) <
    //     _scrollController.position.pixels) {
    //   context.read(mySaleProductProvider).fetchNextProducts();
    // }

    // if (_scrollController.offset >= 600) {
    //   if (!_isVisibility) {
    //     _isVisibility = true;
    //     _streamController.sink.add(true);
    //   }
    // } else if (_scrollController.offset < 600) {
    //   if (_isVisibility) {
    //     _isVisibility = false;
    //     _streamController.sink.add(false);
    //   }
    // }
  }

  // Widget floatingButton() {
  //   return StreamBuilder<bool>(
  //     stream: _streamController.stream,
  //     initialData: false,
  //     builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //       return Visibility(
  //         visible: snapshot.data,
  //         child: Container(
  //           height: 40.0.h,
  //           width: 40.0.w,
  //           child: FittedBox(
  //             child: FloatingActionButton(
  //               heroTag: "mySaleProductMainFloatActionButton",
  //               onPressed: () {
  //                 _scrollController.position
  //                     .moveTo(0.5, duration: Duration(milliseconds: 200));
  //               },
  //               child:
  //                   Icon(Icons.keyboard_arrow_up_rounded, color: Colors.black),
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(100.0))),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _saleProduct() {
  //   return SingleChildScrollView(
  //     physics: AlwaysScrollableScrollPhysics(),
  //     controller: _scrollController,
  //     child: Container(
  //         color: Colors.white,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             MySaleProduct(),
  //           ],
  //         )),
  //   );
  // }

  PreferredSizeWidget _appbarWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(90.h),
      child: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          '내 상품',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: OnestepColors().mainColor,
          indicatorWeight: 5,
          labelColor: Colors.black,
          tabs: [
            Tab(text: "판매중"),
            Tab(text: "예약중"),
            Tab(text: "판매완료"),
            Tab(text: "판매보류"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appbarWidget(),
        body: TabBarView(
          controller: _tabController,
          children: [
            MySaleProductMain(),
            Text("예약중"),
            Text("판매완료"),
            Text("판매보류"),
          ],
        ),
      ),
    );
  }
}
