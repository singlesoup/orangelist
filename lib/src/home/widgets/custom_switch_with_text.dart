import 'package:flutter/material.dart'
    show
        MaterialTapTargetSize,
        Switch,
        Widget,
        WidgetState,
        WidgetStateProperty;

import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Color,
        GestureDetector,
        Row,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        Transform;
import 'package:orangelist/src/home/provider/todo_provider.dart';

import 'package:orangelist/src/theme/colors.dart' show sandAccent, themeColor;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;
import 'package:provider/provider.dart';

class CustomSwitchText extends StatefulWidget {
  const CustomSwitchText({
    super.key,
    required this.title,
    required this.callback,
    required this.isForReorder,
  });

  final String title;
  final Function(bool) callback;
  final bool isForReorder;

  @override
  State<CustomSwitchText> createState() => _CustomSwitchTextState();
}

class _CustomSwitchTextState extends State<CustomSwitchText> {
  bool _isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (context, todoprovider, child) {
      if (widget.isForReorder) {
        _isSwitchOn = todoprovider.isReorder;
      } else {
        _isSwitchOn = todoprovider.focusMode;
      }
      return GestureDetector(
        onTap: () {
          setState(() {
            _isSwitchOn = !_isSwitchOn;
            widget.callback(_isSwitchOn);
          });
        },
        onHorizontalDragStart: (details) {
          setState(() {
            _isSwitchOn = !_isSwitchOn;
            widget.callback(_isSwitchOn);
          });
        },
        child: Row(
          children: [
            Text(
              widget.title,
              style: sfTextTheme.bodySmall,
            ),
            const SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 22,
              child: Transform.scale(
                scale: 0.56,
                child: Switch.adaptive(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  thumbColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.selected) ||
                          states.contains(WidgetState.pressed)) {
                        return themeColor;
                      }
                      return sandAccent;
                    },
                  ),
                  activeColor: themeColor,
                  value: _isSwitchOn,
                  onChanged: (bool val) {
                    setState(() {
                      _isSwitchOn = val;
                      widget.callback(_isSwitchOn);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
