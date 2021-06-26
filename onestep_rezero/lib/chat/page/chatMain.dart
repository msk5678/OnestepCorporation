import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/page/admobListPage.dart';
import 'package:onestep_rezero/chat/page/productChatListPage.dart';
import 'package:onestep_rezero/chat/page/productChatListPage2.dart';
import 'package:onestep_rezero/chat/productchat/controller/productChatController.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({Key key}) : super(key: key);

  @override
  _StackListState createState() => _StackListState();
}

class _Page {
  const _Page({this.icon, this.text});
  final IconData icon;
  final String text;
}

const List<_Page> _allPages = <_Page>[
  _Page(
    icon: Icons.chat,
    text: '장터채팅',
  ),
  _Page(
    icon: Icons.post_add,
    text: '게시판채팅',
  ),
  // _Page(icon: Icons.check_circle, text: 'SUCCESS'),
];

class _StackListState extends State<ChatMain>
    with SingleTickerProviderStateMixin {
  _StackListState();
  ScrollController _scrollViewController; //2개 스크롤 통합 컨트롤러
  TabController _tabController; //탭바 전환 컨트롤러

  @override
  void initState() {
    super.initState();
    // _controller = TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    // super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  toolbarHeight: 100, //appbar top height
                  // primary: false,
                  backgroundColor: Colors.transparent,
                  // OnestepColors().mainColor, // app bar color
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,

                    // centerTitle: false,
                    // background: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     Column(
                    //       // mainAxisSize: MainAxisSize.max,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         SizedBox(
                    //           height: 50,
                    //         ),
                    //         Text(
                    //           'Chat',
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 30,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //         // SizedBox(
                    //         //   height: 15,
                    //         // ),
                    //         // Container(
                    //         //   color: Colors.grey.shade200,
                    //         //   child: Text(
                    //         //     '읽지 않은 메세지 : 1개',
                    //         //     style: TextStyle(
                    //         //       color: Colors.grey,
                    //         //       fontSize: 12,
                    //         //     ),
                    //         //   ),
                    //         // ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 35,
                        ),
                        Text(
                          'Chat',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          // color: Colors.grey.shade200,
                          child: Row(
                            children: [
                              Text(
                                '읽지 않은 메세지 : ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              ProductChatController()
                                  .getNewProductChatCountText(),
                              // Text(
                              //   '1개',
                              //   style: TextStyle(
                              //     color: OnestepColors().mainColor,
                              //     // Colors.green,
                              //     fontSize: 10,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), // title: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Chat',
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 40,
                  //       ),
                  //     ),
                  //     Text(
                  //       '읽지 않은 메세지 : 1개',
                  //       style: TextStyle(
                  //         color: Colors.grey,
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // leading: Container(
                  //   color: Colors.black,
                  // ), // hambuger menu hide
                  // collapsedHeight: 70.0,
                  expandedHeight: 170, // Tab Bar Height

                  pinned:
                      true, //pinned(고정) : 스크롤 시 앱 바 표시 여부 @@탭바 유지하려면 true 필수
                  //false : '앱바' + '탭바' 전부 위로 올라감
                  // true : '탭바유지', '앱바 + 하단 컨텐츠 일부' 올라감 => @@ 하단 컨텐츠 안올라가게 해야함
                  floating: true, //floating : 상단 스크롤 시 잔여 사이즈 설정
                  // true : preferredSize 높이 남고 / 앱바 + 하단 컨텐츠 상승
                  //false : expandedHeight 높이 남고 / 앱바 + 하단 컨텐츠 상승 => 상단 컨텐츠 더 많이 들어감
                  forceElevated: //
                      // innerBoxIsScrolled,
                      // true,
                      //true : 항상 탭바 하단 그림자
                      false,
                  //false : 앱바 스크롤 시에만 그림자
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(48), //앱바+탭바 맥스사이즈
                    child: Align(
                      alignment: Alignment. //탭바 정렬 위치
                          // topCenter,
                          centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: deviceWidth,
                          // maxHeight: 150.0,
                        ),
                        child: Material(
                          color: Colors.white,
                          child: TabBar(
                            // indicatorColor: Colors.yellow,
                            // indicatorSize: TabBarIndicatorSize.label,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            // labelStyle: TextStyle(color: Colors.pink),
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 4,
                                color: Colors.pink,
                                style: BorderStyle.none,
                              ),
                              insets: EdgeInsets.only(
                                left: 0,
                                right: 8,
                                bottom: 4,
                              ),
                            ),
                            controller: _tabController,
                            isScrollable: true, //false 시 탭바 센터 정렬됨
                            labelPadding: EdgeInsets.only(
                                left: 8, right: 0), //탭바 센터 정렬 시 패딩 조절
                            tabs: _allPages.map<Tab>((_Page page) {
                              // print("####### ${page.text}");
                              return Tab(
                                child: Text(
                                  page.text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                //@@tabBar Icon
                                // text: page.text,
                                // icon:
                                //     // Icon(Icons.ac_unit),
                                //     Badge(
                                //   toAnimate: true,
                                //   borderRadius: BorderRadius.circular(80),
                                //   badgeColor: Colors.red,
                                //   badgeContent: ProductChatController()
                                //       .getProductChatCountText(),
                                //   child: Icon(page.icon,
                                //       color: Color.fromRGBO(248, 247, 77, 1)),
                                // ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // SliverToBoxAdapter(
              //   child: Container(
              //     color: Colors.amber,
              //     width: 100,
              //     height: 100,
              //   ),
              // ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: _allPages.map<Widget>((_Page page) {
              return SafeArea(
                top: false,
                bottom: false,
                child: PageView.builder(
                  itemBuilder: (context, position) {
                    return Container(
                      height: 20,
                      width: 20,
                      color: Colors.white,
                      child: (position == 0 && page.text == '장터채팅')
                          ? //
                          ProductChatListPage()
                          // ProductChatListPage2()
                          : AdmobListPage(),
                    );
                  },
                  itemCount: 1,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
