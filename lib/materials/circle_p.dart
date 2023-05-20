import 'package:flutter/material.dart';

class CirclePurple extends StatelessWidget {
  final double widthP;

  const CirclePurple({Key? key, required this.widthP}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widthP,
      width: widthP,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xffCCABDA),
          shape: BoxShape.circle),
    );
  }
}