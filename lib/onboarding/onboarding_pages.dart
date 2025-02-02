import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_widget.dart';
import '../../utils/size_config.dart';
import 'package:Litigence/onboarding/textfont_getter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class OnboardingScreen1 extends ConsumerWidget {
  const OnboardingScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  Future<void> _completeOnboarding(BuildContext context) async {
    // Update the reactive onboarding state.
    await ref.read(onboardingStateProvider.notifier).completeOnboarding();
    // context.go( root );
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
            backgroundColor:
                Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalScreenWidth(40),
              vertical: SizeConfig.getProportionalScreenHeight(25),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _completeOnboarding(context),
          child: CustomText(
            context: context,
            text: "Get Started",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
