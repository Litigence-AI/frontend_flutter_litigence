import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gene/theme/font_weight.dart';
import 'package:gene/theme/color_code.dart';
import 'package:gene/custom_widgets/logo_button.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
                print('Google');
              }),
              logoButton('assets/logo/microsoft-logo.svg', () {
                print('Microsoft');
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
