import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

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
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth > 800 ? 32 : screenWidth > 600 ? 28 : 24;
    double paddingSize = screenWidth > 800 ? 32.0 : 24.0;
    double buttonWidth = screenWidth > 800 ? 150 : 100;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth > 800 ? 600 : 400),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingSize),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Litigence AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    'assets/lady_justice.png',
                    height: screenWidth > 800 ? 160 : 120,
                  ),
                  Text(
                    'Bridging knowledge gaps\nfor a fairer world',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: Size(buttonWidth, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/google.png',
                              height: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/otpAuthScreen');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: Size(buttonWidth, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: 24,
                              color: Color.fromARGB(217, 14, 14, 14),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Continue with Phone number',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _launchURL(
                              'https://litigence-ai.github.io/privacy-policy/');
                        },
                        child: const Text(
                          'Privacy policy',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(width: 24),
                      TextButton(
                        onPressed: () {
                          _launchURL(
                              'https://litigence-ai.github.io/Terms-of-service/');
                        },
                        child: const Text(
                          'Terms of service',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
