import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox(
      {super.key, required this.isChecked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorCodeMap = {
      'Green': Colors.green,
      'Black': Colors.black,
    };

    final fontWeightMap = {
      'Semi Bold': FontWeight.w600,
    };

    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return colorCodeMap['Green'];
              }
              return null;
            },
          ),
          side: BorderSide(color: colorCodeMap['Green']!),
          value: isChecked,
          onChanged: onChanged,
        ),
        Text(
          "Remember me",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: fontWeightMap['Semi Bold'],
            color: colorCodeMap['Black'],
          ),
        ),
      ],
    );
  }
}
