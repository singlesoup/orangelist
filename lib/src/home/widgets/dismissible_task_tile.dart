import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart'
    show
        Alignment,
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Container,
        DismissDirection,
        Dismissible,
        EdgeInsets,
        Key,
        Radius,
        StatelessWidget,
        Widget;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:orangelist/src/constants/strings.dart' show dismissibleTileKey;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/delete_alert_dialog.dart'
    show showAlertBeforDeleting;
import 'package:orangelist/src/home/widgets/flushbar/custom_flushbar.dart'
    show showCustomFlushBar;
import 'package:orangelist/src/home/widgets/task_tile_widget.dart'
    show TaskTileWidget;
import 'package:orangelist/src/theme/colors.dart' show sandAccent;
import 'package:provider/provider.dart' show ReadContext;

class DismissibleTaskTile extends StatelessWidget {
  const DismissibleTaskTile({
    super.key,
    required this.title,
    required this.index,
  });
  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.horizontal,
      key: Key('$dismissibleTileKey$title-$index'),
      confirmDismiss: (direction) async {
        TodoProvider todoProvider = context.read<TodoProvider>();
        bool buttonDisable = todoProvider.todoIndex != -1;
        bool isCompleted = todoProvider.dailyToDolist.isEmpty
            ? false
            : todoProvider.dailyToDolist[index].isCompleted;

        if (direction == DismissDirection.startToEnd && !isCompleted) {
          todoProvider.todoIndex = index;
          return false;
        } else if (direction == DismissDirection.endToStart && !buttonDisable) {
          showAlertBeforDeleting(
            context,
            todoProvider,
            index,
          ).then((val) {
            return val;
          });
        }
        if (buttonDisable) {
          String msg = "You are editing a task. Can't delete.";
          showCustomFlushBar(context, msg, false);
        }
        return false;
      },
      background: swipeWidgets(true),
      secondaryBackground: swipeWidgets(false),
      child: TaskTileWidget(
        taskTitle: title,
        index: index,
      ),
    );
  }

  Widget swipeWidgets(bool isEdit) {
    return Container(
      decoration: BoxDecoration(
        color: isEdit
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
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
      alignment: isEdit ? Alignment.centerLeft : Alignment.centerRight,
      child: FaIcon(
        isEdit ? FontAwesomeIcons.pencil : FontAwesomeIcons.trashCan,
        color: sandAccent,
      ),
    );
  }
}
