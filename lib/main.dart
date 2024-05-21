import 'dart:async';

import 'package:flutter/material.dart'
    show Brightness, MaterialApp, ThemeData, Widget, runApp;
import 'package:flutter/widgets.dart'
    show BuildContext, StatelessWidget, WidgetsFlutterBinding;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/screens/homescreen.dart' show HomeScreen;
import 'package:orangelist/src/utils/hive_service.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

// import 'src/onboarding/screens/on_boarding_screen.dart';
import 'src/theme/text_theme.dart' show sfTextTheme;

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    initHive();
    runApp(const MyApp());
  }, (error, stack) {
    // Use firebase crashlytics if added
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: sfTextTheme,
        brightness: Brightness.dark,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TodoProvider(),
          ),
        ],
        child: const HomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
