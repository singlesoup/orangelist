import 'package:flutter/widgets.dart'
    show BorderRadius, BuildContext, Center, EdgeInsets, Padding;
import 'package:another_flushbar/flushbar.dart' show Flushbar, FlushbarPosition;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:orangelist/src/theme/colors.dart'
    show bgDark, sandAccent, themeColor;

void showCustomFlushBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    titleColor: sandAccent,
    messageColor: sandAccent,
    backgroundColor: bgDark,
    margin: const EdgeInsets.all(12.0),
    borderRadius: BorderRadius.circular(8.0),
    flushbarPosition: FlushbarPosition.BOTTOM,
    duration: const Duration(milliseconds: 1200),
    borderColor: sandAccent,
    icon: const Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 12,
        ),
        child: FaIcon(
          FontAwesomeIcons.checkDouble,
          color: sandAccent,
          size: 22,
        ),
      ),
    ),
    leftBarIndicatorColor: themeColor,
  ).show(context);
}
