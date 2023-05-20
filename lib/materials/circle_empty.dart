import 'package:flutter/material.dart';

class CircleYellow extends StatelessWidget {
  final double widthP;

  const CircleYellow({Key? key, required this.widthP}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widthP,
      width: widthP,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xffFFDD95),
          shape: BoxShape.circle),
    );
  }
}