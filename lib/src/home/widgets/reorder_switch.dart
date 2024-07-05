import 'package:flutter/material.dart'
    show Switch, Theme, Widget, WidgetState, WidgetStateProperty;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Color,
        MainAxisAlignment,
        Row,
        State,
        StatefulWidget,
        Text,
        Transform;
import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/theme/colors.dart' show sandAccent, themeColor;
import 'package:provider/provider.dart' show ReadContext;

class ReorderSwitch extends StatefulWidget {
  const ReorderSwitch({super.key});

  @override
  State<ReorderSwitch> createState() => _ReorderSwitchState();
}

class _ReorderSwitchState extends State<ReorderSwitch> {
  bool _toReorderTodos = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Re-order',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Transform.scale(
          scale: 0.6,
          child: Switch.adaptive(
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
            value: _toReorderTodos,
            onChanged: (bool val) {
              setState(() {
                _toReorderTodos = val;
                context.read<TodoProvider>().isReorder = val;
              });
            },
          ),
        ),
      ],
    );
  }
}
