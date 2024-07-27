import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors, IconButton;
import 'package:flutter/widgets.dart'
    show
        Border,
        BorderRadius,
        BoxConstraints,
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
        MainAxisAlignment,
        Radius,
        Row,
        ShapeDecoration,
        SizedBox,
        StatelessWidget,
        Widget;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/delete_alert_dialog.dart'
    show showAlertBeforDeleting;
import 'package:orangelist/src/home/widgets/line_through_text.dart'
    show LineThroughText;
import 'package:orangelist/src/theme/colors.dart' show sandAccent, themeColor;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;
import 'package:provider/provider.dart' show Consumer;

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
        builder: (context, todoProvider, child) {
          bool buttonDisable = todoProvider.todoIndex != -1;
          bool isCompleted = todoProvider.dailyToDolist.isEmpty
              ? false
              : todoProvider.dailyToDolist[index].isCompleted;
          bool forReorder = todoProvider.isReorder;
          bool focusMode = todoProvider.focusMode;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (!buttonDisable && !forReorder)
                      GestureDetector(
                        onTap: () {
                          isCompleted = !isCompleted;
                          todoProvider.updateTodoStatus(
                            index,
                            isCompleted,
                            context,
                          );
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
              if (!forReorder && !focusMode && kIsWeb)
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
                                todoProvider.todoIndex = index;
                              },
                        icon: FaIcon(
                          FontAwesomeIcons.pencil,
                          color: isCompleted ? Colors.grey[600] : sandAccent,
                          size: 18,
                        ),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                      ),
                      IconButton(
                        onPressed: buttonDisable
                            ? null
                            : () {
                                showAlertBeforDeleting(
                                  context,
                                  todoProvider,
                                  index,
                                );
                              },
                        splashColor: Colors.red.withOpacity(0.8),
                        icon: FaIcon(
                          FontAwesomeIcons.trashCan,
                          color: buttonDisable ? Colors.grey[600] : sandAccent,
                          size: 18,
                        ),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
