import 'package:hive_flutter/hive_flutter.dart';

import 'package:orangelist/src/constants/strings.dart'
    show todoBoxHive, todosHive;
import 'package:orangelist/src/home/data/todo_list.dart'
    show TodoList, TodoListAdapter;
import 'package:orangelist/src/home/data/todo_model.dart'
    show TodoModel, TodoModelAdapter;

Future<void> initHive({
  String? subDir,
}) async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(TodoListAdapter());
  await Hive.openBox<TodoList>(todoBoxHive);
}

Future<void> putTodo(TodoList newTodo, Box<TodoList> box) async {
  // final Box<TodoList> box = Hive.box(todoBoxHive);
  await box.put(todosHive, newTodo);
}

Future<void> updateHiveTodo({
  required int index,
  bool? isCompleted,
  String? title,
  required Box<TodoList> box,
}) async {
  // final Box<TodoList> box = Hive.box(todoBoxHive);
  final todoList = box.getAt(0);
  final TodoModel? todo = todoList?.todos?[index];
  // for status udpate
  if (isCompleted != null) {
    todo!.isCompleted = isCompleted;
  }

  // for title update
  if (title != null) {
    todo!.title = title;
  }
  await box.putAt(0, todoList ?? TodoList(todos: []));
}
