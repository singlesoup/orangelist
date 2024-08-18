import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show IconButton, MaterialPageRoute;
import 'package:flutter/widgets.dart'
    show
        Align,
        Alignment,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Container,
        EdgeInsets,
        Flexible,
        Navigator,
        Radius,
        Row,
        Spacer,
        StatelessWidget,
        Text,
        Widget;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:orangelist/src/home/screens/settingsPage/screens/settings_page.dart'
    show SettingsPage;
import 'package:orangelist/src/home/widgets/web_app_outline_widget.dart'
    show WebAppOutlineWidget;
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      margin: const EdgeInsets.only(
        left: 14,
        right: 14,
        top: 12,
      ),
      child: Row(
        children: [
          const Spacer(),
          Text(
            'Orangelist',
            style: sfTextTheme.titleLarge,
          ),
          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => kIsWeb
                          ? const WebAppOutlineWidget(child: SettingsPage())
                          : const SettingsPage(),
                    ),
                  );
                },
                icon: const FaIcon(
                  FontAwesomeIcons.gear,
                  color: sandAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
