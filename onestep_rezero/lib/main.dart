import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onestep',
      home: MainPage(),
    );
  }
}
