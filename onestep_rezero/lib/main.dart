import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBA;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:onestep_rezero/moor/moor_database.dart';
import 'package:onestep_rezero/timeUtil.dart';
import 'package:provider/provider.dart' as provider;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onestep_rezero/login/user.dart';
import 'package:onestep_rezero/timeUtil.dart';
import 'appmain/bottomNavigationItem.dart';

final auth = FBA.FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();
final ref = FirebaseFirestore.instance.collection('users');
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

User currentUserModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  TimeUtil.setLocalMessages();
  runApp(
    provider.MultiProvider(providers: [
      provider.Provider<AppDatabase>.value(value: new AppDatabase()),
    ], child: ProviderScope(child: MyApp())),
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigationKey,
      debugShowCheckedModeBanner: false,
      title: 'Onestep',
      // builder: (context, child) {
      //   return ScrollConfiguration(behavior: MyBehavior(), child: child);
      // }, //스크롤 영역 제거
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static DateTime currentBackPressTime;
  int _currentIndex;

  bool triedSilentLogin = false; // login check
  bool setupNotifications = false; // token check

  BannerAd banner;
  InterstitialAd interstitialAd;
  RewardedAd rewardedAd;

  final String iOsTestUnitid = "ca-app-pub-3940256099942544/2934735716";
  final String androidTestUnitid =
      "ca-app-pub-3940256099942544/6300978111"; //testId
  @override
  void initState() {
    super.initState();
    // GoogleAdmob().initAdmob();
    //GoogleAdmob().initBannerAd(banner);

    banner = BannerAd(
      listener: AdListener(),
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOsTestUnitid : androidTestUnitid,
//      adUnitId: androidTestUnitid,
      request: AdRequest(),
    )..load();

    _currentIndex = 0;
    String kakaoAppKey = "88b99cb950dc222f10f369161182d008";
    KakaoContext.clientId = kakaoAppKey;
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    // 앱이 active이거나 background 상태일때 들어온 링크를 알 수 있는 링크 콜백에 대한 리스너 onLink()
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final NavigationService navService = NavigationService();
      final Uri deepLink = dynamicLink?.link;

      print(deepLink.path);

      if (deepLink != null) {
        var code = deepLink.queryParameters['code'];
        navService.pushNamed('/DetailProduct', args: {"PRODUCTID": code}).then(
            (value) {
          print("clothitem");
        });
        // _handleDynamicLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    // 앱을 새로 런치한 링크를 알 수 있는 getInitialLink()
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    print(deepLink);
    if (deepLink != null) {
      var code = deepLink.queryParameters['code'];
      navService
          .pushNamed('/DetailProduct', args: {"PRODUCTID": code}).then((value) {
        print("clothitem");
      });

      // navService.pushNamed('/helloOnestep', args: deepLink);
      // _handleDynamicLink(deepLink);
    }
  }

  bool isEnd() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("한번더 누르면 종료"),
      ));
      return false;
    }
    return true;
  }

  Future<void> tryCreateUserRecord(BuildContext context) async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      return null;
    }
    DocumentSnapshot userRecord = await ref.doc(user.id).get();
    if (userRecord.data() == null) {
      // no user record exists, time to create

      String nickName = "홍은표";

      // ********* 회원가입 *************

      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => Center(
      //             child: Scaffold(
      //                 appBar: AppBar(
      //                   leading: Container(),
      //                   title: Text('Fill out missing data',
      //                       style: TextStyle(
      //                           color: Colors.black,
      //                           fontWeight: FontWeight.bold)),
      //                   backgroundColor: Colors.white,
      //                 ),
      //                 body: ListView(
      //                   children: <Widget>[
      //                     Container(
      //                       child: CreateAccount(),
      //                     ),
      //                   ],
      //                 )),
      //           )),
      // );

      if (nickName != null || nickName.length != 0) {
        await ref.doc(user.id).set({
          "authUniversity": "", // 대학인증여부
          "uid": user.id, // uid
          "nickName": nickName, // 닉네임
          "photoUrl": user.photoUrl, // 사진
          "userEmail": user.email, // 이메일
          "userLevel": 1, // 레벨
          "userScore": 0, // 점수
          "userUniversity": "", // 학교이름
          "userUniversityEmail": "", // 학교이메일
          "timeStamp": DateTime.now(),
        }).whenComplete(() {
          ref.doc(user.id).collection("chatcount").doc(user.id).set({
            "productchatcount": 0,
            "boardchatcount": 0,
          });
        });
      }
      userRecord = await ref.doc(user.id).get();
    }
    currentUserModel = User.fromDocument(userRecord);
    return null;
  }

  Future<Null> _ensureLoggedIn(BuildContext context) async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      user = await googleSignIn.signInSilently();
    }
    if (user == null) {
      await googleSignIn.signIn();
      await tryCreateUserRecord(context);
    }

    if (auth.currentUser == null) {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final FBA.GoogleAuthCredential credential =
          FBA.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
    }
  }

  void login() async {
    await _ensureLoggedIn(context);
    setState(() {
      triedSilentLogin = true;
    });
  }

  Future<Null> _silentLogin(BuildContext context) async {
    GoogleSignInAccount user = googleSignIn.currentUser;

    if (user == null) {
      user = await googleSignIn.signInSilently();
      await tryCreateUserRecord(context);
    }

    if (auth.currentUser == null && user != null) {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final FBA.GoogleAuthCredential credential =
          FBA.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
    }
  }

  void silentLogin(BuildContext context) async {
    await _silentLogin(context);
    setState(() {
      triedSilentLogin = true;
    });
  }

  Future<Null> _setUpNotifications() async {
    if (Platform.isAndroid) {
      _firebaseMessaging.getToken().then((token) {
        print("Firebase Messaging Token: " + token);

        FirebaseFirestore.instance
            .collection("users")
            .doc(currentUserModel.uid)
            .update({"token": token});
      });
    }
  }

  void setUpNotifications() {
    _setUpNotifications();
    setState(() {
      setupNotifications = true;
    });
  }

  Scaffold buildLoginPage() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 240.0),
          child: Column(
            children: <Widget>[
              Text(
                '한발자국',
                style: TextStyle(
                    fontSize: 60.0,
                    fontFamily: "Billabong",
                    color: Colors.black),
              ),
              Padding(padding: const EdgeInsets.only(bottom: 100.0)),
              GestureDetector(
                onTap: login,
                child: TextButton(
                  onPressed: login,
                  child: Container(child: Text("구글 로그인")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (triedSilentLogin == false) {
      silentLogin(context);
    }

    if (setupNotifications == false && currentUserModel != null) {
      setUpNotifications();
    }

    return (googleSignIn.currentUser == null || currentUserModel == null)
        ? buildLoginPage()
        : SafeArea(
            child: WillPopScope(
                child: Scaffold(
                  // key: _globalKey,
                  body: Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: _currentIndex,
                          children: [
                            for (final tabItem in BottomNavigationItem.items)
                              tabItem.page,
                          ],
                        ),
                      ),
                      1 < 0 ? getBannerAdtoMain() : Text("dd"),
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    fixedColor: Colors.black,
                    currentIndex: _currentIndex,
                    onTap: (int index) => setState(() => _currentIndex = index),
                    type: BottomNavigationBarType.fixed,
                    showSelectedLabels: false,
                    showUnselectedLabels: false, // title 안보이게 설정
                    items: [
                      for (final tabItem in BottomNavigationItem.items)
                        BottomNavigationBarItem(
                          icon: tabItem.icon,
                          label: tabItem.title,
                        )
                    ],
                  ),
                ),
                onWillPop: () async {
                  bool result = isEnd();
                  return await Future.value(result);
                }),
          );
  }

  Widget getBannerAdtoMain() {
    return Container(
      height: 50,
      color: Colors.white,
      child: this.banner == null
          ? Text("err")
          : AdWidget(
              ad: this.banner,
            ),
    );
  }
}
