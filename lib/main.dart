import 'dart:async' show runZonedGuarded;

import 'package:feedback/feedback.dart' show BetterFeedback, FeedbackThemeData;
import 'package:flutter/foundation.dart' show Key, kIsWeb;
import 'package:flutter/material.dart'
    show Brightness, MaterialApp, ThemeData, Widget, runApp;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

import 'package:flutter/widgets.dart'
    show BuildContext, StatelessWidget, WidgetsFlutterBinding;
import 'package:hive/hive.dart' show Box, Hive;
import 'package:orangelist/src/constants/strings.dart'
    show homeScreenKey, todoBoxHive;
import 'package:orangelist/src/home/data/todo_list.dart' show TodoList;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/screens/homescreen.dart' show HomeScreen;
import 'package:orangelist/src/home/widgets/web_app_outline_widget.dart'
    show WebAppOutlineWidget;
import 'package:orangelist/src/theme/colors.dart'
    show bgDark, sandAccent, themeColor;
import 'package:orangelist/src/utils/global_size.dart'
    show GlobalMediaQuerySize;

import 'package:orangelist/src/utils/hive_service.dart' show initHive;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider;

// import 'src/onboarding/screens/on_boarding_screen.dart';
import 'src/theme/text_theme.dart' show sfTextTheme;
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initHive();
    Box<TodoList> todoBox = Hive.box(todoBoxHive);
    await dotenv.load(fileName: ".env");

    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
        (_) {
          runApp(
            BetterFeedback(
              theme: feedBackTheme(),
              child: MyApp(
                hiveBox: todoBox,
              ),
            ),
          );
        },
      );
    } else {
      runApp(BetterFeedback(
        theme: feedBackTheme(),
        child: MyApp(
          hiveBox: todoBox,
        ),
      ));
    }
  }, (error, stack) {
    // Use crashlytics here
  });
}

FeedbackThemeData feedBackTheme() {
  return FeedbackThemeData(
    background: sandAccent,
    activeFeedbackModeColor: themeColor,
    feedbackSheetColor: bgDark,
    bottomSheetDescriptionStyle: sfTextTheme.titleLarge!,
    bottomSheetTextInputStyle: sfTextTheme.bodyMedium!,
  );
}

class MyApp extends StatelessWidget {
  final Box<TodoList> hiveBox;
  const MyApp({super.key, required this.hiveBox});

  @override
  Widget build(BuildContext context) {
    GlobalMediaQuerySize globalSize = GlobalMediaQuerySize();
    globalSize.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(todoBox: hiveBox),
        ),
      ],
      child: MaterialApp(
        title: 'OrangeList: The Todo App',
        theme: ThemeData(
          textTheme: sfTextTheme,
          brightness: Brightness.dark,
        ),
        home: kIsWeb
            ? const WebAppOutlineWidget(
                child: HomeScreen(
                  key: Key(homeScreenKey),
                ),
              )
            : const HomeScreen(
                key: Key(homeScreenKey),
              ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
