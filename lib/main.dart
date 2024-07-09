import 'dart:async' show runZonedGuarded;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart'
    show Brightness, MaterialApp, ThemeData, Widget, runApp;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

import 'package:flutter/widgets.dart'
    show BuildContext, StatelessWidget, WidgetsFlutterBinding;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/screens/homescreen.dart' show HomeScreen;
import 'package:orangelist/src/home/widgets/web_app_outline_widget.dart'
    show WebAppOutlineWidget;

import 'package:orangelist/src/utils/hive_service.dart' show initHive;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

// import 'src/onboarding/screens/on_boarding_screen.dart';
import 'src/theme/text_theme.dart' show sfTextTheme;

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initHive();
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
          .then((_) {
        runApp(const MyApp());
      });
    } else {
      runApp(const MyApp());
    }
  }, (error, stack) {
    // Use firebase crashlytics if added
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: sfTextTheme,
          brightness: Brightness.dark,
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TodoProvider(),
            ),
          ],
          child: kIsWeb
              ? const WebAppOutlineWidget(
                  child: HomeScreen(),
                )
              : const HomeScreen(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
