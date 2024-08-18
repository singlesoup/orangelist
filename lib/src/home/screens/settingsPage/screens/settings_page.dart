import 'package:feedback/feedback.dart' show BetterFeedback;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show AppBar, IconButton, Scaffold;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        EdgeInsets,
        ListView,
        Navigator,
        Padding,
        StatelessWidget,
        Text,
        Widget;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:orangelist/src/home/screens/settingsPage/constants/submit_feedback.dart'
    show submitFeedback;
import 'package:orangelist/src/home/screens/settingsPage/widgets/settings_tile.dart'
    show SettingsTile;
import 'package:orangelist/src/theme/colors.dart' show bgDark, sandAccent;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;
import 'package:url_launcher/url_launcher.dart' show launchUrl;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: sandAccent,
          ),
        ),
        title: Text(
          'Settings',
          style: sfTextTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            SettingsTile(
              title: "Facing any issue? or Any Feedback?",
              icon: FontAwesomeIcons.comment,
              onTap: () => sendFeedback(context),
            ),
            SettingsTile(
              icon: FontAwesomeIcons.xTwitter,
              title: "@singlesouup",
              onTap: () {
                Uri uri = Uri.parse('https://x.com/singlesouup');
                _lauchurl(uri);
              },
            ),
            SettingsTile(
              icon: FontAwesomeIcons.envelope,
              title: "Contact Me",
              onTap: () {
                Uri uri = Uri.parse('mailto:himanshu.nawalkar@gmail.com');
                _lauchurl(uri);
              },
            ),

            /// TODO: Firebase Remote config
            if (!kIsWeb)
              SettingsTile(
                icon: FontAwesomeIcons.star,
                title: "Rate the App",
                onTap: () {},
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _lauchurl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  sendFeedback(BuildContext context) {
    BetterFeedback.of(context).show((feedback) {
      submitFeedback(
        context: context,
        title: kIsWeb ? "User Feedback web" : "User Feedback app",
        body: feedback.text,
        isWeb: kIsWeb,
        image: feedback.screenshot,
      );
    });
  }
}
