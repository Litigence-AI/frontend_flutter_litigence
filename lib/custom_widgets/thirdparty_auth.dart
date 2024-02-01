import 'package:flutter/material.dart';
import 'package:gene/custom_widgets/logo_button.dart';
import 'package:gene/custom_methods/thirdparty_auth.dart';

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
              LogoButton(assetPath: 'assets/logo/google-logo.svg', onPressed: () {
                signInWithGoogle(context);
              }),
              LogoButton(assetPath: 'assets/logo/microsoft-logo.svg',onPressed: () {
                signInWithMicrosoft();
              }),
              LogoButton(assetPath: 'assets/logo/apple-logo.svg',onPressed:  () {
                signInWithApple();
              }),
            ],
          )
      ],
    );
  }
}
