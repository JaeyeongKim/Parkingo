import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkingo/notifications/notification.dart';
import 'package:parkingo/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(milliseconds: 2000), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder:
            (context) => const MainScreen()),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('./assets/splash.png'), // 배경 이미지
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
      ),
    );
  }
}
