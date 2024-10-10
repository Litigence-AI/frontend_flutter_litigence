import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/src/authentication/logo_button.dart';
import '/src/authentication/auth_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import '/src/dashboard/dashboard.dart';

class ThirdpartyAuth extends StatefulWidget {
  const ThirdpartyAuth({super.key});

  @override
  State<ThirdpartyAuth> createState() => _ThirdpartyAuthState();
}

class _ThirdpartyAuthState extends State<ThirdpartyAuth> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            SizedBox(width: 8),
            Expanded(child: Divider()),
            SizedBox(width: 7),
            Text('or continue with'),
            SizedBox(width: 7),
            Expanded(child: Divider()),
            SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 20),
        _isLoading
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LogoButton(
                    assetPath: 'assets/logo/google-logo.svg',
                    onPressed: _handleGoogleSignIn,
                  ),
                  LogoButton(
                    assetPath: 'assets/logo/microsoft-logo.svg',
                    onPressed: _handleMicrosoftSignIn,
                  ),
                  // LogoButton(
                  //   assetPath: 'assets/logo/apple-logo.svg',
                  //   onPressed: _handleAppleSignIn,
                  // ),
                ],
              ),
      ],
    );
  }

  Future<void> _handleGoogleSignIn() async {
    await _authenticate(signInWithGoogle, "Google");
  }

  Future<void> _handleMicrosoftSignIn() async {
    await _authenticate(signInWithMicrosoft, "Microsoft");
  }

  Future<void> _handleAppleSignIn() async {
    await _authenticate(signInWithApple, "Apple");
  }

  Future<void> _authenticate(
      Future<dynamic> Function() signInMethod, String provider) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final credential = await signInMethod();
      if (credential != null && mounted) {
        context.go('/dashboard');
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "$provider Authentication Successful!",
        );
      } else if (mounted) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "$provider Authentication Failed!",
        );
      }
    } catch (e) {
      if (mounted) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "An error occurred during $provider sign-in.",
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
