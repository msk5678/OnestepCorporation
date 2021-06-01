import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onestep_rezero/chat/boardchat/realtimeProductChatController.dart';
import 'package:onestep_rezero/chat/page/productChatListPage.dart';
import 'package:onestep_rezero/main.dart';

class ChatMainPage extends StatefulWidget {
  @override
  ChatMainPageState createState() => ChatMainPageState();
}

class _Page {
  const _Page({this.icon, this.text});
  final IconData icon;
  final String text;
}

const List<_Page> _allPages = <_Page>[
  _Page(
    icon: Icons.chat,
    text: '장터게시판',
  ),
  _Page(icon: Icons.post_add, text: '일반게시판'),
  // _Page(icon: Icons.check_circle, text: 'SUCCESS'),
];

class ChatMainPageState extends State<ChatMainPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final String iOsTestUnitid = "ca-app-pub-3940256099942544/2934735716";
  final String androidTestUnitid =
      "ca-app-pub-3940256099942544/6300978111"; //testId
  BannerAd banner;
  InterstitialAd interstitialAd;
  RewardedAd rewardedAd;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
    banner = BannerAd(
      listener: AdListener(),
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOsTestUnitid : androidTestUnitid,
//      adUnitId: androidTestUnitid,
      request: AdRequest(),
    )..load();

    interstitialAd = InterstitialAd(
      listener: AdListener(onAdClosed: (ad) {
        print("Interstitial Ad 종료.");
      }),
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
    )..load();

    rewardedAd = RewardedAd(
      listener: AdListener(onAdClosed: (ad) {
        print("Rewarded Ad 종료");
      }, onRewardedAdUserEarnedReward: (ad, item) {
        print("Rewarded Ad 보상 획득");
      }),
      adUnitId: RewardedAd.testAdUnitId,
      request: AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("chat main");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: <Widget>[
          // Stack(
          //   children: [
          //     Positioned(
          //       child: Text("dd"),
          //       // _buildjson(context),
          //       left: 30,
          //       // height: 100,
          //       // width: 100,
          //       // bottom: 100,
          //       // right: 10,
          //     ),
          //     Positioned(
          //       child: Text("rrr"),
          //       //_buildjson2(context),
          //       //left: 30,
          //       // height: 100,
          //       // width: 100,
          //       // bottom: 100,
          //       right: 100,
          //     ),
          //   ],
          // ),
        ],
        backgroundColor: Color.fromRGBO(150, 150, 150, 1),
        title:
            //Text("채팅"),
            Text(
          '장터 & 익명채팅 ${googleSignIn.currentUser.id} ${currentUserModel.university}',
          style: TextStyle(
            fontSize: 10,
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: Color.fromRGBO(248, 247, 77, 1),
                  ),
                  insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
              controller: _controller,
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 8, right: 0),
              tabs: _allPages.map<Tab>((_Page page) {
                // print("####### ${page.text}");
                return Tab(
                    text: page.text,
                    icon:
                        //Icon(Icons.ac_unit),
                        Badge(
                      toAnimate: true,
                      borderRadius: BorderRadius.circular(80),
                      badgeColor: Colors.red,
                      badgeContent:
                          RealtimeProductChatController().getProductCountText(),
                      child: Icon(page.icon,
                          color: Color.fromRGBO(248, 247, 77, 1)),
                    ));
              }).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: _allPages.map<Widget>((_Page page) {
          return SafeArea(
            top: false,
            bottom: false,
            child: PageView.builder(
              itemBuilder: (context, position) {
                return Container(
                  child: (position == 0 && page.text == '장터게시판')
                      ? ProductChatListPage()
                      : Text("익명 향후 보완"),
                  //RealTimePage()
                );
              },
              itemCount: 1,
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print("플로팅 클릭");
        //1. Create Product Chat
        //friendUid, String postId, String chattingRoomId
        // getImage();

        //채팅방 생성
        // ProductChatController().createProductChattingRoomToRealtimeDatabase(
        //     "108438757310040285856", "1617992413066022", "1618662154938");

        // //메세지 생성
        // ProductChatController().onSendToProductMessage(
        //     "1621354025388", "108438757310040285856", "개시발좆같은거", 0);
        //2. AdMob
        //rewardedAd.show();
      }),
    );
  }

  Widget _buildjson2(var context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 300,
          height: 300,
          color: Colors.red,
        ),
        // Positioned(
        //   top: 12.0,
        //   right: 10.0,
        //   width: 10.0,
        //   height: 10.0,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       //color: AppColors.notification,
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget _buildjson(var context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () {
              //productChat.toJson();
              print("JSON 실행");
//              database.child("test").set(productChat.toJson());

              //print(productChat.toJson());
            }),
        // Positioned(
        //   top: 12.0,
        //   right: 10.0,
        //   width: 10.0,
        //   height: 10.0,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       //color: AppColors.notification,
        //     ),
        //   ),
        // )
      ],
    );
  }

  // getImage() async {
  //   List<Asset> resultList = List<Asset>();
  //   resultList =
  //       await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);
  //   setState(() {
  //     ProductChatListPage.imageList = resultList;
  //   });
  // }
}
