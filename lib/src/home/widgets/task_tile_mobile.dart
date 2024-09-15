import 'package:flutter/foundation.dart' show Key, debugPrint;

import 'package:flutter/widgets.dart'
    show
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Container,
        Curves,
        DragUpdateDetails,
        EdgeInsets,
        Expanded,
        FontWeight,
        GestureDetector,
        MainAxisAlignment,
        Radius,
        RoundedRectangleBorder,
        Row,
        ShapeDecoration,
        SizedBox,
        State,
        StatefulWidget,
        Widget;
import 'package:orangelist/src/constants/strings.dart' show statusUpdateTodoKey;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/delete_alert_dialog.dart'
    show showAlertBeforDeleting;
import 'package:orangelist/src/home/widgets/line_through_text.dart'
    show LineThroughText;
import 'package:orangelist/src/theme/colors.dart' show sandAccent;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;
import 'package:provider/provider.dart' show Consumer;

class TaskTileMobile extends StatefulWidget {
  const TaskTileMobile({
    super.key,
    required this.title,
    required this.index,
  });

  final String title;
  final int index;

  @override
  State<TaskTileMobile> createState() => _TaskTileMobileState();
}

class _TaskTileMobileState extends State<TaskTileMobile> {
  DateTime? lastUpdateTime;

  void handleDragUpdate(DragUpdateDetails details, TodoProvider todoProvider) {
    final currentTime = DateTime.now();
    // This block will only execute every 200 milliseconds
    if (lastUpdateTime == null ||
        currentTime.difference(lastUpdateTime!).inMilliseconds > 200) {
      lastUpdateTime = currentTime;
      bool status = todoProvider.dailyToDolist[widget.index].isCompleted;
      if (details.delta.dx > 0) {
        bool isCompleted = true;
        if (isCompleted != status) {
          debugPrint('Dragging left to right');
          todoProvider.updateTodoStatus(
            widget.index,
            isCompleted,
            context,
          );
        }
      } else if (details.delta.dx < 0) {
        bool isCompleted = false;

        if (isCompleted != status) {
          debugPrint('Dragging right to left');
          todoProvider.updateTodoStatus(
            widget.index,
            isCompleted,
            context,
          );
        }
      }
    }
  }

  onEditTodo(TodoProvider todoProvider) {
    bool status = todoProvider.dailyToDolist[widget.index].isCompleted;
    if (!status) {
      todoProvider.todoIndex = widget.index;
    }
  }

  onDeleteTodo(TodoProvider todoProvider) {
    bool buttonDisable = todoProvider.todoIndex != -1;
    if (!buttonDisable) {
      showAlertBeforDeleting(
        context,
        todoProvider,
        widget.index,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        bool isCompleted = todoProvider.dailyToDolist.isEmpty
            ? false
            : todoProvider.dailyToDolist[widget.index].isCompleted;

        return GestureDetector(
          key: const Key(statusUpdateTodoKey),
          onHorizontalDragUpdate: (details) =>
              handleDragUpdate(details, todoProvider),
          onDoubleTap: () => onEditTodo(todoProvider),
          onLongPress: () => onDeleteTodo(todoProvider),
          child: Container(
            key: Key('${widget.title}-${widget.index}'),
            decoration: BoxDecoration(
              color: sandAccent.withOpacity(0.08),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
              border: Border.all(
                color: sandAccent,
                width: 0.5,
              ),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 2,
              vertical: 8,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 3,
                        width: 18,
                        padding: const EdgeInsets.all(8.0),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(),
                          color: sandAccent,
                        ),
                      ),
                      if (!isCompleted)
                        const SizedBox(
                          width: 6,
                        ),
                      Expanded(
                        child: LineThroughText(
                          text: widget.title,
                          curve: Curves.decelerate,
                          duration: const Duration(
                            milliseconds: 600,
                          ),
                          textStyle: sfTextTheme.titleMedium!.copyWith(
                            color: sandAccent,
                            fontWeight: FontWeight.w700,
                            decorationColor: sandAccent,
                          ),
                          isCompleted: isCompleted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
