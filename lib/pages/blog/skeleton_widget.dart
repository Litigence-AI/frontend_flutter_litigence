
import 'package:flutter/material.dart';
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 186, 180, 180).withOpacity(0.04),
        borderRadius: const BorderRadius.all(
          Radius.circular(16)
        )
      )
    );
  }
}