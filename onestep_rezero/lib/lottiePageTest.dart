import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottiePageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            child: Lottie.asset('assets/footprint.json'),
          ),
        ));
  }
}
