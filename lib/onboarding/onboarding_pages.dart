import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'onboarding_widget.dart';
import '../../utils/size_config.dart';
import 'package:Litigence/onboarding/textfont_getter.dart';
import '../providers.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OnboardingWidget(
      imagePath: 'assets/onboard/onboard_1.png',
      title: "Meet Litigence AI, your multimodal assistant 🚀",
      description: "Litigence AI can help you with various tasks and topics.",
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const OnboardingWidget(
      imagePath: 'assets/onboard/onboard_2.png',
      title: "Litigence AI is smart, helpful, and versatile 🧠",
      description: "Handle text, images, videos, and various file formats.",
    );
  }
}

class OnboardingScreen3 extends ConsumerStatefulWidget {
  const OnboardingScreen3({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends ConsumerState<OnboardingScreen3> {
  Future<void> _completeOnboarding() async {
    // Call the provider's completeOnboarding method
    await ref
        .read(onboardingCompleteProvider.notifier)
        .completeOnboarding();
    
    // Navigates to /authScreen once onboarding is complete.
    context.go('/authScreen');
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingWidget(
      imagePath: 'assets/onboard/onboard_3.png',
      title: "Let's start chatting 💬",
      description: "Tap the button below to start chatting with Litigence AI.",
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.getProportionalScreenHeight(15),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalScreenWidth(37),
              vertical: SizeConfig.getProportionalScreenHeight(24),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _completeOnboarding(),
          child: CustomText(
            context: context,
            text: "Get Started",
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}