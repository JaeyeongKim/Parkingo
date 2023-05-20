import 'package:flutter/material.dart';

class CircleEmpty extends StatelessWidget {
  final double widthP;

  const CircleEmpty({Key? key, required this.widthP}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widthP,
      width: widthP,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
          shape: BoxShape.circle),
    );
  }
}