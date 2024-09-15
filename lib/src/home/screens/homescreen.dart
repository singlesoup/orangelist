import 'package:flutter/material.dart' show ColorScheme, Scaffold, Theme;
import 'package:flutter/widgets.dart'
    show
        Align,
        Alignment,
        AnimatedSwitcher,
        Animation,
        BuildContext,
        Column,
        EdgeInsets,
        Expanded,
        FadeTransition,
        LayoutBuilder,
        MainAxisSize,
        Padding,
        SafeArea,
        State,
        StatefulWidget,
        Widget;

import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/about_banner.dart' show AboutBanner;
import 'package:orangelist/src/home/widgets/create_task_bar.dart'
    show CreateTaskBar;
import 'package:orangelist/src/home/widgets/smooth_reorderable_listview.dart'
    show SmoothReorderableListview;
import 'package:orangelist/src/home/widgets/no_todo.dart' show NoTodos;
import 'package:orangelist/src/home/widgets/todo_listview.dart'
    show TodoListview;
import 'package:orangelist/src/home/widgets/top_bar.dart' show TopBar;
import 'package:orangelist/src/theme/colors.dart' show bgDark, themeColor;
import 'package:provider/provider.dart' show Consumer;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AboutBanner(),
                    TopBar(),
                    CreateTaskBar(),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
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
                        child: Consumer<TodoProvider>(
                          builder: (context, todoprovider, child) {
                            bool isReordering = todoprovider.isReorder;

                            /// Smooth animation to transition between different list types
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: todoprovider.dailyToDolist.isEmpty
                                  ? const NoTodos()
                                  : isReordering &&
                                          todoprovider.dailyToDolist.length > 1
                                      ? const SmoothReorderableListview()
                                      : TodoListview(
                                          todoprovider: todoprovider,
                                        ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
