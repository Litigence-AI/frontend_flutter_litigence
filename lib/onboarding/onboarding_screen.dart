import 'package:flutter/material.dart';
import 'package:gene/pages/authentication/sign_in_screen.dart';
import 'custom_text_getter.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset('assets/onboard/onboard_1.png'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "Meet Gen-E, your multimodal assistant 🚀",
              context: context,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: CustomText(
            text:
                "Gen-E can help you with various tasks and topics, such as processing files, translating languages, searching the web, and more.",
            context: context,
            fontWeight: FontWeight.w400,
            fontSize: 20.99,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset('assets/onboard/onboard_2.png'),
        CustomText(
          text: "Gen-E is smart, helpful, and versatile 🧠 ",
          context: context,
          fontWeight: FontWeight.w700,
          fontSize: 30,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: CustomText(
              text:
                  "Gen-E can understand your natural language and handle text, images, videos, csv, audio, word, docx, and excel files. Gen-E can also learn from your feedback and preferences to improve over time.",
              context: context,
              fontWeight: FontWeight.w400,
              fontSize: 20.99,
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset('assets/onboard/onboard_3.png'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: CustomText(
              text: "Let’s start chatting 💬",
              context: context,
              fontWeight: FontWeight.w700,
              fontSize: 30,
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: CustomText(
              text:
                  "To start a conversation with Gen-E, just type or tap on the microphone icon. To access more features and settings, tap on the menu icon on the top right corner. Tap on the button below to chat with Gen-E now.",
              context: context,
              fontWeight: FontWeight.w400,
              fontSize: 20.99,
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 15),
          child: FilledButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE0AC94),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(100, 50),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SignIn(),
                ),
              );
            },
            child: CustomText(
                text: "Get Started",
                context: context,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
      ],
    );
  }
}
