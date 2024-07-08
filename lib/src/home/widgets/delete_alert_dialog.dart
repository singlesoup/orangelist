import 'package:flutter/widgets.dart' show BuildContext, Navigator, Text;
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'
    show PlatformAlertDialog, PlatformDialogAction, showPlatformDialog;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;

showAlertBeforDeleting(
  BuildContext context,
  TodoProvider todo,
  int index,
) async {
  showPlatformDialog(
    context: context,
    builder: (_) => PlatformAlertDialog(
      title: Text(
        "Deleting Todo?",
        style: sfTextTheme.titleLarge,
      ),
      content: Text(
        "Are you sure you want to delete this Todo?",
        style: sfTextTheme.bodyLarge,
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: sfTextTheme.labelLarge,
          ),
        ),
        PlatformDialogAction(
          onPressed: () {
            todo.deleteTodo(index);
            Navigator.of(context).pop();
          },
          child: Text(
            'Ok',
            style: sfTextTheme.labelLarge,
          ),
        ),
      ],
    ),
  );
}
