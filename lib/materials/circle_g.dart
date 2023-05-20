import 'package:flutter/material.dart';

class CircleGreen extends StatelessWidget {
  final double widthP;

  const CircleGreen({Key? key, required this.widthP}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widthP,
      width: widthP,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xffD0E6A5),
          shape: BoxShape.circle),
    );
  }
}