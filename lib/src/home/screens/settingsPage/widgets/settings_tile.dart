import 'package:flutter/material.dart' show Border, IconButton, ListTile;
import 'package:flutter/widgets.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Container,
        EdgeInsets,
        FontWeight,
        IconData,
        Radius,
        StatelessWidget,
        Text,
        Widget;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:orangelist/src/theme/colors.dart' show sandAccent;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sandAccent.withOpacity(0.08),
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
        border: Border.all(
          color: sandAccent,
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 8,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: ListTile(
        onTap: () => onTap(),
        leading: FaIcon(
          icon,
          color: sandAccent,
          size: 18,
        ),
        title: Text(
          title,
          style: sfTextTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: IconButton(
          onPressed: () => onTap(),
          icon: const FaIcon(
            FontAwesomeIcons.chevronRight,
            color: sandAccent,
            size: 18,
          ),
        ),
      ),
    );
  }
}
