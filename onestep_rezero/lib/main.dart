import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:onestep_rezero/moor/moor_database.dart';
import 'package:onestep_rezero/timeUtil.dart';
import 'package:provider/provider.dart' as provider;
import 'appmain/mainPage.dart';

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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // String kakaoAppKey = "38cc3c08e0c39fa8f9422cc4b871a82f";
    // KakaoContext.clientId = kakaoAppKey;
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
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigationKey,
      debugShowCheckedModeBanner: false,
      title: 'Onestep',
      home: MainPage(),
    );
  }
}
