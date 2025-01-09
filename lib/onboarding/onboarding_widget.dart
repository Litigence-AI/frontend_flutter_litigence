import 'package:flutter/material.dart';

import 'textfont_getter.dart';
import '../utils/size_config.dart';

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
    // Initialize SizeConfig
    SizeConfig().init(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalScreenWidth(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: SizeConfig.getProportionalScreenHeight(20)),
                    // Image with responsive sizing
                    SizedBox(
                      height: SizeConfig.getProportionalScreenHeight(250),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: SizeConfig.getProportionalScreenHeight(20)),
                    // Title with responsive text
                    CustomText(
                      text: title,
                      context: context,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.getProportionalScreenWidth(24),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.getProportionalScreenHeight(20)),
                    // Description with responsive text
                    CustomText(
                      text: description,
                      context: context,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.getProportionalScreenWidth(16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.getProportionalScreenHeight(20)),
                    if (child != null) child!,
                    SizedBox(height: SizeConfig.getProportionalScreenHeight(20)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}