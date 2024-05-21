import 'package:flutter/material.dart'
    show CircleAvatar, ColorScheme, Scaffold, Theme;
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
        ListView,
        MainAxisAlignment,
        MainAxisSize,
        Padding,
        Radius,
        Row,
        SafeArea,
        SingleChildScrollView,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:orangelist/src/home/widgets/create_task_bar.dart'
    show CreateTaskBar;
import 'package:orangelist/src/home/widgets/task_tile_widget.dart';

import 'package:orangelist/src/theme/colors.dart'
    show bgDark, sandAccent, themeColor;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List dailyToDolist = [];
  int completedCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
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
                          "$completedCount/${dailyToDolist.length}",
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
              CreateTaskBar(
                onPressed: (String text) {
                  // todoProvider.addTodo(text);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 18,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.fromSwatch(
                      accentColor: themeColor.withOpacity(0.2),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: dailyToDolist.length,
                    itemBuilder: (context, index) {
                      return TaskTileWidget(
                        taskTitle: dailyToDolist[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
