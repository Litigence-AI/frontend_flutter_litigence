import 'package:flutter/material.dart';
import 'package:gene/pages/dashboard/dashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gene/theme/font_weight.dart';
import 'package:gene/theme/color_code.dart';
import 'package:gene/custom_widgets/logo_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/foundation.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodeMap['Background'],
      body: Column(
        children: [
          Text(
            "Hello there 👋",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: fontWeightMap['Semi Bold'],
              color: colorCodeMap['Black'],
            ),
          ),
          Text(
            "Please enter you email & password to create an account",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: fontWeightMap['Regular'],
              color: colorCodeMap['Gray'],
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              logoButton('assets/logo/google-logo.svg', () {
                signInWithGoogle(context);
              }),
              logoButton('assets/logo/microsoft-logo.svg', () {
                signInWithMicrosoft();
              }),
              logoButton('assets/logo/apple-logo.svg', () {
                print('Apple');
              }),
            ],
          )
        ],
      ),
    );
  }
}
