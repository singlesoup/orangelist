import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orangelist/src/home/data/todo_list.dart';
import 'package:orangelist/src/home/provider/todo_provider.dart';

class MockBox extends Mock implements Box<TodoList> {}

void main() {
  setUpAll(() {
    registerFallbackValue(TodoList(todos: []));
    registerFallbackValue(MockBox());
  });

  late MockBox mockBox;
  late TodoProvider todoProvider;

  setUp(() {
    mockBox = MockBox();
    todoProvider = TodoProvider(todoBox: mockBox);
    // Mocking get and put
    /// [Note]: Its important that we mock all the operation in that dependency
    /// has to do for it to be working in test env.
    when(() => mockBox.get(any())).thenReturn(TodoList(todos: []));
    when(() => mockBox.put(any(), any())).thenAnswer((_) async {});
  });

  testWidgets(
      'TaskTile Widget displays a task title', (WidgetTester tester) async {});
}
