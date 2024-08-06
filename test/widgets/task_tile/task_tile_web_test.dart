import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orangelist/main.dart';
import 'package:orangelist/src/home/data/todo_list.dart';
import 'package:orangelist/src/home/provider/todo_provider.dart';
import 'package:orangelist/src/home/screens/homescreen.dart';
import 'package:provider/provider.dart';

import 'package:orangelist/src/constants/strings.dart'
    show deleteKey, editKey, homeScreenKey;

class MockBox extends Mock implements Box<TodoList> {}

class MockBuildContext extends Mock implements BuildContext {
  @override
  bool get mounted => true;
}

void main() {
  setUpAll(() {
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

    // Mocking hive methods
    /// [Note]: Its important that we mock all the operation in that dependency
    /// has to do for it to be working in test env.
    when(() => mockBox.get(any())).thenReturn(TodoList(todos: []));
    when(() => mockBox.getAt(any())).thenReturn(TodoList(todos: []));
    when(() => mockBox.put(any(), any()))
        .thenAnswer((_) async => Future.value());
    when(() => mockBox.putAt(any(), any()))
        .thenAnswer((_) async => Future.value());
  });

  group('Testing the TaskTileWidget in web:', () {
    // Rendering homscreen
    testWidgets('HomeScreen renders without errors',
        (WidgetTester tester) async {
      // final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => todoProvider,
          child: MyApp(
            hiveBox: mockBox,
          ),
        ),
      );

      final homeScreen = find.byKey(const Key(homeScreenKey));
      expect(homeScreen, findsOneWidget);
      // semantics.dispose();
    });

    // Displaying Todos
    testWidgets('TaskTileWidget displays todo', (WidgetTester tester) async {
      String title1 = 'Display Todo';

      // Adding todos for testing
      todoProvider.addTodo(title1, mockContext);

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => todoProvider,
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the presence of the first todo
      final firstTodo = find.byKey(Key('$title1-0'));
      expect(firstTodo, findsOneWidget);
    });

    testWidgets('Editing a todo in TasktileWidget',
        (WidgetTester tester) async {
      todoProvider.isTestMode = true;
      String title1 = 'Edit Todo';

      // Adding todos for testing
      todoProvider.addTodo(title1, mockContext);
      todoProvider.isReorder = false;
      todoProvider.focusMode = false;

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => todoProvider,
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      await tester.pumpAndSettle();
      debugPrint('index before tap: ${todoProvider.todoIndex}');

      // Find the edit button
      final editIconFinder = find.byKey(const Key(editKey));

      // Check if the edit button is present
      expect(editIconFinder, findsOneWidget);

      // Tap the edit button
      await tester.tap(editIconFinder);
      await tester.pumpAndSettle();

      debugPrint('index after tap: ${todoProvider.todoIndex}');

      // Verify that the todoIndex was set correctly
      expect(todoProvider.todoIndex, 0);
      todoProvider.isTestMode = false;
    });

    /// Deleting a todo has multiple widget tests
    ///

    group('when tapped on a delete icon', () {
      group('given in the web env', () {
        // Alert Dialog
        testWidgets('shows an alert dialog', (WidgetTester tester) async {
          todoProvider.isTestMode = true;
          String title1 = 'Delete Todo';

          // Adding todos for testing
          todoProvider.addTodo(title1, mockContext);
          todoProvider.isReorder = false;
          todoProvider.focusMode = false;

          await tester.pumpWidget(
            ChangeNotifierProvider(
              create: (_) => todoProvider,
              child: const MaterialApp(home: HomeScreen()),
            ),
          );

          await tester.pumpAndSettle();

          // Find the edit button
          final deleteIconFinder = find.byKey(const Key(deleteKey));

          // Check if the edit button is present
          expect(deleteIconFinder, findsOneWidget);

          // Tap the edit button
          await tester.tap(deleteIconFinder);
          await tester.pumpAndSettle();

          // Verify that the dialog is shown
          expect(find.byType(PlatformAlertDialog), findsOneWidget);
        });

        // Cancel button
        testWidgets('pressing the cancel button', (WidgetTester tester) async {
          todoProvider.isTestMode = true;
          String title1 = 'Cancel Todo';

          // Adding todos for testing
          todoProvider.addTodo(title1, mockContext);
          todoProvider.isReorder = false;
          todoProvider.focusMode = false;

          await tester.pumpWidget(
            ChangeNotifierProvider(
              create: (_) => todoProvider,
              child: const MaterialApp(home: HomeScreen()),
            ),
          );

          await tester.pumpAndSettle();

          // Find the edit button
          final deleteIconFinder = find.byKey(const Key(deleteKey));

          // Check if the edit button is present
          expect(deleteIconFinder, findsOneWidget);

          // Tap the edit button
          await tester.tap(deleteIconFinder);
          await tester.pumpAndSettle();

          // Verify that the dialog is shown
          expect(find.byType(PlatformAlertDialog), findsOneWidget);

          // Check for cancel button
          final cancelButton = find.text('Cancel');
          expect(cancelButton, findsOneWidget);

          // Test Cancel button
          await tester.tap(cancelButton);
          await tester.pumpAndSettle();

          // Verify
          // Dialog should be dismissed, todo should still exist
          expect(find.byType(PlatformAlertDialog), findsNothing);
          expect(todoProvider.dailyToDolist.length, 1);
        });

        // Delete button
        testWidgets('pressing the delete button', (WidgetTester tester) async {
          todoProvider.isTestMode = true;
          String title1 = 'Del Todo';

          // Adding todos for testing
          todoProvider.addTodo(title1, mockContext);
          todoProvider.isReorder = false;
          todoProvider.focusMode = false;

          await tester.pumpWidget(
            ChangeNotifierProvider(
              create: (_) => todoProvider,
              child: const MaterialApp(home: HomeScreen()),
            ),
          );

          await tester.pumpAndSettle();

          // Find the edit button
          final deleteIconFinder = find.byKey(const Key(deleteKey));

          // Check if the edit button is present
          expect(deleteIconFinder, findsOneWidget);

          // Tap the edit button
          await tester.tap(deleteIconFinder);
          await tester.pumpAndSettle();

          debugPrint('The todos before: ${todoProvider.dailyToDolist.length}');

          // Verify that the dialog is shown
          expect(find.byType(PlatformAlertDialog), findsOneWidget);

          // Check for delete button
          final deleteButton = find.text('Delete');
          expect(deleteButton, findsOneWidget);

          // Test Delete button
          await tester.tap(deleteButton);
          await tester.pumpAndSettle();

          debugPrint('The todos after: ${todoProvider.dailyToDolist.length}');

          // verify
          // Dialog should be dismissed, todo should be deleted
          expect(find.byType(PlatformAlertDialog), findsNothing);
          expect(todoProvider.dailyToDolist.length, 0);
        });
      });
    });
  });
}
