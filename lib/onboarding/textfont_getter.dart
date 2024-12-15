import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      BuildContext context, FontWeight fontWeight, double fontSize) {
    return GoogleFonts.poppins(
      textStyle: Theme.of(context).textTheme.displayLarge,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
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
