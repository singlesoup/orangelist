import 'package:flutter/material.dart' show CircleAvatar, Scaffold, Theme;
import 'package:flutter/widgets.dart'
    show
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Center,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FontWeight,
        MainAxisAlignment,
        Radius,
        Row,
        SafeArea,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:orangelist/src/home/widgets/create_task_bar.dart'
    show CreateTaskBar;

import 'package:orangelist/src/theme/colors.dart'
    show bgDark, sandAccent, themeColor;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List dailyToDolist = ["Text", "tesr", "etset"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(34.0),
              margin: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: bgDark,
                borderRadius: const BorderRadius.all(
                  Radius.circular(28.0),
                ),
                border: Border.all(
                  color: sandAccent,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Todo Done',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'keep it up',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: sandAccent,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2.1,
                              fontSize: 22,
                            ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: themeColor,
                    child: Center(
                      child: Text(
                        "1/${dailyToDolist.length}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: bgDark,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CreateTaskBar(),
          ],
        ),
      ),
    );
  }
}
