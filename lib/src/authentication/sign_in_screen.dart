import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/src/theme/font_weight.dart';
import '/src/theme/color_code.dart';
import '/src/authentication/thirdparty_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isChecked = false;

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.green[300]!;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodeMap['Background'],
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "Welcome back 👋",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: fontWeightMap['Semi Bold'],
                  color: colorCodeMap['Black'],
                ),
              ),
              Text(
                "Please enter you email & password to sign in",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: fontWeightMap['Regular'],
                  color: colorCodeMap['Gray'],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const ThirdpartyAuth()
            ],
          ),
        ),
      ),
    );
  }
}
