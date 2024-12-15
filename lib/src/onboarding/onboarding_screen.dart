import 'package:flutter/material.dart';
import 'textfont_getter.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'onboarding_widget.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:shared_preferences/shared_preferences.dart';

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
      title: "Meet LexMachine ⚖️",
      description:
          "Welcome to LexMachine, your AI-powered legal assistant. Designed for India, it simplifies law, provides accurate insights, and empowers you to make informed decisions.",
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingWidget(
      imagePath: 'assets/onboard/onboard_2.png',
      title: "Multilingual & User-Friendly 🌐",
      description:
          "Access legal information in your preferred language. LexMachine breaks down complex legal terms into simple, actionable insights for everyone.",
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
      title: "Your Trusted Legal Partner 🔒",
      description:
          "From personal queries to professional research, LexMachine offers secure, reliable guidance backed by authentic sources. Your privacy is always our priority.",
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
           _completeOnboarding(context);
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
