import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_widget.dart';
import 'textfont_getter.dart';
import 'onboarding_pages.dart'; // Import the new split file

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    controller.addListener(() {
      setState(() {
        _pageIndex = controller.page!.round();
      });
    });

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
          if (_pageIndex != 2)
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
            ),
        ],
      ),
      floatingActionButton: _pageIndex != 2
          ? FloatingActionButton(
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
      )
          : null,
    );
  }
}