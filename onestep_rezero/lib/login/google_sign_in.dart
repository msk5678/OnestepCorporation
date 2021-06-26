import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider =
    ChangeNotifierProvider<GoogleSignInProvider>((ref) {
  return GoogleSignInProvider();
});

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount _user;

  GoogleSignInAccount get user => _user;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      notifyListeners();
    } catch (e) {
      print("@@@@@@@ google_sign_in googleLogin() 로그인 실패 ${e.toString()}");
    }
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
