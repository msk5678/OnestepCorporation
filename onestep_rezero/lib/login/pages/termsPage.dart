import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'loginJoinPage.dart';

class TermsPage extends StatelessWidget {
  final GoogleSignInAccount user;
  TermsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('약관'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => LoginJoinPage(user)));
          },
          child: Text('넘어가기'),
        ),
      ),
    );
  }
}
