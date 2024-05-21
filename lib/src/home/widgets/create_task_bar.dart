import 'package:flutter/material.dart';
import 'package:orangelist/src/theme/colors.dart';

class CreateTaskBar extends StatefulWidget {
  const CreateTaskBar({
    super.key,
    required this.onPressed,
  });

  final Function(String text) onPressed;

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
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isActive = !_isActive;
              });
            },
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: sandAccent.withOpacity(0.1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(28.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              child: TextField(
                focusNode: focusN,
                controller: _controller,
                cursorColor: sandAccent,
                enabled: _isActive,
                decoration: InputDecoration(
                  hintText: 'add your next task',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: sandAccent.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 14.0,
                  ),
                  border: InputBorder.none,
                ),
                // onSubmitted: (text) {},
              ),
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isActive = true;
                  if (!focusN.hasFocus) {
                    focusN.requestFocus();
                  }

                  if (_controller.text.isNotEmpty) {
                    widget.onPressed(_controller.text);
                  }
                });
              },
              backgroundColor: themeColor,
              child: const Icon(
                Icons.add_rounded,
                color: bgDark,
                size: 38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
