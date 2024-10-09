import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/src/theme/color_code.dart';

class LogoButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;

  const LogoButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
  }); // Pass key to super constructor

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: key, // Pass key to TextButton
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
}
