import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show CircleAvatar;
import 'package:flutter/widgets.dart'
    show
        Align,
        Alignment,
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Center,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        Expanded,
        FontWeight,
        MainAxisAlignment,
        MainAxisSize,
        Padding,
        Radius,
        Row,
        StatelessWidget,
        Text,
        Widget;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/home/widgets/custom_switch_with_text.dart'
    show CustomSwitchText;

import 'package:orangelist/src/theme/colors.dart'
    show bgDark, sandAccent, themeColor;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;
import 'package:provider/provider.dart' show Consumer, ReadContext;

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(34),
      margin: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgDark,
        borderRadius: const BorderRadius.all(
          Radius.circular(28),
        ),
        border: Border.all(
          color: sandAccent,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Todo Done',
                style: sfTextTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'keep it up',
                style: sfTextTheme.bodyLarge!.copyWith(
                  color: sandAccent,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 3,
                ),
                child: CustomSwitchText(
                  title: 'Re-order',
                  isForReorder: true,
                  callback: (bool val) {
                    var provider = context.read<TodoProvider>();
                    provider.isReorder = val;
                  },
                ),
              ),
              if (kIsWeb)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  child: CustomSwitchText(
                    title: 'Focus',
                    isForReorder: false,
                    callback: (bool val) {
                      var provider = context.read<TodoProvider>();
                      provider.focusMode = val;
                    },
                  ),
                ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Consumer<TodoProvider>(
                builder: (context, todoprovider, child) {
                  int completedCount = todoprovider.completedCount;
                  int totalLength = todoprovider.dailyToDolist.length;
                  return CircleAvatar(
                    radius: 55,
                    backgroundColor: themeColor,
                    child: Center(
                      child: Text(
                        "$completedCount/$totalLength",
                        style: sfTextTheme.headlineMedium!.copyWith(
                            color: bgDark, fontWeight: FontWeight.w900),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
