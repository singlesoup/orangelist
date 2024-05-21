import 'package:hive_flutter/hive_flutter.dart';

import 'package:orangelist/src/home/data/todo_list.dart'
    show TodoList, TodoListAdapter;
import 'package:orangelist/src/home/data/todo_model.dart'
    show TodoModel, TodoModelAdapter;

const String _todos = 'todos';

const String todosHive = 'TodoHive';

Future<void> initHive({
  String? subDir,
}) async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(TodoListAdapter());

  Hive.openBox<TodoList>(_todos);
}

TodoList getTodos() {
  final Box<TodoList> box = Hive.box(_todos);
  TodoList? todos = box.get(todosHive);
  return todos ?? TodoList(todos: []);
}

Future<void> putTodo(TodoList newTodo) async {
  final Box<TodoList> box = Hive.box(_todos);
  await box.put(todosHive, newTodo);
}

void updateHiveTodo({
  required int index,
  bool? isCompleted,
  String? title,
}) {
  final Box<TodoList> box = Hive.box(_todos);
  final todoList = box.getAt(0);
  final TodoModel? todo = todoList!.todos?[index];
  // for status udpate
  if (isCompleted != null) {
    todo!.isCompleted = isCompleted;
  }

  // for title update
  if (title != null) {
    todo!.title = title;
  }
  box.putAt(0, todoList);
}
