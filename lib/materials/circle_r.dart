import 'package:flutter/material.dart';

class CircleRed extends StatelessWidget {
  final double widthP;

  const CircleRed({Key? key, required this.widthP}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widthP,
      width: widthP,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xffFC887B),
          shape: BoxShape.circle),
    );
  }
}