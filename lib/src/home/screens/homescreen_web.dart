import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart'
    show ColorScheme, ReorderableListView, Scaffold, Theme, debugPrint;
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
        LayoutBuilder,
        ListView,
        MainAxisSize,
        Padding,
        SafeArea,
        SingleChildScrollView,
        State,
        StatefulWidget,
        Widget;
import 'package:orangelist/src/constants/strings.dart'
    show listViewKey, reorderableListKey;

import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/about_banner.dart' show AboutBanner;
import 'package:orangelist/src/home/widgets/create_task_bar.dart'
    show CreateTaskBar;
import 'package:orangelist/src/home/widgets/dismissible_task_tile.dart'
    show DismissibleTaskTile;
import 'package:orangelist/src/home/widgets/no_todo.dart' show NoTodos;
import 'package:orangelist/src/home/widgets/reorder_tile.dart' show ReOrderTile;
import 'package:orangelist/src/home/widgets/task_tile_widget.dart'
    show TaskTileWidget;
import 'package:orangelist/src/home/widgets/top_bar.dart' show TopBar;

import 'package:orangelist/src/theme/colors.dart' show bgDark, themeColor;
import 'package:provider/provider.dart' show Consumer;

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            debugPrint(constraints.maxHeight.toString());
            // Define the ratio between the top and bottom sections
            double topPartRatio = 0.4; // 40% of the screen height for top
            double bottomPartRatio = 0.6; // 60% for bottom
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: (topPartRatio * 100).toInt(), // 40% of the height
                  fit: FlexFit.loose,
                  child: const SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AboutBanner(),
                        TopBar(),
                        CreateTaskBar(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: (bottomPartRatio * 100).toInt(), // 60% of the height
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
                                          key: const Key(reorderableListKey),
                                          shrinkWrap: true,
                                          onReorder:
                                              (int oldIndex, int newIndex) {
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
                                          key: const Key(listViewKey),
                                          shrinkWrap: true,
                                          itemCount: todoprovider.focusMode
                                              ? 1
                                              : todoprovider
                                                  .dailyToDolist.length,
                                          itemBuilder: (context, index) {
                                            if (todoprovider.focusMode) {
                                              int incompleteIndex =
                                                  findTheCorrectIndex(
                                                      todoprovider
                                                          .dailyToDolist);
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
                                              String taskTitle = todoprovider
                                                  .dailyToDolist[index].title;
                                              return (kIsWeb ||
                                                      todoprovider.toTestForWeb)
                                                  ? TaskTileWidget(
                                                      taskTitle: taskTitle,
                                                      index: index,
                                                    )
                                                  : DismissibleTaskTile(
                                                      title: taskTitle,
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
            );
          },
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
