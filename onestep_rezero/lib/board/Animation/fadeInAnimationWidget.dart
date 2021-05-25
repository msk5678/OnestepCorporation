// import 'dart:async';
// import 'package:flutter/material.dart';

// import 'abstractStatefulWidget.dart';

// class FadeIn extends StatefulWidget {
//   final Widget child;
//   final int delay;

//   FadeIn({@required this.child, this.delay});

//   @override
//   _FadeInState createState() => _FadeInState();
// }

// class _FadeInState extends CustomAnimationWidgetAbstract<FadeIn> {
//   @override
//   setAnimationController() {
//     animationController = AnimationController(
//         vsync: this, value: 0, duration: Duration(milliseconds: 2000));
//     // animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
//     if (widget.delay == null) {
//       animationController.forward();
//     } else {
//       Timer(Duration(milliseconds: widget.delay), () {
//         animationController.forward();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: animationController,
//       child: childWidget,
//     );
//   }

//   @override
//   setChildWidget() {
//     childWidget = widget.child;
//   }
// }
