import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart'
    show
        FloatingActionButton,
        FocusNode,
        InputBorder,
        InputDecoration,
        State,
        StatefulWidget,
        TextEditingController,
        TextField,
        Tooltip;

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
        MainAxisAlignment,
        Padding,
        Radius,
        RoundedRectangleBorder,
        Row,
        SizedBox,
        TextPosition,
        TextSelection,
        ValueListenableBuilder,
        ValueNotifier,
        Widget;

import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FaIcon, FontAwesomeIcons;
import 'package:orangelist/src/constants/strings.dart' show hintText;

import 'package:orangelist/src/home/provider/todo_provider.dart'
    show TodoProvider;
import 'package:orangelist/src/theme/colors.dart'
    show bgDark, sandAccent, themeColor;
import 'package:orangelist/src/theme/text_theme.dart' show sfTextTheme;
import 'package:provider/provider.dart' show Consumer, ReadContext;

class CreateTaskBar extends StatefulWidget {
  const CreateTaskBar({
    super.key,
  });

  @override
  State<CreateTaskBar> createState() => _CreateTaskBarState();
}

class _CreateTaskBarState extends State<CreateTaskBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode focusN = FocusNode();
  final ValueNotifier<String> _hoverText = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _updateTooltipText(context);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() => _updateTooltipText);
    _controller.dispose();
    _hoverText.dispose();
    super.dispose();
  }

  void _updateTooltipText(BuildContext? context) {
    var todoProvider = context?.read<TodoProvider>();
    if (todoProvider?.todoIndex != -1 &&
        _controller.text == todoProvider?.editTodo()) {
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
    if (kIsWeb) {
      _hoverText.value = _controller.text;
    }
  }

  // To only show tool tip msg for web
  String toolTipMessage(String value, String editText) {
    String text = '';
    if (kIsWeb && value.isNotEmpty && editText.isNotEmpty) {
      text = value;
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
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
              child: Consumer<TodoProvider>(
                builder: (context, todo, child) {
                  String editText = todo.editTodo();
                  if (_controller.text != editText) {
                    // Defer setting text to ensure it doesn't interfere with the build process
                    _controller.text = editText;
                  }
                  return ValueListenableBuilder<String>(
                    valueListenable: _hoverText,
                    builder: (context, value, child) {
                      return Tooltip(
                        padding: const EdgeInsets.all(12),
                        message: toolTipMessage(value, editText),
                        preferBelow: true,
                        verticalOffset: 30,
                        textStyle: sfTextTheme.bodyLarge!.copyWith(
                          color: sandAccent.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          color: bgDark,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(22.0),
                          ),
                          border: Border.all(
                            color: sandAccent,
                          ),
                        ),
                        child: TextField(
                          focusNode: focusN,
                          controller: _controller,
                          cursorColor: sandAccent,
                          enableInteractiveSelection: true,
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: sfTextTheme.bodyLarge!.copyWith(
                              color: sandAccent.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 14.0,
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (String val) {
                            if (kIsWeb && val.isNotEmpty) {
                              var todoProvider = context.read<TodoProvider>();
                              if (todoProvider.todoIndex == -1) {
                                todoProvider.addTodo(val, context);
                              }
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<TodoProvider>(
                builder: (context, todo, child) {
                  return todo.todoIndex != -1
                      ? Row(
                          children: [
                            FloatingActionButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              onPressed: () {
                                setState(() {
                                  focusN.unfocus();
                                  _controller.clear();
                                  todo.todoIndex = -1;
                                });
                              },
                              backgroundColor: themeColor,
                              child: const FaIcon(
                                FontAwesomeIcons.xmark,
                                color: bgDark,
                                size: 32,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                          ],
                        )
                      : Container();
                },
              ),
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    if (!focusN.hasFocus) {
                      setState(() {
                        focusN.requestFocus();
                      });
                    }
                  } else {
                    var todoProvider = context.read<TodoProvider>();
                    if (todoProvider.todoIndex == -1) {
                      todoProvider.addTodo(_controller.text, context);
                    } else {
                      todoProvider.updateTodo(
                          todoProvider.todoIndex, _controller.text, context);
                      todoProvider.todoIndex = -1;
                    }
                    focusN.unfocus();
                    _controller.clear();
                  }
                },
                backgroundColor: themeColor,
                child: const FaIcon(
                  FontAwesomeIcons.plus,
                  color: bgDark,
                  size: 32,
                  // todo: find apt size for icons
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
