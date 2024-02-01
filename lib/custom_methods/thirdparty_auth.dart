import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gene/pages/dashboard/dashboard.dart';

Future<dynamic> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then(
        (userCredential) => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard())));
  } on Exception catch (e) {
    // TODO
    print('exception->$e');
  }
}

Future<UserCredential> signInWithMicrosoft() async {
  final microsoftProvider = MicrosoftAuthProvider();
  if (kIsWeb) {
    return await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
  } else {
    await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
    return await FirebaseAuth.instance.getRedirectResult().then((result) {
      return result;
    }).catchError((onError) {
      // TODO
      print('onError->$onError');
    });
  }
}

Future<UserCredential> signInWithApple() async {
  final appleProvider = AppleAuthProvider();
  if (kIsWeb) {
    return await FirebaseAuth.instance.signInWithPopup(appleProvider);
  } else {
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }
}