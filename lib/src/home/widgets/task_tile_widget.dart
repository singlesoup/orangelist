import 'package:flutter/material.dart' show Colors, IconButton, Icons, Theme;
import 'package:flutter/widgets.dart'
    show
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Container,
        EdgeInsets,
        FontWeight,
        Icon,
        MainAxisAlignment,
        Radius,
        Row,
        StatelessWidget,
        Text,
        Widget;
import 'package:orangelist/src/theme/colors.dart' show sandAccent;

class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget({
    super.key,
    required this.taskTitle,
  });

  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sandAccent.withOpacity(0.08),
        borderRadius: const BorderRadius.all(
          Radius.circular(18.0),
        ),
        border: Border.all(
          color: sandAccent,
          width: 0.8,
        ),
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            taskTitle,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: sandAccent,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mode_edit_outline_outlined,
                    color: sandAccent,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  splashColor: Colors.red.withOpacity(0.8),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: sandAccent,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
