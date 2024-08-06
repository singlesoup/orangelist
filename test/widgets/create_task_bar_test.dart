import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orangelist/src/constants/strings.dart';
import 'package:orangelist/src/home/data/todo_list.dart';
import 'package:orangelist/src/home/provider/todo_provider.dart';
import 'package:orangelist/src/home/widgets/create_task_bar.dart';
import 'package:provider/provider.dart';

class MockBox extends Mock implements Box<TodoList> {}

///[NOTE]: Running theses test on web, is giving Semantics Handle leak error
// but ran with command line it passes
/// ref: https://github.com/flutter/flutter/issues/121640

/// Tests for CreateTaskBar
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

  testWidgets('CreateTaskBar shows hint Text :', (WidgetTester tester) async {
    // Since we are using ListView and ReOrderable List View, which comes from semantics tree
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => todoProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: CreateTaskBar(),
          ),
        ),
      ),
    );
    expect(find.text('add your next task'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('CreateTaskBar adds a task on tap: ',
      (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => todoProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: CreateTaskBar(),
          ),
        ),
      ),
    );

    // Simulate entering text into the text field
    await tester.enterText(find.byType(TextField), 'New Task');

    // Simulate pressing the add button
    await tester.tap(find.byKey(const Key(plusTodoKey)));

    // Set state in testing env
    await tester.pump();

    //verify
    expect(todoProvider.dailyToDolist.length, 1);
    expect(todoProvider.dailyToDolist.first.title, 'New Task');

    semantics.dispose();
  });
}
