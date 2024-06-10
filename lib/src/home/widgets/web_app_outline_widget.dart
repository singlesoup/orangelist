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
      child: LayoutBuilder(builder: (context, constraints) {
        // debugPrint(constraints.maxWidth.toString());
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 580
                ? constraints.maxWidth < 450
                    ? constraints.maxWidth * 0.02
                    : constraints.maxWidth * 0.1
                : constraints.maxWidth < 939
                    ? constraints.maxWidth * 0.18
                    : constraints.maxWidth > 940 && constraints.maxWidth < 1310
                        ? constraints.maxWidth * 0.28
                        : constraints.maxWidth * 0.36,
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
      }),
    );
  }
}
