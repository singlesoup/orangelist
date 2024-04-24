import 'package:flutter/material.dart';
import 'package:orangelist/src/theme/colors.dart';

class CreateTaskBar extends StatefulWidget {
  const CreateTaskBar({super.key});

  @override
  State<CreateTaskBar> createState() => _CreateTaskBarState();
}

class _CreateTaskBarState extends State<CreateTaskBar> {
  bool _isActive = false;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 18,
      ),
      child: Row(
        children: [
          // TODO : Pop this container from right, once the FAB is pressed
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
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                cursorColor: sandAccent,
                enabled: _isActive,
                decoration: const InputDecoration(
                  hintText: 'add your next task',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 14.0,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (text) {},
              ),
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              onPressed: () {},
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
