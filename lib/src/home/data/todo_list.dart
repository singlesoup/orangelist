import 'package:hive/hive.dart';
import 'package:orangelist/src/home/data/todo_model.dart' show TodoModel;

part 'todo_list.g.dart';

@HiveType(typeId: 1)
class TodoList extends HiveObject {
  TodoList({
    this.todos,
  });

  @HiveField(0)
  List<TodoModel>? todos;
}
