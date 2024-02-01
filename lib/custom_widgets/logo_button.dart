import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gene/theme/color_code.dart';

Widget logoButton(String assetPath,VoidCallback onPressed) {
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: colorCodeMap['Border']!),
      ),
      backgroundColor: colorCodeMap['White'],
    ),
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.only(
        top: 9,
        bottom: 9,
        left: 22,
        right: 22,
      ),
      child: SvgPicture.asset(assetPath),
    ),
  );
}