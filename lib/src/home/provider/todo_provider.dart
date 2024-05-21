import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:orangelist/src/home/data/todo_list.dart' show TodoList;
import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;
import 'package:orangelist/src/utils/hive_service.dart'
    show getTodos, putTodo, updateHiveTodo;

class TodoProvider extends ChangeNotifier {
  List<TodoModel> _dailyToDolist = [];

  List get dailyToDolist => _dailyToDolist;

  int _completedCount = 0;

  int get completedCount => _completedCount;

  TodoProvider() {
    /// get data from hive
    TodoList hiveList = getTodos();
    _dailyToDolist = hiveList.todos!;
  }
  void addTodo(String todo) {
    if (todo.isEmpty) {
      throw ArgumentError("Todo text cannot be empty!");
    }
    _dailyToDolist.add(TodoModel(
      title: todo,
      isCompleted: false,
    ));
    putTodo(TodoList(todos: _dailyToDolist));
    notifyListeners();
  }

  void deleteTodo(int index) {
    if (index < 0 || index >= _dailyToDolist.length) {
      throw RangeError("Invalid index provided for deletion!");
    }
    _dailyToDolist.removeAt(index);
    putTodo(TodoList(todos: _dailyToDolist));
    notifyListeners();
  }

  void updateTodo(int index, String newText) {
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
    notifyListeners();
  }

  updateTodoStatus(int index, bool isCompleted) {
    if (index < 0 || index >= _dailyToDolist.length) {
      throw RangeError("Invalid index provided for update!");
    }
    _dailyToDolist[index].isCompleted = isCompleted;
    if (isCompleted) {
      _completedCount++;
    } else {
      _completedCount--;
    }
    updateHiveTodo(
      index: index,
      isCompleted: isCompleted,
    );
    notifyListeners();
  }
}
