import 'package:flutter/material.dart' show Icon, Icons;
import 'package:flutter/widgets.dart'
    show
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Container,
        EdgeInsets,
        Expanded,
        FontWeight,
        Radius,
        ReorderableDragStartListener,
        Row,
        StatelessWidget,
        Text,
        Widget;

import 'package:orangelist/src/theme/colors.dart' show sandAccent;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;

class ReOrderTile extends StatelessWidget {
  const ReOrderTile({
    super.key,
    required this.index,
    required this.title,
  });

  final int index;
  final String title;

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
        vertical: 20,
        horizontal: 24,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: sfTextTheme.titleMedium!.copyWith(
                color: sandAccent,
                fontWeight: FontWeight.w700,
                decorationColor: sandAccent,
              ),
            ),
          ),
          ReorderableDragStartListener(
            index: index,
            child: const Icon(
              Icons.drag_handle_rounded,
              color: sandAccent,
            ),
          ),
        ],
      ),
    );
  }
}
