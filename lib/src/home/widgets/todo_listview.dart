import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart'
    show BuildContext, Container, Key, ListView, StatelessWidget, Widget;
import 'package:orangelist/src/constants/strings.dart' show listViewKey;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;

import 'package:orangelist/src/home/widgets/task_tile_mobile.dart'
    show TaskTileMobile;
import 'package:orangelist/src/home/widgets/task_tile_widget.dart'
    show TaskTileWidget;
import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;

class TodoListview extends StatelessWidget {
  const TodoListview({
    super.key,
    required this.todoprovider,
  });

  final TodoProvider todoprovider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key(listViewKey),
      shrinkWrap: true,
      itemCount: todoprovider.focusMode ? 1 : todoprovider.dailyToDolist.length,
      itemBuilder: (context, index) {
        if (todoprovider.focusMode) {
          int incompleteIndex = findTheCorrectIndex(todoprovider.dailyToDolist);
          return incompleteIndex == -1
              ? Container()
              : TaskTileWidget(
                  taskTitle: todoprovider.dailyToDolist[incompleteIndex].title,
                  index: incompleteIndex,
                );
        } else {
          String taskTitle = todoprovider.dailyToDolist[index].title;
          return (kIsWeb || todoprovider.toTestForWeb)
              ? TaskTileWidget(
                  taskTitle: taskTitle,
                  index: index,
                  // key: todoKey,
                )
              : TaskTileMobile(
                  // key: todoKey,
                  title: taskTitle,
                  index: index,
                );
        }
      },
    );
  }

  /// Finds the first index which is still not finished
  int findTheCorrectIndex(List<TodoModel> todoList) {
    int index = todoList.indexWhere((element) => !element.isCompleted);
    return index;
  }
}
