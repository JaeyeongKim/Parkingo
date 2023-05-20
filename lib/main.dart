import 'package:flutter/material.dart';
import 'package:parkingo/providers/continuous_provider.dart';
import 'package:parkingo/providers/once_provider.dart';
import 'package:parkingo/screens/splash_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProviderOnce()),
      ChangeNotifierProvider(create: (_) => ProviderContinue()),
      ],
      child:const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parkingo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

