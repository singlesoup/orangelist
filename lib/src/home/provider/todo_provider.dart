import 'package:hive/hive.dart';

import 'package:flutter/widgets.dart' show BuildContext, ChangeNotifier;
import 'package:orangelist/src/constants/strings.dart'
    show todoAddedTxt, todoBoxHive, todoDeletedTxt, todoUpdatedTxt;
import 'package:orangelist/src/home/data/todo_list.dart' show TodoList;
import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;
import 'package:orangelist/src/home/widgets/flushbar/custom_flushbar.dart'
    show showCustomFlushBar;
import 'package:orangelist/src/utils/hive_service.dart'
    show putTodo, updateHiveTodo;
import 'package:universal_io/io.dart';

class TodoProvider extends ChangeNotifier {
  // Dependency Injection
  final Box<TodoList> todoBox;
  TodoProvider({required this.todoBox}) {
    getData();
  }
  bool isTestMode = Platform.environment.containsKey('FLUTTER_TEST');

  // Set this to true to test for web env specific code
  bool toTestForWeb = false;

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

  /// Gives to-dos from hive
  void getData() {
    TodoList? hiveList = todoBox.get(todoBoxHive);
    _dailyToDolist = hiveList?.todos ?? [];
    updateCompletedCount();
  }

  void updateCompletedCount() {
    _completedCount = _dailyToDolist.where((todo) => todo.isCompleted).length;
  }

  Future<void> addTodo(String todo, BuildContext context) async {
    if (todo.isEmpty) {
      throw ArgumentError("Todo text cannot be empty!");
    }
    _dailyToDolist.add(TodoModel(
      title: todo,
      isCompleted: false,
    ));
    await putTodo(TodoList(todos: _dailyToDolist), todoBox);
    if (context.mounted && !isTestMode) {
      showCustomFlushBar(context, todoAddedTxt);
    }
    notifyListeners();
  }

  /// Sets the current index to the currently editing index
  String editTodo() {
    return _todoIndex == -1 ? '' : _dailyToDolist[_todoIndex].title;
  }

  Future<void> deleteTodo(int index, BuildContext context) async {
    if (index < 0 || index >= _dailyToDolist.length) {
      throw RangeError("Invalid index provided for deletion!");
    }
    _dailyToDolist.removeAt(index);
    updateCompletedCount();
    await putTodo(TodoList(todos: _dailyToDolist), todoBox);
    if (context.mounted && !isTestMode) {
      showCustomFlushBar(context, todoDeletedTxt);
    }
    notifyListeners();
  }

  /// Updates the text of the todo
  Future<void> updateTodo(
      int index, String newText, BuildContext context) async {
    if (index < 0 || index >= _dailyToDolist.length) {
      throw RangeError("Invalid index provided for update!");
    }
    if (newText.isEmpty) {
      throw ArgumentError("Todo text cannot be empty!");
    }
    _dailyToDolist[index].title = newText;
    await updateHiveTodo(
      index: index,
      title: newText,
      box: todoBox,
    );
    if (context.mounted && !isTestMode) {
      showCustomFlushBar(context, todoUpdatedTxt);
    }
    notifyListeners();
  }

  /// Updates the status of the todo
  Future<void> updateTodoStatus(
      int index, bool isCompleted, BuildContext context) async {
    if (index < 0 || index >= _dailyToDolist.length) {
      throw RangeError("Invalid index provided for update!");
    }
    _dailyToDolist[index].isCompleted = isCompleted;
    updateCompletedCount();

    await updateHiveTodo(
      index: index,
      isCompleted: isCompleted,
      box: todoBox,
    );
    if (context.mounted && !isTestMode) {
      showCustomFlushBar(context, todoUpdatedTxt);
    }
    notifyListeners();
  }

  /// For reOrder switch
  bool _isReorder = false;

  bool get isReorder => _isReorder;

  set isReorder(bool newBool) {
    _isReorder = newBool;
    _focusMode = false;
    notifyListeners();
  }

  Future<void> onReorder(
      int oldIndex, int newIndex, BuildContext context) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    TodoModel item = _dailyToDolist[oldIndex];
    _dailyToDolist.removeAt(oldIndex);
    _dailyToDolist.insert(newIndex, item);

    await putTodo(TodoList(todos: _dailyToDolist), todoBox);
    notifyListeners();
  }

  /// For Focus Mode switch
  bool _focusMode = false;
  bool get focusMode => _focusMode;

  set focusMode(bool newBool) {
    _focusMode = newBool;
    _isReorder = false;
    notifyListeners();
  }
}
