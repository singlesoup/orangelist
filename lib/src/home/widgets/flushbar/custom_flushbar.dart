import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart'
    show BorderRadius, BuildContext, Center, EdgeInsets, Padding;
import 'package:another_flushbar/flushbar.dart' show Flushbar, FlushbarPosition;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:orangelist/src/theme/colors.dart'
    show bgDark, sandAccent, themeColor;
import 'package:orangelist/src/utils/global_size.dart';

void showCustomFlushBar(BuildContext context, String message) {
  Flushbar(
    message: message,
    titleColor: sandAccent,
    messageColor: sandAccent,
    backgroundColor: bgDark,
    margin: kIsWeb
        ? EdgeInsets.symmetric(
            horizontal:
                determineSnackbarSize(GlobalMediaQuerySize.screenWidth!),
            vertical: 22,
          )
        : const EdgeInsets.all(12),
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

double determineSnackbarSize(double screenWidth) {
  double horizontalPadding; // it should be 630
  if (screenWidth < 450) {
    horizontalPadding = 6;
  } else if (screenWidth < 580) {
    horizontalPadding = 6;
  } else if (screenWidth < 939) {
    horizontalPadding = screenWidth * 0.18;
  } else if (screenWidth < 1310) {
    horizontalPadding = screenWidth * 0.22;
  } else {
    horizontalPadding = screenWidth * 0.36;
  }
  return horizontalPadding;
}
