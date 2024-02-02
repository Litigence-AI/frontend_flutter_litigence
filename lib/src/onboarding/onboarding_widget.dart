import 'package:flutter/material.dart';
import 'package:gene/src/onboarding/textfont_getter.dart';

class OnboardingWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final Widget? child;

  const OnboardingWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget? localChild = child;
    localChild ??= Container();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 40), // Add SizedBox
        Image.asset(imagePath),
        CustomText(
          text: title,
          context: context,
          fontWeight: FontWeight.w700,
          fontSize: 29,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: CustomText(
            text: description,
            context: context,
            fontWeight: FontWeight.w400,
            fontSize: 20.99,
            textAlign: TextAlign.center,
          ),
        ),
        localChild,
      ],
    );
  }
}
