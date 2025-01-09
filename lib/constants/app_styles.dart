import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color(0xFFE0AC94);
  static const Color backgroundColor = Color(0xFFF5EAE5);
  
  static TextStyle getTextStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}