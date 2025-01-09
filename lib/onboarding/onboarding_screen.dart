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
                        size: Size.square(SizeConfig.getProportionalScreenWidth(9)),
                        activeSize: Size(
                          SizeConfig.getProportionalScreenWidth(18),
                          SizeConfig.getProportionalScreenWidth(9),
                        ),
                        // activeColor: const Color(0xFFE0AC94),
                        activeColor: Theme.of(context).buttonTheme.colorScheme?.primaryContainer,
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
                // backgroundColor: const Color(0xFFE0AC94),
                // foregroundColor: const Color(0xFFF5EAE5),
                child: const Icon(Icons.arrow_forward),
              ),
            )
          : null,
    );
  }
}