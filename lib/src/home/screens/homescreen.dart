import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart'
    show ColorScheme, ReorderableListView, Scaffold, Theme;
import 'package:flutter/widgets.dart'
    show
        Align,
        Alignment,
        AnimatedSwitcher,
        Animation,
        BuildContext,
        Column,
        Container,
        EdgeInsets,
        Expanded,
        FadeTransition,
        FlexFit,
        Flexible,
        Key,
        ListView,
        MainAxisSize,
        Padding,
        SafeArea,
        SingleChildScrollView,
        State,
        StatefulWidget,
        ValueKey,
        Widget;
import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;

import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/about_banner.dart' show AboutBanner;
import 'package:orangelist/src/home/widgets/create_task_bar.dart'
    show CreateTaskBar;
import 'package:orangelist/src/home/widgets/no_todo.dart' show NoTodos;
import 'package:orangelist/src/home/widgets/reorder_tile.dart' show ReOrderTile;
import 'package:orangelist/src/home/widgets/task_tile_widget.dart'
    show TaskTileWidget;
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
              flex: kIsWeb ? 4 : 2,
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AboutBanner(),
                    TopBar(),
                    CreateTaskBar(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: kIsWeb ? 5 : 2,
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
                                  ? ReorderableListView(
                                      key:
                                          const ValueKey('ReorderableListView'),
                                      shrinkWrap: true,
                                      onReorder: (int oldIndex, int newIndex) {
                                        todoprovider.onReorder(
                                          oldIndex,
                                          newIndex,
                                          context,
                                        );
                                      },
                                      buildDefaultDragHandles: false,
                                      children: [
                                        for (int index = 0;
                                            index <
                                                todoprovider
                                                    .dailyToDolist.length;
                                            index++)
                                          ReOrderTile(
                                            key: Key('$index'),
                                            index: index,
                                            title: todoprovider
                                                .dailyToDolist[index].title,
                                          ),
                                      ],
                                    )
                                  : ListView.builder(
                                      key: const ValueKey('ListView'),
                                      shrinkWrap: true,
                                      itemCount: todoprovider.focusMode
                                          ? 1
                                          : todoprovider.dailyToDolist.length,
                                      itemBuilder: (context, index) {
                                        if (todoprovider.focusMode) {
                                          int incompleteIndex =
                                              findTheCorrectIndex(
                                                  todoprovider.dailyToDolist);
                                          return incompleteIndex == -1
                                              ? Container()
                                              : TaskTileWidget(
                                                  taskTitle: todoprovider
                                                      .dailyToDolist[
                                                          incompleteIndex]
                                                      .title,
                                                  index: incompleteIndex,
                                                );
                                        } else {
                                          return TaskTileWidget(
                                            taskTitle: todoprovider
                                                .dailyToDolist[index].title,
                                            index: index,
                                          );
                                        }
                                      },
                                    ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Finds the first index which is still not finished
  int findTheCorrectIndex(List<TodoModel> todoList) {
    int index = todoList.indexWhere((element) => !element.isCompleted);
    return index;
  }
}
