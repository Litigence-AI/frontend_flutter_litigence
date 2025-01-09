import 'package:Litigence/onboarding/onboarding_pages.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int _pageIndex = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    setState(() {
      _pageIndex = controller.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final screenWidth = MediaQuery.of(context).size.width; // Store screen width in a variable

    // Clamp dot width between minimum and maximum values
    final double dotWidth = screenWidth * 0.015;
    final double activeDotWidth = screenWidth * 0.03;
    final double minDotWidth = 6.5;
    final double maxDotWidth = 12.0;

    final double clampedDotWidth = dotWidth.clamp(minDotWidth, maxDotWidth);
    final double clampedActiveDotWidth = activeDotWidth.clamp(minDotWidth, maxDotWidth);

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                padding: EdgeInsets.only(
                  bottom: SizeConfig.getProportionalScreenHeight(20),
                  top: SizeConfig.getProportionalScreenHeight(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotsIndicator(
                      dotsCount: 3,
                      position: _pageIndex,
                      decorator: DotsDecorator(
                        size: Size.square(clampedDotWidth), // Use clamped width for size
                        activeSize: Size(clampedActiveDotWidth, clampedDotWidth),
                        activeColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme
                            ?.primaryContainer,
                        color: Colors.white,
                        shape: const CircleBorder(
                          side: BorderSide(width: 1.0, color: Colors.black),
                        ),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: _pageIndex != 2
          ? Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.getProportionalScreenHeight(20),
                right: SizeConfig.getProportionalScreenWidth(20),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_forward),
              ),
            )
          : null,
    );
  }
}
