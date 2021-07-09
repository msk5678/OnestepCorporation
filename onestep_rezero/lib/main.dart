import 'package:firebase_auth/firebase_auth.dart' as FBA;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:onestep_rezero/signUp/pages/signUpWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestep_rezero/utils/timeUtil.dart';
import 'appmain/routeGenterator.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  }

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
