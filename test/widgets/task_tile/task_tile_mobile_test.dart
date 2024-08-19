import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:orangelist/main.dart';
import 'package:orangelist/src/constants/strings.dart';
import 'package:orangelist/src/home/data/todo_list.dart';
import 'package:orangelist/src/home/provider/todo_provider.dart';
import 'package:orangelist/src/home/screens/homescreen.dart';
import 'package:provider/provider.dart';

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

  group('Testing the TaskTileWidget in mobile:', () {
    // Rendering homscreen
    testWidgets('HomeScreen renders without errors',
        (WidgetTester tester) async {
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
    });

    // Displaying Todos
    testWidgets('TaskTileWidget displays todo', (WidgetTester tester) async {
      String title1 = '1st Todo';

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
      final firstTodo = find.byKey(Key('$dismissibleTileKey$title1-0'));
      expect(firstTodo, findsOneWidget);
    });

    group('Swipes test', () {
      testWidgets('Swipe right to edit a Todo', (WidgetTester tester) async {
        String todo = '1st Todo';

        todoProvider.addTodo(todo, mockContext);
        await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (_) => todoProvider,
            child: const MaterialApp(home: HomeScreen()),
          ),
        );

        await tester.pumpAndSettle();

        debugPrint('index before swipe: ${todoProvider.todoIndex}');

        final todoFinder = find.byKey(Key('$dismissibleTileKey$todo-0'));

        // Swipe right to edit
        await tester.drag(todoFinder, const Offset(500, 0));

        await tester.pumpAndSettle();

        debugPrint('index after swipe: ${todoProvider.todoIndex}');

        // Verify that the todoIndex was set correctly
        expect(todoProvider.todoIndex, 0);
      });

      /// Deleting a todo has multiple widgets tests
      group('when a dismissible widget', () {
        group('is given for mobile app version,', () {
          group('should delete that todo on swipe left: ', () {
            // Dialog
            testWidgets('shows an alert dialog -', (WidgetTester tester) async {
              String delTodo = 'Some Todo';
              todoProvider.addTodo(delTodo, mockContext);

              await tester.pumpWidget(
                ChangeNotifierProvider(
                  create: (_) => todoProvider,
                  child: const MaterialApp(home: HomeScreen()),
                ),
              );

              await tester.pumpAndSettle();

              final todoFinder =
                  find.byKey(Key('$dismissibleTileKey$delTodo-0'));

              if (!kIsWeb) {
                // Swipe left to delete
                await tester.drag(todoFinder, const Offset(-500, 0));
              }

              await tester.pumpAndSettle();

              // Verify that the dialog is shown
              expect(find.byType(PlatformAlertDialog), findsOneWidget);
            });

            // Cancel button
            testWidgets('pressing the cancel button',
                (WidgetTester tester) async {
              String delTodo = 'Some Todo';
              todoProvider.addTodo(delTodo, mockContext);

              await tester.pumpWidget(
                ChangeNotifierProvider(
                  create: (_) => todoProvider,
                  child: const MaterialApp(home: HomeScreen()),
                ),
              );

              await tester.pumpAndSettle();

              final todoFinder =
                  find.byKey(Key('$dismissibleTileKey$delTodo-0'));

              if (!kIsWeb) {
                // Swipe left to delete
                await tester.drag(todoFinder, const Offset(-500, 0));
              }

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
              expect(todoFinder, findsOneWidget);
            });
          });

          // Delete button
          testWidgets('pressing the delete button',
              (WidgetTester tester) async {
            String delTodo = 'Some Todo';
            todoProvider.addTodo(delTodo, mockContext);

            await tester.pumpWidget(
              ChangeNotifierProvider(
                create: (_) => todoProvider,
                child: const MaterialApp(home: HomeScreen()),
              ),
            );

            await tester.pumpAndSettle();

            debugPrint(
                'The todos before :${todoProvider.dailyToDolist.length}');

            final todoFinder = find.byKey(Key('$dismissibleTileKey$delTodo-0'));

            if (!kIsWeb) {
              // Swipe left to delete
              await tester.drag(todoFinder, const Offset(-500, 0));
            }

            await tester.pumpAndSettle();

            // Verify that the dialog is shown
            expect(find.byType(PlatformAlertDialog), findsOneWidget);

            // finding the button
            final delButton = find.text('Delete');
            expect(delButton, findsOneWidget);

            // Test delete button
            await tester.tap(delButton);
            await tester.pumpAndSettle();

            debugPrint('The todos after :${todoProvider.dailyToDolist.length}');

            // verify
            // Dialog should be dismissed, todo should be deleted
            expect(find.byType(PlatformAlertDialog), findsNothing);
            expect(todoFinder, findsNothing);
          });
        });
      });
    });
  });

  tearDownAll(() {
    todoProvider.isTestMode = false;
  });
}
