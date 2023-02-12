import 'package:flutter/material.dart';

import 'src/onboarding/on_boarding_screen.dart';
import 'src/theme/text_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: sfTextTheme,
        brightness: Brightness.dark,
      ),
      home: const OnBoardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
