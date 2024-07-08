import 'package:flutter/widgets.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Container,
        EdgeInsets,
        LayoutBuilder,
        Padding,
        Radius,
        StatelessWidget,
        Widget;
import 'package:orangelist/src/theme/colors.dart' show bgDark, sandAccent;

class WebAppOutlineWidget extends StatelessWidget {
  const WebAppOutlineWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgDark,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // debugPrint(constraints.maxWidth.toString());
          double horizontalPadding;
          if (constraints.maxWidth < 450) {
            horizontalPadding = constraints.maxWidth * 0.02;
          } else if (constraints.maxWidth < 580) {
            horizontalPadding = constraints.maxWidth * 0.1;
          } else if (constraints.maxWidth < 939) {
            horizontalPadding = constraints.maxWidth * 0.18;
          } else if (constraints.maxWidth < 1310) {
            horizontalPadding = constraints.maxWidth * 0.22;
          } else {
            horizontalPadding = constraints.maxWidth * 0.36;
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: sandAccent.withOpacity(0.4),
                borderRadius: const BorderRadius.all(
                  Radius.circular(22.0),
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
