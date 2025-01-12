import 'package:flutter/material.dart';
import '../otp_auth/otp_auth_screen.dart';
import '../otp_auth/home_screen.dart';
import '../utils/globals.dart';
import '../widgets/custom_loader.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    (() async {
      await Future.delayed(Duration.zero);
      final isLoggedIn = Globals.firebaseUser != null;

      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        isLoggedIn ? HomeScreen.id : OtpAuth.id,
      );
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: CustomLoader(),
      ),
    );
  }
}
