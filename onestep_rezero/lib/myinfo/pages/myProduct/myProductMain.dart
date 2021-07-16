import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/myinfo/pages/myProduct/myCompletedProductMain.dart';
import 'package:onestep_rezero/myinfo/pages/myProduct/myHoldProductMain.dart';
import 'package:onestep_rezero/myinfo/pages/myProduct/mySaleProductMain.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'myTradingProductMain.dart';

class MyProductMain extends StatefulWidget {
  MyProductMain({Key key}) : super(key: key);

  @override
  _MyProductMainState createState() => _MyProductMainState();
}

class _MyProductMainState extends State<MyProductMain>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_tabListener);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();

    super.dispose();
  }

  void _tabListener() {
    setState(() {});
  }

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
            MyTradingProductMain(),
            MyCompletedProductMain(),
            MyHoldProductMain(),
          ],
        ),
      ),
    );
  }
}
