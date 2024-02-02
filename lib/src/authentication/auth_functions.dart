import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);

  } catch (e) {
    
    print('Exception occurred during Google sign-in: $e');
    // Handle the exception here
  }
}

Future<UserCredential> signInWithMicrosoft() async {
  final microsoftProvider = MicrosoftAuthProvider();
  try {
    if (kIsWeb) {
      return await FirebaseAuth.instance.signInWithPopup(microsoftProvider);
    } else {
      await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      return await FirebaseAuth.instance.getRedirectResult().then((result) {
        return result;
      }).catchError((onError) {
        print('Error occurred during Microsoft sign-in: $onError');
        // Handle the error here
      });
    }
  } catch (e) {
    print('Exception occurred during Microsoft sign-in: $e');
    // Handle the exception here
    throw e; // Rethrow the exception if needed
  }
}

Future<UserCredential> signInWithApple() async {
  final appleProvider = AppleAuthProvider();
  try {
    if (kIsWeb) {
      return await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      return await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }
  } catch (e) {
    print('Exception occurred during Apple sign-in: $e');
    // Handle the exception here
    throw e; // Rethrow the exception if needed
  }
}
