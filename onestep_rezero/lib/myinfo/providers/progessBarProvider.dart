import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 둘다 바꿔야함 db 수정해서
final progressValueProvider = StateNotifierProvider<Test>((ref) {
  return Test();
});

final progressValueProvider2 = StateProvider<double>((ref) {
  return 0;
});

class Test extends StateNotifier<double> {
  Test() : super(0);

  void increment() => state += 0.1;
}

final progressValueProvider3 = ChangeNotifierProvider<Test2>((ref) {
  return Test2();
});

class Test2 extends ChangeNotifier {
  double a = 0.1;
  void increment() {
    a += 0.1;
    notifyListeners();
  }
}

final testContaierPadding = StateProvider<double>((ref) {
  return 0;
});
