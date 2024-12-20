import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:lexmachina/chat_ui/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class GoogleAuthScreen extends StatefulWidget {
  const GoogleAuthScreen({super.key});

  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  Future<void> _checkIfUserIsLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already signed in
      context.go('/chatScreen');
    }
  }

  Future<void> signInWithGoogle() async {

    _checkIfUserIsLoggedIn();

    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      try {
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
        // final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);

        // Handle successful sign-in
        context.go('/chatScreen');
      } on FirebaseAuthException catch (e) {
        // Handle errors
        print(e);
      }
      return;
    }

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted && userCredential.user != null) {
        // Store authenticated status and account details in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userEmail', userCredential.user!.email!);
        await prefs.setString('userName', userCredential.user!.displayName!);

        context.go('/chatScreen');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Auth Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: signInWithGoogle,
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}