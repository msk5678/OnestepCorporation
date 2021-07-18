import 'package:flutter/material.dart';

class FloatingSnackBar {
  static show(BuildContext context, String msg, {Duration duration}) {
    Duration snackBarDuration = duration ?? Duration(seconds: 2);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: snackBarDuration,
      behavior: SnackBarBehavior.floating,
      content: Text(
        msg,
        textAlign: TextAlign.center,
      ),
    ));
  }
}
