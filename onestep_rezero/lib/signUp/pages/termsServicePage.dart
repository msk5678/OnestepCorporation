import 'package:flutter/material.dart';

class TermsServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('서비스 이용약관'),
        ),
        body: Center(
            child: Container(
          child: Text('서비스 이용약관'),
        )));
  }
}
