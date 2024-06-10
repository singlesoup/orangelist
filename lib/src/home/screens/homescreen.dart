import 'package:flutter/material.dart'
    show CircleAvatar, ColorScheme, ReorderableListView, Scaffold, Theme;

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
        Expanded,
        FontWeight,
        Key,
        ListView,
        MainAxisAlignment,
        MainAxisSize,
        Padding,
        Radius,
        Row,
        SafeArea,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/create_task_bar.dart'
    show CreateTaskBar;
import 'package:orangelist/src/home/widgets/reorder_switch.dart'
    show ReorderSwitch;
import 'package:orangelist/src/home/widgets/reorder_tile.dart' show ReOrderTile;
import 'package:orangelist/src/home/widgets/task_tile_widget.dart'
    show TaskTileWidget;

import 'package:orangelist/src/theme/colors.dart'
    show bgDark, sandAccent, themeColor;
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
                  width: 0.5,
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
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        'keep it up',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: sandAccent,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2.5,
                              fontSize: 22,
                            ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        child: ReorderSwitch(),
                      ),
                    ],
                  ),
                  Consumer<TodoProvider>(
                    builder: (context, todoprovider, child) {
                      int completedCount = todoprovider.completedCount;
                      int totalLength = todoprovider.dailyToDolist.length;
                      return CircleAvatar(
                        radius: 60,
                        backgroundColor: themeColor,
                        child: Center(
                          child: Text(
                            "$completedCount/$totalLength",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: bgDark,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const CreateTaskBar(),
            Expanded(
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
                      return isReordering
                          ? ReorderableListView(
                              onReorder: (int oldIndex, int newIndex) {
                                todoprovider.onReorder(oldIndex, newIndex);
                              },
                              buildDefaultDragHandles: false,
                              children: [
                                for (int index = 0;
                                    index < todoprovider.dailyToDolist.length;
                                    index++)
                                  ReOrderTile(
                                    key: Key('$index'),
                                    index: index,
                                    title:
                                        todoprovider.dailyToDolist[index].title,
                                  ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: todoprovider.dailyToDolist.length,
                              itemBuilder: (context, index) {
                                return TaskTileWidget(
                                  taskTitle:
                                      todoprovider.dailyToDolist[index].title,
                                  index: index,
                                );
                              },
                            );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
