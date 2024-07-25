import 'dart:math' show Random;

import 'package:flutter/widgets.dart'
    show
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Column,
        Container,
        EdgeInsets,
        Expanded,
        Flexible,
        MainAxisAlignment,
        MainAxisSize,
        Padding,
        Radius,
        SizedBox,
        StatelessWidget,
        Text,
        TextAlign,
        Widget;
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:orangelist/src/constants/strings.dart' show noTodosStr;
import 'package:orangelist/src/theme/colors.dart' show sandAccent;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;
import 'package:orangelist/src/utils/global_size.dart'
    show GlobalMediaQuerySize;

class NoTodos extends StatelessWidget {
  const NoTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomSvgIndex = random.nextInt(8) + 1;
    return Container(
      height: GlobalMediaQuerySize.screenHeight! * 0.44,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(22.0),
        ),
        border: Border.all(
          color: sandAccent.withOpacity(0.4),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: sandAccent,
                borderRadius: BorderRadius.all(
                  Radius.circular(22.0),
                ),
              ),
              child: SvgPicture.asset(
                'assets/svgs/svg$randomSvgIndex.svg',
              ),
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
                left: 12,
                right: 12,
              ),
              child: Text(
                noTodosStr,
                style: sfTextTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
