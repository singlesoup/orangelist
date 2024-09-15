import 'package:flutter/material.dart' show ReorderableListView, StatefulWidget;
import 'package:flutter/widgets.dart' show BuildContext, Key, State, Widget;
import 'package:orangelist/src/constants/strings.dart' show reorderableListKey;
import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;

import 'package:orangelist/src/home/widgets/reorder_tile.dart' show ReOrderTile;
import 'package:provider/provider.dart' show ReadContext;

class SmoothReorderableListview extends StatefulWidget {
  const SmoothReorderableListview({super.key});

  @override
  State<SmoothReorderableListview> createState() =>
      _SmoothReorderableListviewState();
}

class _SmoothReorderableListviewState extends State<SmoothReorderableListview> {
  late TodoProvider todoProvider;
  List<TodoModel> _todos = [];

  @override
  void initState() {
    super.initState();
    todoProvider = context.read<TodoProvider>();
    _todos = todoProvider.dailyToDolist;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      buildDefaultDragHandles: false,
      key: const Key(reorderableListKey),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          todoProvider.onReorder(
            oldIndex,
            newIndex,
            context,
          );
        });
      },
      children: [
        for (int index = 0; index < _todos.length; index++)
          ReOrderTile(
            key: Key('$index'),
            index: index,
            title: _todos[index].title,
          ),
      ],
    );
  }
}
