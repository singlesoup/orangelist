import 'package:flutter/widgets.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        Radius,
        SizedBox,
        StatelessWidget,
        Text,
        Widget;
import 'package:orangelist/src/theme/colors.dart' show sandAccent;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;

class AboutBanner extends StatelessWidget {
  const AboutBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sandAccent.withOpacity(0.1),
        borderRadius: const BorderRadius.all(
          Radius.circular(22.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      margin: const EdgeInsets.only(
        left: 14,
        right: 14,
        top: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Orangelist',
            style: sfTextTheme.labelLarge,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'by Soup',
            style: sfTextTheme.bodyMedium,
          ),
          // Todo: Add settings flow as Icon and navigation_utils or auto_route in row
        ],
      ),
    );
  }
}
