import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteAnimation {
  static void showFavoriteDialog(BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pop(context);
    });
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Icon(Icons.favorite, color: Colors.pink, size: 200.sp),
      ),
    );
  }
}
