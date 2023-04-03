import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orangelist/src/theme/colors.dart';

import 'on_board_progress_painter.dart';

double diameter = 180;

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  double percentage = 10.0;
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(seconds: 1), () {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (percentage < 90.0) {
      startTheTicker();
    } else {
      _timer.cancel();
      //   percentage = 0;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
            ),
          ),
          CustomPaint(
            foregroundPainter: OnBoardProgressPainter(
              strokeWidth: 8.0,
              onBoardsNum: 3,
              color: themeColorLight.withOpacity(0.8),
              completePercent: percentage,
            ),
            size: Size(diameter, diameter),
          ),
        ],
      ),
    );
  }

  void startTheTicker() {
    _timer = Timer(
      const Duration(seconds: 1),
      () {
        setState(() {
          percentage += 10;
        });
      },
    );
  }
}
