import 'package:flutter/material.dart' show Colors, IconButton, Icons, Theme;
import 'package:flutter/widgets.dart'
    show
        Border,
        BorderRadius,
        BoxDecoration,
        BoxShape,
        BuildContext,
        CircleBorder,
        Container,
        Curves,
        EdgeInsets,
        Expanded,
        FontWeight,
        GestureDetector,
        Icon,
        MainAxisAlignment,
        Radius,
        Row,
        ShapeDecoration,
        SizedBox,
        StatelessWidget,
        Widget;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/line_through_text.dart'
    show LineThroughText;
import 'package:orangelist/src/theme/colors.dart' show sandAccent, themeColor;
import 'package:provider/provider.dart' show Consumer, ReadContext;

class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget({
    super.key,
    required this.taskTitle,
    required this.index,
  });

  final String taskTitle;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        vertical: 8,
        horizontal: 16,
      ),
      child: Consumer<TodoProvider>(
        builder: (context, todo, child) {
          bool buttonDisable = todo.todoIndex != -1;
          bool isCompleted = todo.dailyToDolist[index].isCompleted;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (!buttonDisable)
                      GestureDetector(
                        onTap: () {
                          isCompleted = !isCompleted;
                          todo.updateTodoStatus(index, isCompleted);
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          padding: const EdgeInsets.all(8.0),
                          decoration: !isCompleted
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeColor,
                                    width: 0.5,
                                  ),
                                )
                              : const ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: themeColor,
                                ),
                        ),
                      ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: LineThroughText(
                        text: taskTitle,
                        curve: Curves.decelerate,
                        duration: const Duration(
                          milliseconds: 600,
                        ),
                        textStyle:
                            Theme.of(context).textTheme.titleLarge!.copyWith(
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: isCompleted
                          ? null
                          : () {
                              context.read<TodoProvider>().todoIndex = index;
                            },
                      icon: Icon(
                        Icons.mode_edit_outline_outlined,
                        color: isCompleted ? Colors.grey[600] : sandAccent,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                    ),
                    IconButton(
                      onPressed: buttonDisable
                          ? null
                          : () {
                              todo.deleteTodo(index);
                            },
                      splashColor: Colors.red.withOpacity(0.8),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: buttonDisable ? Colors.grey[600] : sandAccent,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
