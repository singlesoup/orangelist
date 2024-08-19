import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orangelist/src/home/provider/todo_provider.dart';
import 'package:orangelist/src/home/data/todo_list.dart';
import 'package:orangelist/src/home/data/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/widgets.dart';

class MockBox extends Mock implements Box<TodoList> {}

class MockBuildContext extends Mock implements BuildContext {
  @override
  bool get mounted => true;
}

void main() {
  setUpAll(() {
    // [Note]: This is need is there are any null values for the following
    registerFallbackValue(TodoList(todos: []));
    registerFallbackValue(MockBox());
  });

  late MockBox mockBox;
  late TodoProvider todoProvider;
  late BuildContext mockContext;

  setUp(() {
    mockBox = MockBox();
    todoProvider = TodoProvider(todoBox: mockBox);
    mockContext = MockBuildContext();

    // Define what happens when hive methods are called
    when(() => mockBox.get(any())).thenReturn(TodoList(todos: []));
    when(() => mockBox.getAt(any())).thenReturn(TodoList(todos: []));
    when(() => mockBox.put(any(), any()))
        .thenAnswer((_) async => Future.value());
    when(() => mockBox.putAt(any(), any()))
        .thenAnswer((_) async => Future.value());
  });

  group('when tested for crud operations for hive: ', () {
    /// Add todo
    group('given we call todoProvider.addTodo(), ', () {
      group('should add a new todo to hive:', () {
        test('Adding a new todo -', () async {
          when(() => mockBox.put(any(), any()))
              .thenAnswer((_) async => Future.value());

          // perform addition
          await todoProvider.addTodo('New Task', mockContext);

          // Verify the box put method was called
          List captured = verify(() => mockBox.put(any(), captureAny()))
              .captured as List<Object?>;

          debugPrint('captured data :${captured[0].todos.first.title}');
          // Check results
          expect(captured[0].todos.length, 1);
          expect(captured[0].todos.first.title, 'New Task');
        });
      });
    });

    /// Get todo
    group('given we call todoProvider.getData(), ', () {
      group('should get todos saved from hive:', () {
        test('Get todo returns exisiting todo - ', () {
          when(() => mockBox.get(any())).thenReturn(TodoList(
              todos: [TodoModel(title: 'Existing Task', isCompleted: false)]));

          todoProvider.getData();
          expect(todoProvider.dailyToDolist.length, 1);
          expect(todoProvider.dailyToDolist.first.title, 'Existing Task');
        });
      });
    });

    /// Delete Todo
    group('given we call  todoProvider.deleteTodo(), ', () {
      group('should delete a todo from hive:', () {
        test('Deleting a todo so list is empty -', () {
          // Setup
          when(() => mockBox.get(any())).thenReturn(TodoList(todos: [
            TodoModel(title: 'Task to be deleted', isCompleted: false)
          ]));
          when(() => mockBox.put(any(), any()))
              .thenAnswer((_) async => Future.value());

          // action
          todoProvider.getData();
          todoProvider.deleteTodo(0, mockContext);

          /// Verify
          verify(() => mockBox.put(any(), any()));

          expect(todoProvider.dailyToDolist.isEmpty, true);
        });
      });
    });

    /// Update title of a todo
    group('given we call todoProvider.updateTodo(), ', () {
      group('shoud update the title of an existing todo:', () {
        test('Update a old todo to -', () async {
          when(() => mockBox.getAt(any())).thenReturn(TodoList(
              todos: [TodoModel(title: 'Old task', isCompleted: false)]));

          todoProvider.addTodo('Old Task', mockContext);

          when(() => mockBox.put(
              any(),
              TodoList(todos: [
                TodoModel(title: 'Updated Task', isCompleted: false)
              ]))).thenAnswer((_) async => Future.value());

          // Perform the update
          await todoProvider.updateTodo(0, 'Updated Task', mockContext);

          // Check if the captured value is as expected
          expect(todoProvider.dailyToDolist.first.title, 'Updated Task');
        });
      });
    });

    /// Update status of a todo
    group('given we call todoProvider.updateTodoStatus(), ', () {
      group('should update the status of an exisiting todo:', () {
        test('Update the status of a todo -', () async {
          // Action Setup
          when(() => mockBox.getAt(any())).thenReturn(TodoList(todos: [
            TodoModel(title: 'Incomplete task', isCompleted: false)
          ]));

          todoProvider.addTodo('Incomplete task', mockContext);

          when(() => mockBox.put(
              any(),
              TodoList(todos: [
                TodoModel(title: 'Incomplete task', isCompleted: true)
              ]))).thenAnswer((_) async => Future.value());

          // Perform action
          await todoProvider.updateTodoStatus(0, true, mockContext);

          // expect and verify
          expect(todoProvider.dailyToDolist.first.isCompleted, true);
        });
      });
    });
  });

  tearDownAll(() {
    todoProvider.isTestMode = false;
  });
}
