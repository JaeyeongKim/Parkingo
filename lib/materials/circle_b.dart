import 'package:flutter/material.dart';

class CircleBlue extends StatelessWidget {
  final double widthP;

  const CircleBlue({Key? key, required this.widthP}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widthP,
      width: widthP,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xff86E3CE),
          shape: BoxShape.circle),
    );
  }
}