import 'package:flutter/material.dart';
import 'onboarding_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'textfont_getter.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingWidget(
      imagePath: 'assets/onboard/onboard_1.png',
      title: "Meet Letigence AI, your multimodal assistant 🚀",
      description:
      "Letigence AI can help you with various tasks and topics, such as processing files, translating languages, searching the web, and more.",
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingWidget(
      imagePath: 'assets/onboard/onboard_2.png',
      title: "Letigence AI is smart, helpful, and versatile 🧠",
      description:
      "Letigence AI can understand your natural language and handle text, images, videos, csv, audio, word, docx, and excel files.",
    );
  }
}

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true); // Set the flag to true
    context.go('/chatScreen');
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingWidget(
      imagePath: 'assets/onboard/onboard_3.png',
      title: "Let’s start chatting 💬",
      description:
      "To start a conversation with Letigence AI. Tap on the button below to chat with Letigence AI now.",
      child: Padding(
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
            _completeOnboarding(context);
          },
          child: CustomText(
              text: "Get Started",
              context: context,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
    );
  }
}
