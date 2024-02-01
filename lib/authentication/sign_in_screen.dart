import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Sign In',
          style: GoogleFonts.inter( // Apply the Inter font
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}