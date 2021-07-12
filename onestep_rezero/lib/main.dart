import 'package:firebase_auth/firebase_auth.dart' as FBA;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/signUp/pages/signUpWidget.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:onestep_rezero/loggedInWidget.dart';
import 'package:onestep_rezero/signUpWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/utils/timeUtil.dart';
import 'appmain/routeGenterator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 비동기 함수 사용 처리
  await Firebase.initializeApp(); // firebase init
  TimeUtil.setLocalMessages(); // timeado 설정 ex) 몇분 전, 몇시간 전
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // 가로세로 회전 금지

  await Hive.initFlutter();
  await Hive.openBox('localChatList');
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Onestep',
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // kakao
    String kakaoAppKey = "88b99cb950dc222f10f369161182d008";
    KakaoContext.clientId = kakaoAppKey;
    // initDynamicLinks();
  }

  // void initDynamicLinks() async {
  //   // 앱이 active이거나 background 상태일때 들어온 링크를 알 수 있는 링크 콜백에 대한 리스너 onLink()
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //     final NavigationService navService = NavigationService();
  //     final Uri deepLink = dynamicLink?.link;

  //     print(deepLink.path);

  //     if (deepLink != null) {
  //       var code = deepLink.queryParameters['code'];
  //       navService.pushNamed('/DetailProduct', args: {"PRODUCTID": code}).then(
  //           (value) {
  //         print("clothitem");
  //       });
  //       // _handleDynamicLink(deepLink);
  //     }
  //   }, onError: (OnLinkErrorException e) async {
  //     print('onLinkError');
  //     print(e.message);
  //   });

  //   // 앱을 새로 런치한 링크를 알 수 있는 getInitialLink()
  //   final PendingDynamicLinkData data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data?.link;

  //   print(deepLink);
  //   if (deepLink != null) {
  //     var code = deepLink.queryParameters['code'];
  //     navService
  //         .pushNamed('/DetailProduct', args: {"PRODUCTID": code}).then((value) {
  //       print("clothitem");
  //     });

  //     // navService.pushNamed('/helloOnestep', args: deepLink);
  //     // _handleDynamicLink(deepLink);
  //   }
  // }

  @override
  void dispose() {
    Fluttertoast.showToast(msg: "한발자국 종료.");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FBA.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return LoggedInWidget(
              user: FirebaseAuth.instance.currentUser.providerData.single.uid);
        } else if (snapshot.hasError) {
          return Center(child: Text("Error"));
        } else {
          return SignUpWidget();
        }
      },
    ));
  }
}
