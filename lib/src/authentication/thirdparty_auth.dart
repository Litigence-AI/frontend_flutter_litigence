import 'package:flutter/material.dart';
import 'package:gene/src/authentication/logo_button.dart';
import 'package:gene/src/authentication/auth_functions.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:gene/src/dashboard/dashboard.dart';

class ThirdpartyAuth extends StatelessWidget {
  const ThirdpartyAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Expanded(child: Divider()),
            SizedBox(
              width: 7,
            ),
            Text('or continue with'),
            SizedBox(
              width: 7,
            ),
            Expanded(child: Divider()),
            SizedBox(
              width: 8,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LogoButton(
                assetPath: 'assets/logo/google-logo.svg',
                onPressed: () {
                  signInWithGoogle().then((credential) {
                    if (credential != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard()),
                      );
                    } else {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: "Google Authentication Failed!",
                      );
                    }
                  });
                }),
            LogoButton(
                assetPath: 'assets/logo/microsoft-logo.svg',
                onPressed: () {
                  signInWithMicrosoft().then((credential) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()),
                    );
                  });
                }),
            LogoButton(
                assetPath: 'assets/logo/apple-logo.svg',
                onPressed: () {
                  signInWithApple().then((credential) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()),
                    );
                  });
                }),
          ],
        )
      ],
    );
  }
}
