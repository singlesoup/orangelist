import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:orangelist/src/home/data/todo_list.dart' show TodoList;
import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;
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

  String editTodo() {
    return _todoIndex == -1 ? '' : _dailyToDolist[_todoIndex].title;
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

  /// For reOrder switch
  bool _isReorder = false;

  bool get isReorder => _isReorder;

  set isReorder(bool newBool) {
    _isReorder = newBool;
    notifyListeners();
  }

  onReorder(int oldIndex, int newIndex) {
    // if (oldIndex < 0 || oldIndex >= _dailyToDolist.length) {
    //   throw RangeError("Invalid oldIndex $oldIndex provided for update!");
    // }

    // if (newIndex < 0 || newIndex >= _dailyToDolist.length) {
    //   throw RangeError("Invalid newIndex $newIndex provided for update!");
    // }
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
