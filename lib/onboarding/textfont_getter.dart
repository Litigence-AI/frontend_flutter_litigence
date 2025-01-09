import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign? textAlign;
  final Color? color;
  final TextDecoration? decoration;

  const CustomText({
    super.key,
    required this.text,
    required BuildContext context,
    required this.fontWeight,
    required this.fontSize,
    this.textAlign,
    this.color,
    this.decoration,
  });

  TextStyle _getTextStyle(
    BuildContext context,
    FontWeight fontWeight,
    double fontSize,
  ) {
    // Get the base style from theme
    final TextStyle? baseStyle = Theme.of(context).textTheme.bodyLarge;

    // Calculate responsive font size
    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth < 600
        ? 1.0
        : screenWidth < 1200
            ? 1.2
            : 1.4;

    // Limit the font size growth
    double adjustedFontSize = (fontSize * scaleFactor).clamp(12.0, 34.0);

    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: adjustedFontSize,
      fontWeight: fontWeight,
      color:
          color ?? baseStyle?.color ?? Theme.of(context).colorScheme.onSurface,
      decoration: decoration,
      height: 1.2, // Comfortable line height
      letterSpacing: 0.15, // Subtle letter spacing for better readability
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getTextStyle(
        context,
        fontWeight,
        fontSize,
      ),
      textAlign: textAlign,
      softWrap: true,
    );
  }
}
