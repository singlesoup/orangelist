import 'package:flutter/material.dart';
import 'package:orangelist/src/home/provider/todo_provider.dart';
import 'package:orangelist/src/theme/colors.dart';
import 'package:provider/provider.dart';

class CreateTaskBar extends StatefulWidget {
  const CreateTaskBar({
    super.key,
  });

  @override
  State<CreateTaskBar> createState() => _CreateTaskBarState();
}

class _CreateTaskBarState extends State<CreateTaskBar> {
  bool _isActive = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode focusN = FocusNode();
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
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isActive = !_isActive;
                });
              },
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
                    _controller.text = editText;
                    _isActive = true;
                    return TextField(
                      focusNode: focusN,
                      controller: _controller,
                      cursorColor: sandAccent,
                      enabled: _isActive,
                      decoration: InputDecoration(
                        hintText: 'add your next task',
                        hintStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: sandAccent.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 14.0,
                        ),
                        border: InputBorder.none,
                      ),
                      // onChanged: (String value) {},
                      // onSubmitted: (text) {},
                    );
                  },
                ),
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
                                  _isActive = false;
                                  focusN.unfocus();
                                  _controller.text = '';
                                  todo.todoIndex = -1;
                                });
                              },
                              backgroundColor: themeColor,
                              child: const Icon(
                                Icons.close,
                                color: bgDark,
                                size: 34,
                                weight: 22,
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
                  var todoProvider = context.read<TodoProvider>();
                  setState(() {
                    _isActive = true;
                    if (!focusN.hasFocus) {
                      focusN.requestFocus();
                    }

                    if (todoProvider.todoIndex == -1) {
                      todoProvider.addTodo(_controller.text);
                    } else {
                      todoProvider.updateTodo(
                          todoProvider.todoIndex, _controller.text);
                      todoProvider.todoIndex = -1;
                    }
                    _controller.text = '';
                  });
                },
                backgroundColor: themeColor,
                child: const Icon(
                  Icons.add_rounded,
                  color: bgDark,
                  size: 38,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
