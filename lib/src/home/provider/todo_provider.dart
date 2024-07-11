import 'package:flutter/widgets.dart' show BuildContext, ChangeNotifier;
import 'package:orangelist/src/constants/strings.dart'
    show todoAddedTxt, todoDeletedTxt, todoUpdatedTxt;
import 'package:orangelist/src/home/data/todo_list.dart' show TodoList;
import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;
import 'package:orangelist/src/home/widgets/flushbar/custom_flushbar.dart'
    show showCustomFlushBar;
import 'package:orangelist/src/utils/hive_service.dart'
    show getTodos, putTodo, updateHiveTodo;

class TodoProvider extends ChangeNotifier {
  TodoProvider() {
    getData();
  }

  List<TodoModel> _dailyToDolist = [];

  List<TodoModel> get dailyToDolist => _dailyToDolist;

  int _completedCount = 0;

  int get completedCount => _completedCount;

  int _todoIndex = -1;
  int get todoIndex => _todoIndex;

  set todoIndex(int newIndex) {
    _todoIndex = newIndex;
    notifyListeners();
  }

  void getData() {
    TodoList hiveList = getTodos();
    _dailyToDolist = hiveList.todos!;
    updateCompletedCount();
  }

  void updateCompletedCount() {
    _completedCount = _dailyToDolist.where((todo) => todo.isCompleted).length;
  }

  void addTodo(String todo, BuildContext context) {
    if (todo.isEmpty) {
      throw ArgumentError("Todo text cannot be empty!");
    }
    _dailyToDolist.add(TodoModel(
      title: todo,
      isCompleted: false,
    ));
    putTodo(TodoList(todos: _dailyToDolist));
    showCustomFlushBar(context, todoAddedTxt);
    notifyListeners();
  }

  String editTodo() {
    return _todoIndex == -1 ? '' : _dailyToDolist[_todoIndex].title;
  }

  void deleteTodo(int index, BuildContext context) {
    if (index < 0 || index >= _dailyToDolist.length) {
      throw RangeError("Invalid index provided for deletion!");
    }
    _dailyToDolist.removeAt(index);
    updateCompletedCount();
    putTodo(TodoList(todos: _dailyToDolist));
    showCustomFlushBar(context, todoDeletedTxt);
    notifyListeners();
  }

  void updateTodo(int index, String newText, BuildContext context) {
    if (index < 0 || index >= _dailyToDolist.length) {
      throw RangeError("Invalid index provided for update!");
    }
    if (newText.isEmpty) {
      throw ArgumentError("Todo text cannot be empty!");
    }
    _dailyToDolist[index].title = newText;
    updateHiveTodo(
      index: index,
      title: newText,
    );
    showCustomFlushBar(context, todoUpdatedTxt);
    notifyListeners();
  }

  updateTodoStatus(int index, bool isCompleted, BuildContext context) {
    if (index < 0 || index >= _dailyToDolist.length) {
      throw RangeError("Invalid index provided for update!");
    }
    _dailyToDolist[index].isCompleted = isCompleted;
    updateCompletedCount();

    updateHiveTodo(
      index: index,
      isCompleted: isCompleted,
    );
    showCustomFlushBar(context, todoUpdatedTxt);
    notifyListeners();
  }

  /// For reOrder switch
  bool _isReorder = false;

  bool get isReorder => _isReorder;

  set isReorder(bool newBool) {
    _isReorder = newBool;
    notifyListeners();
  }

  onReorder(int oldIndex, int newIndex, BuildContext context) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    TodoModel item = _dailyToDolist[oldIndex];
    _dailyToDolist.removeAt(oldIndex);
    _dailyToDolist.insert(newIndex, item);

    putTodo(TodoList(todos: _dailyToDolist));
    notifyListeners();
  }
}
