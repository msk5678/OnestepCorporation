import 'package:flutter/material.dart';

class TermsPersonalDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('개인정보 수집 및 이용 안내'),
        ),
        body: Center(
            child: Container(
          child: Text('개인정보 수집 및 이용 안내'),
        )));
  }
}
