import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  TodoModel({
    required this.title,
    required this.isCompleted,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;
}
