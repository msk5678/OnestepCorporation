import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';

class SpinkitTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Scaffold(
        body: Center(
            child: Container(
          child: SpinKitWave(
            color: OnestepColors().mainColor,
            type: SpinKitWaveType.start,
          ),
        )),
      ),
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            child: SpinKitWave(
              color: OnestepColors().mainColor,
              type: SpinKitWaveType.start,
            ),
          ),
        ),
      ),
    );
  }
}
