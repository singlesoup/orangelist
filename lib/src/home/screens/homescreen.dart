import 'package:flutter/material.dart'
    show ColorScheme, ReorderableListView, Scaffold, Theme;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        Key,
        ListView,
        MainAxisSize,
        Padding,
        SafeArea,
        SingleChildScrollView,
        State,
        StatefulWidget,
        Widget;

import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/about_banner.dart' show AboutBanner;
import 'package:orangelist/src/home/widgets/create_task_bar.dart'
    show CreateTaskBar;
import 'package:orangelist/src/home/widgets/no_todo.dart';
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AboutBanner(),
              const TopBar(),
              const CreateTaskBar(),
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
                  child: Consumer<TodoProvider>(
                    builder: (context, todoprovider, child) {
                      bool isReordering = todoprovider.isReorder;
                      return todoprovider.dailyToDolist.isEmpty
                          ? const NoTodos()
                          : isReordering &&
                                  todoprovider.dailyToDolist.length > 1
                              ? ReorderableListView(
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
                                            todoprovider.dailyToDolist.length;
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
                                  shrinkWrap: true,
                                  itemCount: todoprovider.dailyToDolist.length,
                                  itemBuilder: (context, index) {
                                    return TaskTileWidget(
                                      taskTitle: todoprovider
                                          .dailyToDolist[index].title,
                                      index: index,
                                    );
                                  },
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
