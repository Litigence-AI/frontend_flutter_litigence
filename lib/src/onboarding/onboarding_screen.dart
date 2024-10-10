import 'package:flutter/material.dart';
import '/src/authentication/sign_in_screen.dart';
import 'textfont_getter.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'onboarding_widget.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    // void super.initState();
    // FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    controller.addListener(() {
      setState(() {
        _pageIndex = controller.page!.round();
      });
    });

    if (_pageIndex != 2) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                allowImplicitScrolling: true,
                children: const <Widget>[
                  Center(child: OnboardingScreen1()),
                  Center(child: OnboardingScreen2()),
                  Center(child: OnboardingScreen3()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, top: 30, right: 220),
              child: DotsIndicator(
                dotsCount: 3,
                position: _pageIndex,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeColor: const Color(0xFFE0AC94),
                  color: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          shape: const CircleBorder(),
          backgroundColor: const Color(0xFFE0AC94),
          foregroundColor: const Color(0xFFF5EAE5),
          child: const Icon(Icons.arrow_forward),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              allowImplicitScrolling: true,
              children: const <Widget>[
                OnboardingScreen1(),
                OnboardingScreen2(),
                OnboardingScreen3(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingWidget(
      imagePath: 'assets/onboard/onboard_1.png',
      title: "Meet LexMachina, your multimodal assistant 🚀",
      description:
          "LexMachina can help you with various tasks and topics, such as processing files, translating languages, searching the web, and more.",
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingWidget(
      imagePath: 'assets/onboard/onboard_2.png',
      title: "LexMachina is smart, helpful, and versatile 🧠 ",
      description:
          "LexMachina can understand your natural language and handle text, images, videos, csv, audio, word, docx, and excel files. LexMachina can also learn from your feedback and preferences to improve over time.",
    );
  }
}

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingWidget(
      imagePath: 'assets/onboard/onboard_3.png',
      title: "Let’s start chatting 💬",
      description:
          "To start a conversation with LexMachina, just type or tap on the microphone icon. To access more features and settings, tap on the menu icon on the top right corner. Tap on the button below to chat with LexMachina now.",
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
            // Navigator.of(context).pushReplacement(
            //   // MaterialPageRoute(
            //   //   builder: (context) => const SignIn(),
            //   // ),
            context.go('/chatScreen');
            // );
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
